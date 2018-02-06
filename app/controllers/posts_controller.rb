class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_edit_access, only: [:edit, :update]

  def index
  	@posts = sort_by_votes Post.all
  end
  def show
    @comment = Comment.new
    @allowed_to_edit = allowed_to_edit?
    # @comments = sort_by_votes @post.comments
  end
  def new
  	@post = Post.new
  end
  def create
  	@post = Post.new(post_params)
  	@post.creator = current_user

  	if @post.save
  		flash[:notice] = "Your post was created"
  		redirect_to posts_path
  	else
  		render "new"
  	end
  end
  def edit
  end
  def update
  	if @post.update(post_params)
  		flash[:notice] = "This post was updated"
  		redirect_to post_path(@post)
  	else
  		render :edit
  	end
  end
  def vote
    @vote = Vote.create(voteable: @post, vote: params[:vote], creator: current_user)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote has been counted."
        else
          flash[:error] = "You can only vote once per post."
        end
        redirect_to :back
      end
      format.js do
        if @vote.valid?
          flash.now[:notice] = "Your vote was counted"
        else
          flash.now[:error] = "You can't vote on a post more than once"
        end
      end
    end  
   
  end

  private

  def post_params
  	params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
  	@post = Post.find_by slug: params[:id]
  end

  def require_edit_access
    access_denied if !allowed_to_edit?
  end

  def allowed_to_edit?
    @post.creator == current_user || admin?
  end

end
