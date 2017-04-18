class Extraction < ActiveRecord::Base


	def self.find_extraction(id)
		unless id.empty?
			extraction = Extraction.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return extraction		
	end

	def self.get_data_for_mini_view(id)
		ext = Extraction.find_extraction(id)
		field_list = ["oa_id", "notes"] 
		ext_hash = Hash.new
		ext_hash["display"] = ext["oa_id"]
		ext_hash["notes"] = ext["notes"]
		
		return ext_hash
	end

end
