class FeedsController < ApplicationController
  before_filter :authenticate_user!
  layout 'feeds'
  
  def index
    # @feeds = Feed.includes(:feed_entries).order('feed_entries.published_at DESC').all
    # @folders = current_user.owned_tags
    # @feed_entries = FeedEntry.includes(:feed).order('published_at DESC').all
    @feeds = Feed.includes(:feed_entries).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  def show
    @feed = Feed.includes(:feed_entries).find(params[:id])
    
    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render json: { entries: @feed.feed_entries } }
    end
  end

  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def create
    @feed = Feed.create_from_feed(params[:feed][:subscribed_url])

    respond_to do |format|
      if !@feed.nil?
        current_user.tag(@feed, with: params[:feed][:folder_list], on: :folders) if params[:feed][:folder_list].present?

        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @feed = Feed.find(params[:id])

    #TODO Fix tag update for current_user owned
    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url }
      format.json { head :no_content }
    end
  end
end
