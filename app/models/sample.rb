class Sample < ActiveRecord::Base
	has_many :sites
	has_many :sources
	

	def self.new_sample(sample)
	end

	def self.find_sample(id)
	end


end
