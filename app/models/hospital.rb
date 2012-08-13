class Hospital
	include Mongoid::Document

	has_many :products, dependent: :destroy
	has_many :photos, dependent: :destroy

	field :name, type: String
	field :location_city, type: String
	field :location_area, type: String
	field :location_latitude, type: Float
	field :location_logitude, type: Float
	field :tel_number, type: String
	field :department, type: String
	field :detail, type: String

  attr_accessible	:photos_attributes, :name, :detail, :department, :tel_number,
  	:location_area, :location_city, :location_latitude, :location_logitude

	accepts_nested_attributes_for :products,
		reject_if: :all_blank,
		allow_destroy: true
	accepts_nested_attributes_for :photos,
		reject_if: ->(attr){ attr[:image].blank? },
		allow_destroy: true

	def as_json(options={})
		super(
			include:
			{
				photos: {
					only: [:_id],
					methods:[
						:image_url,
						:medium_url,
						:thumb_url
					]
				}
			}.merge(options)
		)
	end
end