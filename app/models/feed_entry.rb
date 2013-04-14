class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :content, :feed_id, :guid, :published_at, :title, :url
  belongs_to :feed
end
