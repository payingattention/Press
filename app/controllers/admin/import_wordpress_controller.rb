class Admin::ImportWordpressController < ApplicationController
  require 'nokogiri'

  before_filter :authenticate_user!

  layout 'admin'

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
    author = User.all.first.id

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
        post.user_id = author
        # Parse out the publish date and use it
        publish_date = item.xpath('pubDate').text.split(', ')[1]
        post.go_live = DateTime.parse(publish_date)
        # Sticky
        post.is_sticky = item.xpath('wp:is_sticky').text
        # Comment allowed
        post.allow_comments = item.xpath('wp:comment_status').text == 'open' ? true : false
        # Get the post id and use it since some folks might like that
        post.id = item.xpath('wp:post_id').text

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

        end

      end

      flash[:success] = "We just successfully imported #{import_count} posts"
    else
      flash[:warning] = 'The export file you submitted appears to have no valid items for import'
    end

    redirect_to :controller => 'admin/import_wordpress', :action => 'new'
  end

end
