include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo

SITE_TITLE = "Blog"

def get_post_start(post)
  content = post.compiled_content
  if content =~ /\s<!-- more -->\s/
    content = content.partition('<!-- more -->').first +
    "<div><a class='read-more' href='#{post.path}'>Continue reading &rsaquo;</a></div>"
  end
  return content
end

def all_tags
  tags = {}

  @items.each do |i|
    i[:tags]&.each do |tag|
      tags[tag] ||= 0
      tags[tag] += 1
    end
  end

  tags.to_h
end
