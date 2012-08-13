class Photo
	include Mongoid::Document
  include Mongoid::Paperclip

	belongs_to :hospital
  belongs_to :product

  has_mongoid_attached_file :image,
    styles: {
      medium: ["300x300>", :png],
      thumb: ["100x100>", :png]
    }
    
  validates_attachment :image, 
  	presence: true,
  	content_type: { content_type: ["image/png", "image/jpeg"] },
  	size: { less_than: 10.megabytes }

  def image_url
  	image.url
	end

  def medium_url
  	image.url(:medium)
	end

  def thumb_url
  	image.url(:thumb)
	end

end