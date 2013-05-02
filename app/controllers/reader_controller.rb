class ReaderController < ApplicationController
  before_filter :authenticate_user!
  layout 'feeds'

  def index
    @entries = FeedEntry.includes(:feed).order('published_at DESC').all
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
      format.json { render json: { feeds: @feeds, entries: @entries } }
    end
  end
end
