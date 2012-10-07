module MarkdownHelper

  # Render markdown to html
  def render_markdown content, options = { }
    # Is there a query we need to highlight?
    options[:query]               ||= nil
    # parse links even when they are not enclosed in `<>` characters. Autolinks for the http, https and ftp
    # protocols will be automatically detected. Email addresses are also handled, and http links without protocol, but
    # starting with `www.`
    options[:autolink]            ||= true
    # A space is always required between the hash at the beginning of a header and its name, e.g. `#this is my header`
    # would not be a valid header.
    options[:space_after_headers] ||= true
    # do not parse emphasis inside of words. Strings such as `foo_bar_baz` will not generate `<em> tags.
    options[:no_intra_emphasis]   ||= true
    # parse strikethrough, PHP-Markdown style. Two `~` characters mark the start of a strikethrough,
    # e.g. `this is ~~good~~ bad`
    options[:strikethrough]       ||= true
    # parse tables, PHP-Markdown style
    options[:tables]              ||= true
    # parse fenced code blocks, PHP-Markdown style. Blocks delimited with 3 or more `~` or backticks will be considered
    # as code, without the need to be indented. An optional language name may be added at the end of the opening fence
    # for the code block
    options[:fenced_code_blocks]  ||= true
    # parse superscripts after the `^` character; contiguous superscripts are nested together, and complex values can
    # be enclosed in parenthesis, e.g. `this is the 2^(nd) time`
    options[:superscript]         ||= true
    # do not allow any user-inputted HTML in the output
    options[:filter_html]         ||= true
    # do not generate any `<img>` tags
    options[:no_images]           ||= false
    # do not generate any `<a>` tags
    options[:no_links]            ||= false
    # do not generate any `<style>` tags
    options[:no_styles]           ||= true
    # only generate links for protocols which are considered safe
    options[:safe_links_only]     ||= false
    # add HTML anchors to each header in the output HTML, to allow linking to each section.
    options[:with_toc_data]       ||= false
    # insert HTML `<br>` tags inside on paragraphs where the origin markdown document had newlines (by default,
    # markdown ignores these newlines).
    options[:hard_wrap]           ||= false
    # like a database, limit the number of lines returned
    options[:limit]               ||= 0

    # What kind of renderer are we using?
    renderer = RandomStringOfWordsMarkdownRenderer
    # Instance the renderer using the options above
    renderer = renderer.new options
    # Only use the content based on the limit
    content = content.split("\r\n")[0..(options[:limit]-1)].join if options[:limit] != 0
    # Instance Redcarpet with the options it knows above from above
    md = Redcarpet::Markdown.new renderer, options
    # Hit it!
    output = md.render(content)

    # okay now add the highlight filter for the query -- this is a little harsh but it prevents html breakage
    if options[:query].present?
      final_output = ""
      output.split(/(<.*?>)/).each do |part|
        next unless part.present?
        final_output << part if part[0] == '<'
        final_output << part.gsub(/(#{options[:query]})/i, '<mark>\1</mark>') unless part[0] == '<'
      end
      output = final_output
    end

    output.html_safe
  end

end

class RandomStringOfWordsMarkdownRenderer < Redcarpet::Render::XHTML
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include ActionView::Helpers::UrlHelper

  # Parse the sent link which can come in any of the following formats;
  # {id or url}
  # {id or url}|size
  # {id or url}|size|class

  # ID is the media object id to use.  Go get the image link from the db.
  # URL is the url of the image.  Just use that.
  # SIZE is the rails image tag helper {Width}x{Height}
  # CLASS is any classes you want to send along
  # Note; My regexp-fu either went up a level with this, or it just shows how bad at regexp I am.
  def parse_link link
    matches = link.match(/^([^\|]+)(?:\|)?([^\|]+)?(?:\|)?([^\|]+)?(?:\|)?([^\|]+)?/)
    puts matches.inspect
    {   :id     => (matches[1].to_i != 0) ? matches[1].to_i : nil,
        :url    => (matches[1].to_i == 0) ? matches[1] : nil,
        :size   =>  matches[2],
        :class  =>  matches[3]
    } if matches
  end

  # And here we are rewriting the standard image tag display system used by Redcarpet with one that
  # will handle the styles, sizes and our media system (if I ever get around to writing it)
  def image (link, title, alt)

    if (parse = parse_link link).present?
      if parse[:id].present?
      else
        imgOutput = image_tag(parse[:url], :size => parse[:size], :title => title, :alt => alt, :class => parse[:class])
        if alt.present?
          content_tag :div, imgOutput + "<br />".html_safe + alt, :class => "inline-image caption"
        else
          content_tag :div, imgOutput, :class => "inline-image"
        end
      end
    end

  end

end

