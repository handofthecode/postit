class CommentsController < ApplicationController
	before_action :require_user
	before_action :get_post, only: [:create]

	def create
		@comment = @post.comments.build(params.require(:comment).permit(:body))
		@comment.creator = current_user
		if @comment.save
			flash[:notice] = "Your comment was added"
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end
	end

	def vote
		@comment = Comment.find(params[:id])
		vote = Vote.create(voteable: @comment, vote: params[:vote], creator: current_user)
		respond_to do |format|
			format.html do
				if vote.valid?
					flash[:notice] = "Your vote has been counted."
				else
					flash[:error] = "You can only vote once per comment."
				end
				redirect_to :back
			end
			format.js do
				if vote.valid?
					flash.now[:notice] = "Your vote has been counted."
				else
					flash.now[:error] = "You can only vote once per comment."
				end
			end
		end
	end

	private

	def get_post
		@post = Post.find_by slug: params[:post_id]
	end
end