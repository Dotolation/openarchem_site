class Plant < ActiveRecord::Base

	def self.find_plant(oa_id)
		unless oa_id.empty?
			plant = Plant.where("oa_id = ?", oa_id).first
		end
		#returns nil if no record found
	end

	def self.show_plant_data(oa_id)
		data_arr = get_new_data(oa_id)
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
		compound_data = PlantCompound.get_data_for_mini_view(oa_id, "plant")

		return compound_data 
	end

	#mini view is for getting Plant data that appears on another entity's page
	def self.get_data_for_mini_view(id)
		plant = find_plant(id)
		field_list =["oa_id", "scientific_name", "common_name", "image_file_path", "image_credit"]

		plant_hash = Hash.new
		
		field_list.each do |key|
			if key == "scientific_name"
				val = plant[key]
				plant_hash["display"] = val
			else
				val = plant[key]
				plant_hash[key] = val
			end
		end
				
		return plant_hash	
	end

	def self.get_new_data(oa_id)
		plant = find_plant(oa_id)
		p_img = Image.get_plant_images(oa_id)
		assoc_comps = get_compounds(oa_id)
		assoc_prods = get_products(oa_id)

		return {"show_hash" => plant, "image_hash" => p_img, "comps_hash" => assoc_comps, "prods_hash" => assoc_prods}

	end


	def self.get_compounds(oa_id)
		p_com = PlantCompound.find_by_plant_id(oa_id)
		com_hash = Hash.new
		p_com.each do |ref|
			com = Compound.find_compound(ref["compound_id"])
			com_hash[com["oa_id"]] = [com["name"], com["formula"], com["dukes_url"], com["nist_url"]]
		end
		return com_hash
	end

	def self.get_products(oa_id)
		prod = Product.find_by_plant_id(oa_id)
		prod_hash = Hash.new
		prod.each do |ref|
			a_r = AncientRef.find_by_prod_id(oa_id)
			prod_hash[ref["oa_id"]]=[ref["name"], ref["alternate_name"], ref["plant_part"], a_r]
		end
		return prod_hash
	end
end
