module Voteable
	extend ActiveSupport::Concern

	included do
		has_many :votes, as: :voteable
	end
	
	def total_votes
		self.votes.reduce(0) { |sum, vote| sum + (vote.vote ? 1 : -1) }
	end
end