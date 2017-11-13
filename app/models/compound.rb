class Compound < ActiveRecord::Base
	require "mechanize"
	require "csv"

	def self.new_oa_id
    oa_id = Compound.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_compound(vals_hash)
		@compound = Compound.create(vals_hash)
	end

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
				diag_comps[comp["oa_id"]] = [comp["name"], comp["peak_time"], comp["dukes_url"], comp["nist_url"]]
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


	def self.compounds_from_dukes
		@agent = set_agent
		dukes_id = 0

		CSV.foreach("/home/mene/Dukes/CHEMICALS.csv", :headers => true) do |row|
			dukes_id += 1
			wiki_data = nil
			comp_name = row[0].capitalize
			comp_check = Compound.find_by_name(comp_name)
			unless comp_check
				comp_hash = Hash.new

				comp_hash["oa_id"] = new_oa_id
				comp_hash["name"] = comp_name
				comp_hash["dukes_url"] = "https://phytochem.nal.usda.gov/phytochem/chemicals/show/#{dukes_id}"
				
				wiki_data = import_from_wikimedia(comp_name)
				unless wiki_data.empty?
					comp_hash["formula"] = wiki_data[1]
					comp_hash["molecular_weight"] = wiki_data[0]
					comp_hash["nist_url"] = "http://webbook.nist.gov/cgi/inchi/InChI=#{wiki_data[4]}"
					curr_note = comp_hash["notes"] 
					comp_hash["notes"] = curr_note ? curr_note + "; " + "https://www.wikidata.org/wiki/#{wiki_data[5]}" : "https://www.wikidata.org/wiki/#{wiki_data[5]}" 
				end
				@compound = new_compound(comp_hash)
				#have to add images down here or else the foreign key constraint fails since the compound isn't created yet
				unless wiki_data.empty?
					begin
						if wiki_data[2]
							#want to pass the img url back to the rake task, wiki_data[2] and wiki_data[3]
							url = wiki_data[2].gsub(" ", "_")
							path = Rails.root.join('lib', 'assets', "images", "data", "compounds", comp_name)
							@agent.get(url).save(path)
							img_h = Hash.new
							img_h["oa_id"] = Image.new_oa_id
							img_h["image_file_path"] = path
							img_h["image_credit"] = wiki_data[3]
							img_h["compound_id"] = comp_hash["oa_id"]
							Image.new_image(img_h)
						end
					rescue
						puts "#{wiki_data[3]} failed!"
					end
				end
				
			end
		end
	end

	def self.import_from_wikimedia(comp_name)
		c_name = comp_name.gsub("+", "%2B")
		#search for compound 

		url = "https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&language=en&type=item&search=#{c_name}"
		json = @agent.get(url).body
		res = JSON.parse json
		
		#go through search results search: {"#":{"id":[id], "label":[exact match on name], "description":"chemical compound" }}
		unless res["search"].empty?
			res["search"].each do |result|
				if result["description"] == "chemical compound"
					wiki_id = result["id"]
					#get properties list https://www.wikidata.org/w/api.php?action=wbgetclaims&format=json&entity=[val]
					props_url = "https://www.wikidata.org/w/api.php?action=wbgetclaims&format=json&entity=#{wiki_id}"
					props_json = @agent.get(props_url).body
					props = JSON.parse props_json
					unless props["claims"].empty?
						#P2067 => atomic mass 
						a_mass = props["claims"]["P2067"] ? props["claims"]["P2067"][0]["mainsnak"]["datavalue"]["value"]["amount"].to_f.round(3) : nil
						#P274 => chemical formula 
						formula = props["claims"]["P274"] ? props["claims"]["P274"][0]["mainsnak"]["datavalue"]["value"] : nil
						#P117 => link to image https://upload.wikimedia.org/wikipedia/commons/f/f6/
						image = nil
						if props["claims"]["P117"]
							image_id = props["claims"]["P117"][0]["mainsnak"]["datavalue"]["value"]
							image = "https://upload.wikimedia.org/wikipedia/commons/f/f6/#{image_id}"
							image_cred = "https://commons.wikimedia.org/wiki/File:#{image_id}"
						end
						#P234 => InChI id, for generating nist webbook url, http://webbook.nist.gov/cgi/inchi/InChI=[val]
						inchi = props["claims"]["P234"] ? props["claims"]["P234"][0]["mainsnak"]["datavalue"]["value"] : nil
						return [a_mass, formula, image, image_cred, inchi, wiki_id]
					end
				end
			end
		end
		return []	
	end

	def self.set_agent(a_alias = 'Mac Safari')
    @agent = Mechanize.new
    @agent.pluggable_parser.default = Mechanize::Download
    @agent.user_agent_alias= a_alias
    return @agent
	end

end
