class Compound < ActiveRecord::Base

	def self.find_compound(oa_id)
		unless oa_id.empty?
			com = Compound.where("oa_id = ?", oa_id).first
		end
		#returns nil if no record found
	end


	def self.show_compound_data(oa_id)
		data_arr = new_get_data(oa_id)
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


	def self.get_sample_diagnostic_comps(sample_id)
		comps = SampleCompound.find_by_sample_id(sample_id)

		diag_comps = Hash.new

		if comps 
			comps.each do |rec|
				comp = find_compound(rec["compound_id"])
				diag_comps = {"compound_id" => comp["oa_id"], "compound_name" => comp["name"], "dukes" => comp["dukes_url"], "nist" => comp["nist_url"]}
			end
		end
		return diag_comps
	end

	def self.new_get_data(oa_id)
		comp = find_compound(oa_id)
		image_hash = Image.get_compound_images(oa_id)
		plant_hash = get_plants(oa_id)
		sample_hash = get_samples(oa_id)

		return {"show_hash" => comp, "image_hash" => image_hash, "plant_hash" => plant_hash, "sample_hash" => sample_hash}
	end


	def self.get_plants(oa_id)
		p_com = PlantCompound.find_by_compound_id(oa_id)
		com_hash = Hash.new
		p_com.each do |ref|
			plant = Plant.find_plant(ref["plant_id"])
			com_hash[plant["oa_id"]] = [plant["scientific_name"], plant["common_name"], plant["dukes_url"], plant["flora_url"]]
		end
		return com_hash
	end


	def self.get_samples(oa_id)
		samples = SampleCompound.find_by_compound_id(oa_id)
		sam_hash = Hash.new
		samples.each do |rec|
			sam = Sample.find_sample(rec["sample_id"])
			site = Site.get_id_and_name(sam["site_id"])
			p_c = Identification.get_product_name_and_id(sam["oa_id"])

			sam_hash[sam["oa_id"]] = [site, p_c]
		end
		return sam_hash
	end
end
