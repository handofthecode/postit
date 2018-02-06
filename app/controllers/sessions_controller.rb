class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(username: params[:username])
		if user && user.authenticate(params[:password])
			init_session user
		else
			flash[:error] = "There is something wrong with your username or password."
		end

		redirect_to root_path
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "You are logged out."
		redirect_to root_path
	end

	private

	def init_session(user)
		session[:user_id] = user.id
		flash[:notice] = "You are logged in!"
	end

end