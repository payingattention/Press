class Admin::ImportWordpressController < ApplicationController

  before_filter :authenticate_user!

  layout 'admin'

  def new
  end

  def create

    xml_file = params[:xml_file]
    import = false

    # is the file readable? then do it and convert it
    if xml_file.respond_to?(:read)
      xml_contents = xml_file.read
      import = Hash.from_xml(xml_contents)
    # is this just a path to a readable file?  then do it and convert it
    elsif xml_file.respond_to?(:path)
      xml_contents = File.read(xml_file.path)
      import = Hash.from_xml(xml_contents)
    else
      flash[:error] = 'Unable to read the file you provided'
    end


    if import && import['rss'] && import['rss']['channel']

      import_count = 0

      # @TODO Temp author.. will need to figure this out
      author = User.all.first.id

      # the array of items
      items = import['rss']['channel']['item']

      if items

        items.each do |i|
          post = Post.new
          # Title -- no conversion required
          post.title = i['title']
          # Seo Url -- @TODO Check for link collision -- this should be unique
          post.seo_url = i['post_name']

          # content -- @TODO Will need to reap the caption system out
          post.content = i['encoded'][0]
          # Strip beginning extra crap from content (This is the CDATA extra shit prepended)
          post.content = post.content.gsub('/^---\n-\s!','')
          # Replace [caption] stuff with actual divs
          post.content = post.content.gsub(/\[caption.*?align="(.*?)".*?caption="(.*?)"*?\](.*?)\[\/caption\]/, '<div class="caption \\1">\\3<div class="caption-text">\\2</div></div>')

          case i['status']
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
          publish_date = i['pubDate'].split(', ')[1]
          post.go_live = DateTime.parse(publish_date)

          # Sticky
          post.is_sticky = i['is_sticky']

          #comment allowed
          post.allow_comments = i['comment_status'] == 'open' ? true : false

          if post.save
            import_count += 1
          end
        end

        flash[:success] = "We just successfully imported #{import_count} posts"
      else
        flash[:warning] = 'The export file you submitted appears to have no valid items for import'
      end

    else
      flash[:error] = 'You must select a valid wordpress xml export file to import'
    end

    redirect_to :controller => 'admin/import_wordpress', :action => 'new'
  end

end
