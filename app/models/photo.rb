class Photo < ActiveRecord::Base
	belongs_to :hospital
  belongs_to :product

  attr_accessible :hospital_id, :product_id, :image
  
  has_attached_file :image,
    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates_attachment :image, 
  	:presence => true,
  	:content_type => { :content_type => ["image/png", "image/jpeg"] },
  	:size => { :in => 0..10.megabytes }

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
