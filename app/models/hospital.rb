class Hospital < ActiveRecord::Base
  attr_accessible :photos_attributes, :detail, :location_area, :location_city, :location_latitude, :location_logitude, :name

	has_many :products, :dependent => :destroy#, :order => 'created_at desc'
	has_many :photos, :dependent => :destroy#, :order => 'created_at desc'

	accepts_nested_attributes_for :photos, :reject_if => proc { |e| e['image'].blank? }, :allow_destroy => true

	def as_json(options={})
		super(
			{
				include: [
					{
						photos: {
							only:[],
							methods:[
								:image_url,
								:medium_url,
								:thumb_url
							]
						}
					}
				]
			}.merge(options))
	end
end