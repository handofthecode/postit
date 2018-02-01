class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_user, except: [:index, :show, :new, :create]
	def index
		@users = User.all
	end
	def show
    @posts = sort_by_votes @user.posts
    @comments = sort_by_votes @user.comments
	end
	def new
  	@user = User.new
  end
  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:notice] = "You are registered!"
  		redirect_to root_path
  	else
  		render "new"
  	end
  end
  def edit
  end
  def update
    if @user.update(user_params)
      flash[:notice] = 'Profile was updated!'
      redirect_to user_path(@user)
    else
      flash[:error] = 'something went wrong'
    end
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
  	params.require(:user).permit(:username, :password)
  end
end