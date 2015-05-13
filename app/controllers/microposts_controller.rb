class MicropostsController < ApplicationController
  include FeedHelper

  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = I18n.t('microposts.create.success')
      redirect_to root_path
    else
      @feed_items = feed_for(current_user)
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = I18n.t('microposts.delete.success')
    redirect_back_or root_path
  end

  def search
    @microposts = []
    if params[:query].present?
      begin
        @microposts = Micropost.search params
      rescue Tire::Search::SearchRequestFailed
        # fail silently in case of errors
        error = true
      end
      flash[:message] = I18n.t('microposts.search.not_found') if @microposts.empty? or error
    end
  end

private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end

end
