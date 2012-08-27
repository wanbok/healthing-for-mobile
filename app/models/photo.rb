class Photo < ActiveRecord::Base
	# include Mongoid::Document
 #  include Mongoid::Paperclip

	belongs_to :hospital
  belongs_to :product

  has_attached_file :image,
    styles: {
      # 640
      # 302x187
      # 108x79
      detail: ["640", :png],
      medium: ["302x187>", :png],
      thumb: ["108x79>", :png]
    }
    
  validates_attachment :image, 
  	presence: true,
  	content_type: { content_type: ["image/png", "image/jpeg"] },
  	size: { less_than: 10.megabytes }

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
