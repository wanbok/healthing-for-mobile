class User < ActiveRecord::Base
	# include Mongoid::Document
	
	has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :products

	# field :udid, type: String

	attr_accessible :products
end