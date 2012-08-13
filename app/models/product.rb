class Product
	include Mongoid::Document

	belongs_to :hospital
	has_many :photos, dependent: :destroy
  has_and_belongs_to_many :users
	
	field :name, type: String
	field :price, type: Integer
	field :dc_rate, type: Float
	field :event_start_at, type: DateTime
	field :event_end_at, type: DateTime
	field :read_count, type: Integer
	field :favorite_count, type: Integer

	attr_accessible :photos_attributes, :hospital, :name, :price, :dc_rate,
		:event_start_at, :event_end_at

	accepts_nested_attributes_for :photos,
		reject_if: ->(attr){ attr[:image].blank? },
		allow_destroy: true

	def as_json(options={})
		super(
			{
				except: :user_ids,
				include:
				{
					hospital: {
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
						}
					},
					photos: {
						only: [:_id],
						methods:[
							:image_url,
							:medium_url,
							:thumb_url
						]
					}
				}
			}.merge(options)
		)
	end

	def favorite_toggle(udid)
		user = self.users.where(udid: udid).first
		if user.blank?
			self.users.push User.find_or_create_by(udid: udid)
			self.inc(:favorite_count, 1)
		else
			self.user_ids.delete(user._id)
			User.find(user._id).product_ids.delete(self._id)
			self.save
			self.inc(:favorite_count, -1)
		end
	end

end
