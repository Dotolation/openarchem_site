class Plant < ActiveRecord::Base

	def self.find_plant(oa_id)
		unless oa_id.empty?
			plant = Plant.where("oa_id = ?", oa_id).first
		end
		#returns nil if no record found
	end

	def self.show_plant_data(oa_id)
		data_arr = get_data(oa_id)
	end

	def self.get_data(oa_id)
		plant = find_plant(oa_id)
		field_list = ["oa_id", "scientific_name", "common_name", "description", "image_file_path", "image_credit", "dukes_url"]
		linked_fields = []
 		added_fields = ["associated_compounds"]

 		pla_hash = Hash.new

 		field_list.each do |key|
 			val = plant[key]
 			pla_hash[key] = val
 		end

 		compound_data = get_data_for_inner_list(oa_id)

 		return {"show_hash" => pla_hash, "inner_fields" => linked_fields, "added_fields" => added_fields, "associated_compounds" => compound_data}
	end

	#inner_list is for getting other entities' data to put on a Plant page
	def self.get_data_for_inner_list(oa_id)
		#compounds here is an array
		compound_data = PlantCompound.get_data_for_mini_list(oa_id, "plant")

		return compound_data 
	end

end
