class Hospital
	include Mongoid::Document
	has_many :products, dependent: :destroy
	embeds_many :photos

	field :name, type: String
	field :location_city, type: String
	field :location_area, type: String
	field :location_latitude, type: String
	field :location_logitude, type: String
	field :tel_number, type: String
	field :department, type: String
	field :detail, type: String

  attr_accessible	:name, :detail, :department, :tel_number, :photos_attributes,
  	:location_area, :location_city, :location_latitude, :location_logitude

	accepts_nested_attributes_for :products,
		reject_if: :all_blank,
		allow_destroy: true
	accepts_nested_attributes_for :photos,
		reject_if: ->(attr){ attr[:image].blank? },
		allow_destroy: true

end