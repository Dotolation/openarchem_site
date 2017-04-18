class Site < ActiveRecord::Base
	belongs_to :sample
	has_many :people

	def self.new_site(site)
	end

	def self.find_site(id)
		unless id.empty?
			site = Site.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return site
	end

	def self.get_data(document)
	end

	def self.get_data_for_mini_view(id)
		site = Site.find_site(id)
		field_list = ["name", "oa_id", "geo_coords", "project_url"]
		site_hash = Hash.new

		field_list.each do |key|
			val = site[key]
			#need to decide what will be our display field in the mini list
			if key == "name"
				site_hash["display"] = val
			else
				site_hash[key] = val
			end
		end

		return site_hash
	end

end
