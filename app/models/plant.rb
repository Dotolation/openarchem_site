class Plant < ActiveRecord::Base
	require 'csv'
	has_many :plant_compounds, foreign_key: :oa_id

	def self.new_oa_id
    oa_id = Plant.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_plant(vals_hash)
		@plant = Plant.create(vals_hash)
	end

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
			a_r = AncientRef.find_by_prod_id(ref["oa_id"])
			prod_hash[ref["oa_id"]]=[ref["name"], ref["alternate_name"], ref["plant_part"], a_r]
		end
		return prod_hash
	end




	def self.get_plants_from_compound(oa_id)

		plants = Plant.joins("join plant_compounds").where("plant_compounds.plant_id = plants.oa_id and plant_compounds.compound_id = ?", oa_id)
	end


	def self.import_dukes_plants

		#make common_names file into a hash for ease of use later
		common_names = Hash.new
		CSV.foreach("/home/mene/Dukes/COMMON_NAMES.csv", :headers => true) do |row|
			#COMMON_NAMES.csv [0]CNNAM	[1]FNFNUM
			if common_names.has_key?(row[1])
				v = common_names[row[1]]
				common_names[row[1]] = v + "; " + row[0]
			else
				common_names[row[1]] = row[0]
			end
		end	

		plant_comps = Hash.new
		CSV.foreach("/home/mene/Dukes/FARMACY_NEW.csv", :headers => true) do |row|
			#FARMACY_NEW.csv for chem names and plant part code by fnfnum [0]FNFNUM	[1]CHEM	[3]PPCO
			if plant_comps[row[0]]
				curr = plant_comps[row[0]]
				plant_comps[row[0]] = curr << row[1].capitalize
			else
				plant_comps[row[0]] = [row[1].capitalize]
			end
		end

		plant_parts = Hash.new
		CSV.foreach("/home/mene/Dukes/PARTS.csv", :headers => true) do |row|
			plant_parts[row[0]] = row[1]
		end

		CSV.foreach("/home/mene/Dukes/FNFTAX.csv", :headers => true).with_index(1) do |row, idx|
			plant_check = Plant.find_by_scientific_name(row[1])
			unless plant_check
				p_hash = Hash.new
				#FNFTAX.csv for fnfnum and "scientific name" [0]FNFNUM	[1]TAXON
				fnfnum = row[0]
				p_hash["scientific_name"] = row[1]
				p_hash["common_name"] = common_names[fnfnum]
				#index is the show part of the url, https://phytochem.nal.usda.gov/phytochem/plants/show/[idx]
				p_hash["dukes_url"] = "https://phytochem.nal.usda.gov/phytochem/plants/show/#{idx}"
				p_hash["oa_id"] = new_oa_id
				@plant = new_plant(p_hash)

				p_c = plant_comps[fnfnum]
				if p_c
					p_c.each do |comp|
						pc_hash = Hash.new
						pc_hash["plant_id"] = @plant.oa_id
						c = Compound.find_by_name(comp)
						if c
							pc_hash["compound_id"] = c.oa_id
							pc_hash["plant_part"] = plant_parts[row[3]]
							@plant_compound = PlantCompound.new_plant_compound(pc_hash)
						end
					end
				end
			end
		end
	end




end



