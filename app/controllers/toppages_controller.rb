class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @microposts = current_user.feed_microposts.order('created_at DESC').page(params[:page])
      @hav_markers = @microposts.where.not(latitude: nil, longitude: nil)
      @hash = Gmaps4rails.build_markers(@hav_markers) do |micropost, marker|
        marker.lat micropost.latitude
        marker.lng micropost.longitude
        marker.infowindow micropost.content
        marker.json({title: micropost.address})
      end
    end
  end
end
