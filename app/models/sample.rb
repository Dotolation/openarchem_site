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
		return sample		
	end

	def self.get_data(oa_id)
 		doc = Sample.find_sample(oa_id)

 		#field_list is used to weed out unwanted fields in the display, like created_at 
 		field_list = ["oa_id", "archem_id", "site_orig_id", "locus_name", "locus_type", "site_id", "source_id", "sample_date", "sample_time", "subsample_amount", "equipment_id", "gcms_analysis_date", "stored_in_plastic", "plastic_in_gcms", "extraction_id", "chromatogram_id", "ided_substance", "notes"]
 		link_fields = ["site_id", "source_id", "equipment_id", "extraction_id", "chromatogram_id"]

 		sam_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			sam_hash[key] = val
 		end

 		site_data, source_data, equipment_data, extraction_data, chromatogram_data = Sample.get_data_for_inner_list(sam_hash["site_id"], sam_hash["source_id"], sam_hash["equipment_id"], sam_hash["extraction_id"], sam_hash["chromatogram_id"])

 		return [sam_hash, link_fields, site_data, source_data, equipment_data, extraction_data, chromatogram_data]
	end

	def self.get_data_for_inner_list(site_id, source_id, equipment_id, extraction_id, chromatogram_id)
		#each x_data variable is a hash of the information
		site_data = Site.get_data_for_mini_view(site_id)
		source_data = Source.get_data_for_mini_view(source_id)
		equipment_data = {} #Equipment.get_data_for_mini_view(equipment_id)
		extraction_data = Extraction.get_data_for_mini_view(extraction_id)
		chromatogram_data = Chromatogram.get_data_for_mini_view(chromatogram_id)

		return site_data, source_data, equipment_data, extraction_data, chromatogram_data
	end

	def self.show_sample_data(oa_id)
		data_arr = get_data(oa_id)
	end

	

end
