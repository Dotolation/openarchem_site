class Site < ActiveRecord::Base
	belongs_to :sample
	has_many :people

	def new_site(site)
	end

	def find_site(id)
	end

end
