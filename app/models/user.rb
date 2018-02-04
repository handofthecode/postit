class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
	has_many :votes

	has_secure_password validations: false
	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create, length: {minimum: 6}

	before_save :generate_slug!

	def generate_slug!
		slug = sluggify self.username
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