module FeedHelper

  # Return the paged feed for the given user.
  def feed_for(user)
    user.feed.paginate(page: params[:page] || 1 )
  end

end
