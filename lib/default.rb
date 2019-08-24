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
