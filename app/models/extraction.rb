class Extraction < ActiveRecord::Base


	def self.find_extraction(id)
		unless id.empty?
			extraction = Extraction.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return extraction		
	end

	def self.get_data(oa_id)
		extr = find_extraction(oa_id)

 		linked_fields = []
 		added_fields = []

 		ext_hash = Hash.new
 		#doing this by hand as we need to change int booleans into words and want particular names for fields
 		
 		ext_hash["oa_id"] = oa_id
 		ext_hash["solvent"] = extr["solvent"]
 		ext_hash["buchi_extraction"] = extr["buchi"] == 0 ? "False" : "True"
 		ext_hash["swished"] =  extr["swished"] == 0 ? "False" : "True"
 		ext_hash["boiled_manually"] = extr["boiled_manually"] == 0 ? "False" : "True"
 		ext_hash["notes"]	= extr["notes"]

 		return {"show_hash" => ext_hash, "inner_fields" => linked_fields, "added_fields" => added_fields}
	end

	def self.show_extraction_data(oa_id)
		data = get_data(oa_id)
	end

	def self.get_data_for_mini_view(id)
		ext = Extraction.find_extraction(id)
		ext_hash = Hash.new
		ext_hash["display"] = ext["oa_id"]
		ext_hash["notes"] = ext["notes"]
		
		return ext_hash
	end

end
