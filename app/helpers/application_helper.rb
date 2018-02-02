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
  def ajax_flash
    flash_div = ""

    flash.each do |name, msg|
      if msg.is_a?(String)
        flash_div = "<div class=\"alert alert-#{name == :notice ? 'success' : 'error'} ajax_flash\"><a class=\"close\" data-dismiss=\"alert\">&#215;</a> <div id=\"flash_#{name == :notice ? 'notice' : 'error'}\">#{h(msg)}</div> </div>"
      end 
    end
    
    response = "$('.alert').remove();$('#notification_bar').prepend('#{flash_div}');"
    response.html_safe
  end
end
