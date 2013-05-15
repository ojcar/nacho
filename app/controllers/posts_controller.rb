class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show]
  layout 'posts'

  def index
    @posts = Post.includes(:keywords).paginate(:page => params[:page],:per_page => 15).order('id DESC')
    @posts_by_day = @posts.group_by {|p| p.created_at.beginning_of_day}

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def new
  end

  def create
    @post = Post.new(params[:post])
    current_user.tag(@post, :with => params[:tags], :on => :keywords)


    respond_to do |format|
      if @post.save
        format.html
        format.json { render json: @post }
      else
        format.html
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end
end
