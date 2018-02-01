module ApplicationHelper
	def fix_url(url)
		url.starts_with?('http') ? url : "http://#{url}"
	end
	def display_datetime(dt)
		dt.strftime('%B %e, %Y at %l:%M %p')
	end
	def is_owner?(creator)
    creator.id == session[:user_id]
  end
end
