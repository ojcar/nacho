class ReaderController < ApplicationController
  before_filter :authenticate_user!
  layout 'feeds'

  def index
    @entries = FeedEntry.includes(:feed).order('published_at DESC').unread.paginate(:page => params[:page],:per_page => 100)
    @folders = current_user.owned_taggings.where(:context => 'folders').collect{|f| f.tag.name}.uniq

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  def tag
    #TODO find a better way to get entries for tagged feeds for user
    @feeds = Feed.tagged_with(params[:id], :on => :folders, :owned_by => current_user).includes(:feed_entries)
    @entries = @feeds.collect(&:feed_entries).flatten.sort!{|a,b| b.published_at <=> a.published_at }

    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render json: { entries: @entries } }
    end
  end

  def mark_read
    return unless request.xhr?
    
    entry = FeedEntry.find(params[:id])
    entry.read = true

    Rails.logger.info '*******************'
    Rails.logger.info entry.inspect

    respond_to do |format|
      if entry.save
        format.json { render layout: false, json: { status: 'success', id: entry.id } }
      else
        format.json { render layout: false, json: { status: 'error', id: entry.id } }
      end
    end
  end

  # def post
  #   @post = Post.create_from_feed(params)
    
  #   respond_to do |format|
  #     if @post.save
  #       format.json { render layout: false, json: { status: 'success'} }
  #     else
  #       format.json { render layout: false, json: { status: 'error'} }
  #     end
  #   end
  # end
end
