class Product
	include Mongoid::Document

	belongs_to :hospital
	has_many :photos, dependent: :destroy
	
	field :name, type: String
	field :price, type: Integer
	field :dc_rate, type: Float
	field :event_start_at, type: DateTime
	field :event_end_at, type: DateTime
	field :event_state, type: String

	attr_accessible :photos_attributes, :name, :price, :dc_rate,
		:event_start_at, :event_end_at, :event_state

	accepts_nested_attributes_for :photos,
		reject_if: ->(attr){ attr[:image].blank? },
		allow_destroy: true
end
