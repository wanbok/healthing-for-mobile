class Photo < ActiveRecord::Base
	# include Mongoid::Document
 #  include Mongoid::Paperclip

	belongs_to :hospital
  belongs_to :product

  has_attached_file :image,
    styles: {
      # 320x0000  4g: 640x0000
      # 297x180   4g: 594x360
      # 108x79    4g: 216x158
      detail: ["640", :png],
      medium: ["594x360#", :png],
      thumb: ["216x158#", :png]
    }
    
  validates_attachment :image, 
  	presence: true,
  	content_type: { content_type: ["image/png", "image/jpeg"] },
  	# size: { less_than: 10.megabytes }

  attr_accessible :image, :hospital_id, :product_id
  
  def image_url
  	image.url
	end

  def detail_url
    image.url(:detail)
  end

  def medium_url
    image.url(:medium)
  end

  def thumb_url
  	image.url(:thumb)
	end

end
