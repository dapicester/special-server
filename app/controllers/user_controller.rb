class UserController < ApplicationController
  before_filter :protect, :only => :index

  def index
    @title = "User Hub"
    # this will be a protected page for viewing user information
  end
  
  def login
    @title = "Login"
    if request.post? and params[:user]
      @user = User.new(params[:user])
      user = User.find_by_screen_name_and_password(@user.screen_name, @user.password)
      if user
        session[:user_id] = user.id
        flash[:notice] = "User #{user.screen_name} logged in!"
        if (redirect_url = session[:protected_page])
          session[:protected_page] = nil
          redirect_to redirect_url
        else
          redirect_to :action => "index"
        end
      else
        # don't show the password
        @user.password = nil
        flash[:notice] = "Invalid screen name/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to :action => "index", :controller => "site"
  end

  def register
    @title = "Register"
    if request.post? and params[:user]
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "User #{@user.screen_name} created!"
        if (redirect_url = session[:protected_page])
          session[:protected_page] = nil
          redirect_to redirect_url
        else
          redirect_to :action => "index"
        end
      end
    end
  end

  def protected
    unless session[:user_id]
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return false
    end
  end

private
  
  # Protect a page from unauthorize acces.
  def protect 
    unless session[:user_id]
      redirect_to :action => "login"
      flash[:notice] = "Please log in first"
      return false
    end
  end
end
