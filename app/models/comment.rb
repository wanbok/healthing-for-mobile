class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :product

	belongs_to :commentable, polymorphic: true
	has_many :comments, as: :commentable, dependent: :destroy

	validates :user_id, presence: true
	validates :commentable, presence: true
	validates :text, length: { in: 1...300 }

  attr_accessible :user_id, :commentable_id, :commentable_type, :text
end