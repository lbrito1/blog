require 'byebug'
require 'awesome_print'

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Tagging
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo

SITE_TITLE = "A Developer's Notebook"

def get_post_start(post)
  content = post.compiled_content
  return content.partition('<!-- more -->').first if content =~ /\s<!-- more -->\s/

  content
end

def all_tags
  tags = {}

  published_items.each do |i|
    i[:tags]&.each do |tag|
      tags[tag] ||= 0
      tags[tag] += 1
    end
  end

  tags
end

def all_years
  years = {}

  published_items.each do |i|
    next unless i[:created_at]
    years[i[:created_at].year] ||= 0
    years[i[:created_at].year] += 1
  end

  years
end

def posts_in_year(year)
  published_items.select { |item| item[:created_at]&.year == year }
end

def published_items
  @items.select { |x| x.attributes[:published].nil? || x.attributes[:published] }
end

def published_posts
  posts.select { |x| x.attributes[:published].nil? || x.attributes[:published] }
end
