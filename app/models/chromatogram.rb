class Chromatogram < ActiveRecord::Base

	def self.new_oa_id
    oa_id = Chromatogram.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

  def self.new_chromatogram(vals_hash)
  	@chromatogram = Chromatogram.create(vals_hash)
  end

	def self.find_chromatogram(id)
		unless id.empty?
			chromatogram = Chromatogram.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return chromatogram		
	end

	def self.show_chromatogram_data(oa_id)
		data_arr = new_get_data(oa_id)
	end

	def self.get_data(oa_id)
		chrom = find_chromatogram(oa_id)

		field_list = ["oa_id", "notes", "sample_id"]
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
		chrom_hash["notes"] = chrom["notes"]
		
		return chrom_hash
	end


	def self.new_get_data(oa_id)
		chrom = find_chromatogram(oa_id)
		image_hash = Image.get_image_data(nil, oa_id)
		peak_hash = Peak.get_by_chromatogram_id(oa_id)
		comp_hash = Compound.get_sample_diagnostic_comps(chrom["sample_id"])

		return {"show_hash" => chrom, "image_hash" => image_hash, "peak_hash" => peak_hash, "comp_hash" => comp_hash}
	end
end
