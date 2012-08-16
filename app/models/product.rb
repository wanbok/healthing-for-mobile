class Product < ActiveRecord::Base
	# include Mongoid::Document

	belongs_to :hospital
	has_many :photos, dependent: :destroy
  has_and_belongs_to_many :users
	
	# field :name, type: String
	# field :price, type: Integer
	# field :dc_rate, type: Float
	# field :event_start_at, type: DateTime
	# field :event_end_at, type: DateTime
	# field :read_count, type: Integer
	# field :favorite_count, type: Integer

	attr_accessible :photos_attributes, :users, :hospital_id, :name, :price, :dc_rate,
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
		user = User.where(udid: udid).first
		if self.users.include?(user)		# 이 상품에서 찜을 해제하는 유저
			self.users.delete(user)
			self.favorite_count -= 1
			self.favorite_count = self.favorite_count < 0 ? 0 : self.favorite_count
			self.save
			0
		else														# 이 상품을 찜하는 유저
			self.users.push User.find_or_create_by_udid(udid)
			self.favorite_count += 1
			self.save
			1
		end
	end

	def self.search(search)
	  if search
	  	if ActiveRecord::Base::connection.is_a? (ActiveRecord::ConnectionAdapters::MysqlAdapter)
      	find(:all,
            :joins => "LEFT JOIN `hospitals` ON products.hospital_id = hospitals.id",
            :select => "products.*, count(user_points.id)", :group => "products.id")
      else
       	joins(:hospital).where('products.name LIKE ? OR hospitals.name LIKE ?', "%#{search}%", "%#{search}%")
      end
    end
	  else
	    scoped
	  end
	end

end
