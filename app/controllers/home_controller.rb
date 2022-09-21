class HomeController < ApplicationController
  layout :check_user_role
  
  def index
  end

  def check_user_role
    if current_user.has_role? :admin
      "admin" 
    else 
      "user"
    end
  end
end
