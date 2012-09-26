class PhotosController < ApplicationController
  # url: '/:class/:id/:style.:extension',
  # path: ':rails_root/public/assets/:class/:id_partition/:style.:extension'
  def image
    photo = Photo.find(params[:id])
    style = params[:style] ? params[:style] : 'original'
    send_file photo.image.path(style),
      type: photo.image_content_type,
      disposition: 'inline'
  end
end