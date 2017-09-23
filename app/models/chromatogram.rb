class Chromatogram < ActiveRecord::Base


	def self.find_chromatogram(id)
		unless id.empty?
			chromatogram = Chromatogram.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return chromatogram		
	end

	def self.show_chromatogram_data(oa_id)
		data_arr = get_data(oa_id)
	end

	def self.get_data(oa_id)
		chrom = find_chromatogram(oa_id)

		field_list = ["oa_id", "image_file_path", "notes", "sample_id"]
 		linked_fields = ["sample_id"]

 		chr_hash = Hash.new

 		field_list.each do |key|
 			val = chrom[key]
 			chr_hash[key] = val
 		end

 		sample_data = get_data_for_inner_list(chrom["sample_id"])

 		return {"show_hash" => chr_hash, "inner_fields" => linked_fields, "sample_id" => sample_data}
	end
	
	def self.get_data_for_inner_list(sample_id)
	
		sample_data = Sample.get_data_for_mini_view(sample_id)

		return sample_data
	end

	def self.get_data_for_mini_view(id)
		chrom = Chromatogram.find_chromatogram(id)
		chrom_hash = Hash.new
		chrom_hash["display"] = chrom["oa_id"]
		chrom_hash["image_file_path"]  = chrom["image_file_path"]
		chrom_hash["notes"] = chrom["notes"]
		
		return chrom_hash
	end

end
