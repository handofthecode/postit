class Post < ActiveRecord::Base
	include Voteable
	include Sluggable
	belongs_to :creator, class_name: "User", foreign_key: "user_id"
	has_many :comments
	has_many :post_categories
	has_many :categories, through: :post_categories

	validates :title, presence: true, length: {minimum: 5}
	validates :description, presence: true, uniqueness: true
	validates :url, presence: true

	sluggable_column :title
end