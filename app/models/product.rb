class Product
	include Mongoid::Document
	belongs_to :hospital
	embeds_many :photos

	field :name, type: String
	field :price, type: Integer
	field :dc_rate, type: Float
	field :event_start_at, type: DateTime
	field :event_end_at, type: DateTime
	field :event_state, type: String

	attr_accessible :name, :price

	accepts_nested_attributes_for :photos

end
