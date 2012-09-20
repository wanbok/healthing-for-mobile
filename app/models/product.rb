class Product < ActiveRecord::Base
	# include Mongoid::Document

	belongs_to :hospital
	has_many :photos, dependent: :destroy
	has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :users

	attr_accessible :photos_attributes, :users, :hospital_id, :name, :price, :dc_rate,
		:event_start_at, :event_end_at, :read_count, :hot, :show, :comments, :search_word, :label
		
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
									:detail_url,
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
							:detail_url,
							:medium_url,
							:thumb_url
						]
					},
				},
				methods: [
					:comments_count,
				],
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
      select("DISTINCT products.*").joins(:hospital).where('products.name LIKE ? OR products.search_word LIKE ? OR hospitals.name LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
	  else
	    scoped
	  end
	end

	def comments_count
		self.comments.count
	end

end
