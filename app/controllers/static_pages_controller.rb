class StaticPagesController < ApplicationController
  include FeedHelper

  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = feed_for(current_user) 
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
