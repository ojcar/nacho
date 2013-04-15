class FeedEntry < ActiveRecord::Base
  attr_accessible :author, :content, :guid, :published_at, :title, :url
  belongs_to :feed
end
