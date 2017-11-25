class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    image_data = Magick::Image.read(@micropost.image.file.file)[0]
    
    #写真から緯度経度の中輸出
    exif_lat = image_data.get_exif_by_entry('GPSLatitude')[0][1].to_s.split(',').map(&:strip)
    exif_lng = image_data.get_exif_by_entry('GPSLongitude')[0][1].to_s.split(',').map(&:strip)
    @micropost.latitude = exif_lat.present? ? (Rational(exif_lat[0]) + Rational(exif_lat[1])/60 + Rational(exif_lat[2])/3600).to_f : nil
    @micropost.longitude = exif_lng.present? ? (Rational(exif_lng[0]) + Rational(exif_lng[1])/60 + Rational(exif_lng[2])/3600).to_f : nil

    if @micropost.save
      p "*******result********"
      p @micropost
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @micropost = current_user.feed_microposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image, :image_cache)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end

