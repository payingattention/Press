class Admin::ImportWordpressController < AdminController
  require 'nokogiri'

  def new
  end

  def create

    xml_file = params[:xml_file]

    # is the file readable? then do it and convert it
    if xml_file.respond_to?(:read)
      xml_contents = xml_file.read
    # is this just a path to a readable file?  then do it and convert it
    elsif xml_file.respond_to?(:path)
      xml_contents = File.read(xml_file.path)
    else
      flash[:error] = 'Unable to read the file you provided'
    end

    parse = Nokogiri::XML(xml_contents)
    items = parse.xpath('//item')

    # @TODO Temp author.. will need to figure this out
    # Get the authors list from the front of the XML file and create new guest authors or whatever.. have a list of users
    # The author list will have a author_login, each item will have a dc:creator that matches that author_login

    author = User.all.first

    import_count = 0
    if items.count > 0
      items.each do |item|
        post = Post.new
        # Title -- no conversion required
        post.title =  item.xpath('title').text
        # Seo Url -- @TODO Check for link collision -- this should be unique
        post.seo_url = item.xpath('wp:post_name').text
        # Content -- Reap out the caption stuff
        post.content = item.xpath('content:encoded')[0].content
        post.content = post.content.gsub(/\[caption.*?align="(.*?)".*?caption="(.*?)"*?\](.*?)\[\/caption\]/, '<div class="caption \\1">\\3<div class="caption-text">\\2</div></div>')
        # Status
        case item.xpath('wp:status').text
          when 'publish'
            post.state = :published
          when 'draft'
            post.state = :draft
          else
            post.state = :published
        end
        # Author -- @TODO Try to parse the user and pick, give "add new" option, or just use admin
        post.user = author
        # Parse out the publish date and use it
        publish_date = item.xpath('pubDate').text.split(', ')[1]
        post.go_live = DateTime.parse(publish_date)
        # Sticky
        post.is_sticky = item.xpath('wp:is_sticky').text
        # Comment allowed
        post.allow_comments = item.xpath('wp:comment_status').text == 'open' ? true : false
        # Get the post id and use it since some folks might like that.. but don't let us collide.. Assign new if collision
        post_id = item.xpath('wp:post_id').text
        post.id = post_id unless Post.find_by_id post_id
        # Get the posts password if there is one
        post.password ||= item.xpath('wp:post_password').text unless item.xpath('wp:post_password').text == ''

        # Save the post itself
        if post.save
          # Increment our count
          import_count += 1

          # POST TAGS -- Generate the taxonomies for this piece of content
          item.xpath('category[@domain="post_tag"]').each do |t|
            # For each of the taxonomies, load a similar taxonomy from the db, or create a new one
            taxonomy = Taxonomy.find_by_seo_url(t.attributes['nicename'].text) || Taxonomy.new
            # If new, assign the text and the nicename then save it
            if taxonomy.new_record?
              taxonomy.name = t.text.downcase
              taxonomy.seo_url = t.attributes['nicename'].text.downcase
              taxonomy.save
            end
            # Add this taxonomy to our post
            post.taxonomies << taxonomy unless post.taxonomies.include? taxonomy
          end

          # CATEGORIES -- Generate the categories for this piece of content
          item.xpath('category[@domain="category"]').each do |t|
            # For each of the taxonomies, load a similar taxonomy from the db, or create a new one
            taxonomy = Taxonomy.find_by_seo_url(t.attributes['nicename'].text) || Taxonomy.new
            # If new, assign the text and the nicename then save it
            if taxonomy.new_record?
              taxonomy.name = t.text.downcase
              taxonomy.seo_url = t.attributes['nicename'].text.downcase
              taxonomy.classification = :category
              taxonomy.save
            end
            # Add this taxonomy to our post
            post.taxonomies << taxonomy unless post.taxonomies.include? taxonomy
          end

          # COMMENTS -- Generate user associations or guest users for posts
          item.xpath('wp:comment').each do |c|
            # Only use comments that have no comment type ( so real comments, not pingbacks )
            if c.xpath('wp:comment_type').text == ''
              comment = Post.new

              # Do we have anything from this author before? Try loading them
              comment_author = User.find_by_email c.xpath('wp:comment_author_email').text
              # If we don't have them, lets generate them a user id as a :guest
              unless comment_author.present? && comment_author.persisted?
                comment_author = User.new
                comment_author.display_name = c.xpath('wp:comment_author').text
                comment_author.email = c.xpath('wp:comment_author_email').text
                comment_author.password = '!Q@W#E$R%T^Y&U*I(O)P'
                comment_author.last_sign_in_ip = c.xpath('wp:comment_author_ip').text
                comment_author.save
              end

              # Is this comment id available? (keeping in mind that it might collide with a post already in the system)
              # try to give it it's WP id, but if you can't then so be it.
              comment_id = c.xpath('wp:comment_id').text
              comment.id = comment_id unless Post.find_by_id comment_id
              comment.user = comment_author
              comment.kind = :comment
              comment.content = c.xpath('wp:comment_content').text
              comment.state = :published
              comment_publish_date = item.xpath('pubDate').text.split(', ')[1]
              comment.go_live = DateTime.parse(comment_publish_date)

              # If we managed to get the author correctly injected, save this comment and assign it to the post
              if comment_author.present? && comment_author.persisted?
                comment.save
                post.posts << comment
              end
            end
          end

        end

      end

      flash[:success] = "We just successfully imported #{import_count} posts"
    else
      flash[:warning] = 'The export file you submitted appears to have no valid items for import'
    end

    redirect_to :controller => 'admin/import_wordpress', :action => 'new'
  end

end
