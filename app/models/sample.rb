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
 		field_list = ["oa_id", "archem_id", "site_orig_id", "locus_name", "locus_type", "site_id", "source_id", "sample_date", "sample_time", "subsample_amount", "equipment_id", "gcms_analysis_date", "stored_in_plastic", "plastic_in_gcms", "extraction_id", "chromatogram_id", "ided_substance", "notes"]
 		link_fields = ["site_id", "source_id", "extraction_id", "chromatogram_id"]
 		#removed "equipment_id" from link_fields

 		sam_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			sam_hash[key] = val
 		end

 		site_data, source_data, extraction_data, chromatogram_data = Sample.get_data_for_inner_list(sam_hash["site_id"], sam_hash["source_id"], sam_hash["equipment_id"], sam_hash["extraction_id"], sam_hash["chromatogram_id"])
 		#removed equipment_data from above
 		return {"show_hash" => sam_hash, "inner_fields" => link_fields, "site_id" => site_data, "source_id" => source_data, "extraction_id" => extraction_data, "chromatogram_id" => chromatogram_data}
	end
	#removed "equipment_hash" => equipment_data from above

	def self.get_data_for_inner_list(site_id, source_id, equipment_id, extraction_id, chromatogram_id)
		#each x_data variable is a hash of the information
		site_data = Site.get_data_for_mini_view(site_id)
		source_data = Source.get_data_for_mini_view(source_id)
		#equipment_data = {} #Equipment.get_data_for_mini_view(equipment_id)
		extraction_data = Extraction.get_data_for_mini_view(extraction_id)
		chromatogram_data = Chromatogram.get_data_for_mini_view(chromatogram_id)

		return site_data, source_data, extraction_data, chromatogram_data
		#removed equipment_data from above
	end

	def self.show_sample_data(oa_id)
		data_hashes = get_data(oa_id)
	end

	def self.get_data_for_mini_view(id, id_name = nil)
		if id_name
			samples = Sample.find_sample_by_other_id(id_name, id)
		else
			samples = Sample.find_sample(id)
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
		else
			return sample_data
		end
	end
	

end
