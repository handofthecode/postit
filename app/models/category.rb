class Category < ActiveRecord::Base
	includes Sluggable

	has_many :post_categories
	has_many :posts, through: :post_categories

	validates :name, presence: true

	before_save -> { generate_slug!(Category) }
end