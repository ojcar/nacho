class FeedEntry < ActiveRecord::Base
  scope :unread, where(:read => false)
  attr_accessible :author, :content, :guid, :published_at, :title, :url
  belongs_to :feed

  def as_json(options={})
    super(:include => :feed)
  end
end
