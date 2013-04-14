class Feed < ActiveRecord::Base
  attr_accessible :feed_url, :last_modified, :title, :url
end
