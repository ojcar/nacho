class Feed < ActiveRecord::Base
  attr_accessible :feed_url, :subscribed_url, :last_modified, :title, :url
  
  has_many :feed_entries, :dependent => :destroy

  #TODO: make a better unique url validator
  validates :feed_url, :presence => true, :uniqueness => true
  validates :subscribed_url, :presence => true, :uniqueness => true

  def update_entries(feed = nil)
	  feed ||= Feedzirra::Feed.fetch_and_parse(feed_url)
		create_entries_from_feed(feed)
	end
	
	class << self
	  def create_from_subscription(target_url)
	  	target = Feedzirra::Feed.fetch_and_parse(target_url)

	  	unless target.nil?
	  		f = create(
	  			:url 						=> target.url,
	  			:feed_url 			=> target.feed_url,
	  			:subscribed_url => target_url,
	  			:title 					=> target.title,
	  			:last_modified 	=> target.last_modified
	  		)

	  		# create entries right away
	  		f.update_entries(target) if f.present?
	  	end
	  end
	end

	protected
		def create_entries_from_feed(feed) 
			feed.entries.each do |entry|
				self.feed_entries.find_or_create_by_guid(
		        :title         => entry.title,
		        :content      => entry.summary,
		        :url          => entry.url,
		        :author				=> entry.author,
		        :published_at => entry.published,
		        :guid         => entry.id
		      )
	  	end
		end

end
