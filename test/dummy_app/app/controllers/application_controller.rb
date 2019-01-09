class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Exception do |exception|
    puts " * ERROR ********************************************"
    puts exception
    puts exception.backtrace
    puts " ****************************************************"
    raise exception
  end

end
