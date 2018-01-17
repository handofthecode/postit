class CommentsController < ApplicationController
	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.build(params.require(:comment).permit(:body))
		@comment[:user_id] = 3
		if @comment.save
			flash[:notice] = "Your comment was added"
			redirect_to post_path(@post)
		else
			render 'post/show'
		end
	end
end