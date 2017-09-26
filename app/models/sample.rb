class Sample < ActiveRecord::Base
	has_many :sites
	has_many :sources
	

	def self.new_sample(sample)
	end

	def self.find_sample(id)
		unless id.empty?
			sample = Sample.where("oa_id = ?", id).first
		end
		#returns nil if no record found	
	end

	def self.find_sample_by_other_id(id_name, id)
		#need to define a more robust error handler, but this will do for now...
		unless id.empty?
			#might be looking for all samples related to another id
			#!!Need to make this better, prevent entry of random column names!!
			sample = Sample.where("#{id_name} = ?", id)
			
		end
	end

	def self.get_data(oa_id)
 		doc = Sample.find_sample(oa_id)

 		#field_list is used to weed out unwanted fields in the display, like created_at 
 		field_list = ["oa_id", "archem_id", "site_orig_id", "site_id", "source_id", "sample_date", "sample_time", "subsample_amount", "gcms_analysis_date", "chromatogram_id", "ided_substance", "notes"]
 		link_fields = ["site_id", "source_id", "chromatogram_id"]
 		added_fields = ["identifications"]
 		
 		sam_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			sam_hash[key] = val
 		end

 		site_data, source_data, chromatogram_data, identification_data = Sample.get_data_for_inner_list(sam_hash["site_id"], sam_hash["source_id"], sam_hash["chromatogram_id"], oa_id)

 		image_hash = Image.get_image_data(sam_hash["source_id"], sam_hash["chromatogram_id"])

 		return {"show_hash" => sam_hash, "inner_fields" => link_fields, "added_fields" => added_fields, "site_id" => site_data, "source_id" => source_data, "chromatogram_id" => chromatogram_data, "identifications" => identification_data, "image_hash" => image_hash}
	end
	

	def self.get_data_for_inner_list(site_id, source_id, chromatogram_id, oa_id)
		#each x_data variable is a hash of the information
		site_data = Site.get_data_for_mini_view(site_id)
		source_data = Source.get_data_for_mini_view(source_id)
		chromatogram_data = Chromatogram.get_data_for_mini_view(chromatogram_id)
		identification_data = Identification.get_data_for_mini_view(oa_id, "sample")


		return site_data, source_data, chromatogram_data, identification_data
	end

	def self.show_sample_data(oa_id)
		data_hashes = new_get_data(oa_id)
	end

	def self.get_data_for_mini_view(id, id_name = nil)
		if id_name
			samples = Sample.find_sample_by_other_id(id_name, id)
		else
			#the below is silly, but if we don't have an array the .each fails, 
			#prioritizing the potential multi results from find_sample_by_other_ids
			samples = [Sample.find_sample(id)]
		end
		sample_data = []
		samples.each do |sample_hash|
			#creating a small hash for each sample and putting all hashes in an array
			s_h = Hash.new
			s_h["display"] = sample_hash["oa_id"]
			s_h["oa_id"] = sample_hash["oa_id"]
			s_h["notes"] = sample_hash["notes"]
			sample_data << s_h
		end
		if id_name && id_name != "site_id"
			#get the site id from one of the samples (all should have the same id, if not, that's weird)
			site_id = samples[0]["site_id"]

			return sample_data, site_id
		elsif samples.length == 1
			return sample_data[0]
		else
			return sample_data
		end
	end


	def self.new_get_data(oa_id)

		doc = Sample.find_sample(oa_id)
		
		sample_info_hash = Hash.new
		sample_info_hash["sample_type"] = doc["sample_type"]

		qual = Sample.sample_qual_convert(doc["sample_quality"])

    sample_info_hash["sample_quality"] = qual
    sample_info_hash["final_identification"] = Identification.get_product_name_and_id(oa_id)
    
    #get hash of diagnostic compound names and and plant names with their oa_ids
    #hash[compound_name] = [compound_id, c_dukes_url, c_nist_url, plant_name, plant_id, p_dukes_url, product_name, ancient_reference_hash]
    compound_plant_hash = SampleCompound.get_plants_for_sample(oa_id)

    image_hash = Image.get_image_data(doc["source_id"], doc["chromatogram_id"])
    source = Source.get_source_and_bib(doc["source_id"])
    sample_info_hash["source"] = [doc["source_id"], source[0]["object_type"], source[1]]
    sample_info_hash["find_site"] = Site.get_id_and_name(doc["site_id"])
    sample_info_hash["date_rel"] = source[0]["date"]
    sample_info_hash["date_abs"] = ""
    sample_info_hash["prod_location"] = ""
    sample_info_hash["curr_location"] = source[0]["current_location"]

    details_hash = Sample.get_details(doc)

    return {"show_hash" => sample_info_hash, "table_info" => compound_plant_hash, "image_hash" => image_hash, "details_hash" => details_hash}
	end
	

	def self.get_details(doc)
		ext = Extraction.find_extraction(doc["extraction_id"])
		equ = Equipment.find_equipment(doc["equipment_id"])

		details_hash = {"Sample" => doc, "Extraction" => ext, "Equipment" => equ}
		
		return details_hash
	end

	def self.sample_qual_convert(sq)

		case sq
		when 5
			qual = 'Closed intact, in situ' 
		when 4
      qual = 'Open intact/Closed fragmented, in situ'
    when 3
      qual = 'Diagnostic sherd, unwashed'
    when 2
      qual = 'Any washed on site/Legacy unwashed'
    when 1
      qual = 'Any washed or treated'
    end

    return qual
  end
end
