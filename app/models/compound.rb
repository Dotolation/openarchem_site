class Compound < ActiveRecord::Base

	def self.find_compound(oa_id)
		unless oa_id.empty?
			com = Compound.where("oa_id = ?", oa_id).first
		end
		#returns nil if no record found
	end


	def self.show_compound_data(oa_id)
		data_arr = get_data(oa_id)
	end


	def self.get_data(oa_id)
		comp = find_compound(oa_id)
		field_list = ["oa_id", "name", "formula", "molecular_weight", "peak_time", "outside_db_url", "notes", "image_file_path", "image_credit"]
		linked_fields = []
 		added_fields = []

 		com_hash = Hash.new

 		field_list.each do |key|
 			val = comp[key]
 			if key == "peak_time"
 				com_hash[key] = val.to_s + " minutes"
 			else
 				com_hash[key] = val
 			end
 		end

 		

 		return {"show_hash" => com_hash, "inner_fields" => linked_fields, "added_fields" => added_fields}
	end


	#inner_list is for getting other entities' data to put on a Compound page
	def self.get_data_for_inner_list(oa_id)
		
		 
	end

	#mini_view is for pulling Compound info to display on another entity's page
	def self.get_data_for_mini_view(oa_id)
		comp = find_compound(oa_id)

		field_list = ["oa_id", "name", "formula", "molecular_weight", "image_file_path", "image_credit"]
		comp_hash = Hash.new

		field_list.each do |key|
			val = comp[key]
			#setting the display field in the mini list
			if key == "name"
				comp_hash["display"] = val
			else
				comp_hash[key] = val
			end
			
		end
		return comp_hash
	end
end
