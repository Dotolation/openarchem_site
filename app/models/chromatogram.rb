class Chromatogram < ActiveRecord::Base


	def self.find_chromatogram(id)
		unless id.empty?
			chromatogram = Chromatogram.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return chromatogram		
	end

	def self.get_data_for_mini_view(id)
		chrom = Chromatogram.find_chromatogram(id)
		chrom_hash = Hash.new
		chrom_hash["display"] = chrom["oa_id"]
		chrom_hash["image_file_path"]  = chrom["file_path"]
		chrom_hash["notes"] = chrom["notes"]
		
		return chrom_hash
	end

end
