class Source < ActiveRecord::Base

	def self.new_source(source)
	end

	def self.find_source(id)
		unless id.empty?
			source = Source.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return source		
	end

	def self.get_data(document)
	end

	def self.get_data_for_mini_view(id)
		source = Source.find_source(id)
		field_list = ["oa_id", "soil_sample", "object_type", "object_url"] 
		#add in image field above
		source_hash = Hash.new
		
		field_list.each do |key|
			if key == "soil_sample"
				val = source[key] == false ? "object" : "soil sample"
				source_hash["display"] = val
			else
				val = source[key]
				source_hash[key] = val
			end
		end
				
		return source_hash		
	end



end
