class Product < ActiveRecord::Base
	attr_accessible :name, :price, :hospital_id

	belongs_to :hospital, :class_name => "Hospital", :foreign_key => "hospital_id"
	has_many :photos, :class_name => "Photo", :foreign_key => "product_id", :dependent => :destroy

	accepts_nested_attributes_for :photos

	def as_json(options={})
		super(
			{
				except: :hospital_id,
				include: [
					{
						hospital: {
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
						}
					},
					{
						photos: {
							only:[],
							methods: [
								:image_url, :medium_url, :thumb_url
							]
						}
					}
				]
			}.merge(options)
		)
	end
end
