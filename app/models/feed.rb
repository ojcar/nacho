class Feed < ActiveRecord::Base
	MAX_THREADS = 5

  acts_as_taggable_on :folders
	
  attr_accessible :feed_url, :subscribed_url, :last_modified, :title, :url, :folders
  
  has_many :feed_entries, :dependent => :destroy, :order => 'published_at DESC'

  #TODO: make a better unique url validator
  validates :feed_url, :presence => true, :uniqueness => true
  validates :subscribed_url, :presence => true, :uniqueness => true

  def update_entries(feed = nil)
	  feed ||= Feedzirra::Feed.fetch_and_parse(feed_url)
		create_entries_from_feed(feed)
	end
	
	class << self
	  def create_from_feed(target_url)
	  	target = Feedzirra::Feed.fetch_and_parse(target_url)
      return nil if target.nil?

  		f = create(
  			:url 						=> target.url,
  			:feed_url 			=> target.feed_url,
  			:subscribed_url => target_url,
  			:title 					=> target.title,
  			:last_modified 	=> target.last_modified
  		)

	  	# create entries right away
      if f.present?
	  		f.update_entries(target)
      end

  		f
	  end

	  # def update_feeds
	  # 	feeds = Feed.all
	  # 	feeds.each {|f| f.update_entries}
	  # end

	  def update_feeds
	  	feeds = Feed.all
	  	Feed.updater(feeds) { |f| f.update_entries }
	  end

	  def updater(*args)
      items = args[0]
      todo  = Queue.new

      threads = (1..MAX_THREADS).map do |t|
        Thread.new do
          until ((item = todo.deq) == :END)
            yield item
            ActiveRecord::Base.connection.close
          end
        end
      end

      items.each {|i| todo.enq(i)}
      threads.size.times {todo.enq :END}

      threads.each do |t|
        begin
          t.join
        rescue => e
        	Rails.logger.info "****************************"
        	Rails.logger.info "EXCEPTION IN UPDATER"
          Rails.logger.info e.message
          Rails.logger.info e.backtrace
          raise e
        end
      end
	  end # -end
	end

	protected
		def create_entries_from_feed(feed) 
			feed.entries.each do |entry|
				self.feed_entries.find_or_create_by_guid(
		        :title        => entry.title,
		        :content      => entry.content.present? ? entry.content : entry.summary,
		        :url          => entry.url,
		        :author				=> entry.author,
		        :published_at => entry.published,
		        :guid         => entry.id
		      )
	  	end
		end

end
