class Category < ActiveRecord::Base
	has_many :post_categories
	has_many :posts, through: :post_categories

	validates :name, presence: true

	before_save :generate_slug

	def generate_slug
		slug = sluggify self.name
		conflict = Category.find_by slug: slug
		while conflict && conflict != self
			slug = increment_if_exists slug
			conflict = Category.find_by slug: slug
		end
    self.slug = slug
  end

  def sluggify(slug)
		slug.strip.downcase.gsub(/[^A-Za-z0-9]/, "-").gsub(/-+/, "-")
  end

  def increment_if_exists(slug)
  	suffix = slug.scan(/-(\d+)$/)
  	if suffix.empty?
  		slug + '-2'
	  else	
	  	suffix = (suffix[0][0].to_i + 1).to_s
	  	slug.gsub(/\d+$/, suffix)
	  end
  end

  def to_param
  	self.slug
  end
end