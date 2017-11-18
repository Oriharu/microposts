class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    user = User.find(params[:micropost_id])
    current_user.like
    flash[:success] = 'このmicropostをお気に入り登録しました。'
    redirect_to user
  end
  
  def destroy
    user = User.find(params[:micropost_id])
    current_user.dislike
    flash[:success] = 'お気に入りを解除しました。'
    redirect_to user
  end
end
