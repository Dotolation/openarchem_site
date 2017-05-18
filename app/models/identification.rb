class Identification < ActiveRecord::Base

	def self.find_identification(id)
		#may have several return rows, so give back the group of activerecords
		if id
			ident = Identification.where("oa_id = ?", id).first
		else
			ident = nil
		end
		return ident
	end

	def self.find_identification_by_sample_id(id)
		if id
			ident = Identification.where("sample_id = ?", id)
		else
			ident = nil
		end
		return ident
	end

	def self.find_identification_by_product_id(id)
		if id
			ident = Identification.where("product_id = ?", id)
		else
			ident = nil
		end
		return ident
	end	

	def self.show_identification_data(oa_id)
		data_hashes = get_data(oa_id)
	end

	def self.get_data(oa_id)
		doc = find_identification(oa_id)
		field_list = ["oa_id", "sample_id", "product_id", "certainty", "notes"]
		inner_fields = ["sample_id", "product_id"]

		id_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			id_hash[key] = val
 		end

 		 sample_data, product_data = Identification.get_data_for_inner_list(doc["sample_id"], doc["product_id"])
 		
 		return {"show_hash" => id_hash, "inner_fields" => inner_fields, "sample_id" => sample_data, "product_id" => product_data }
	end

	def self.get_data_for_inner_list(sample_id, product_id)
		sample_data = Sample.get_data_for_mini_view(sample_id)
		product_data = Product.get_data_for_mini_view(product_id)

		return sample_data, product_data
	end

	def self.get_data_for_mini_view(id, type)
		if type == "sample"
			ident = find_identification_by_sample_id(id)
		else
			ident = find_identification_by_product_id(id)
		end

		#might have multiple identifications for a sample, need to get info for each
		ident_data = []
		
		ident.each do |id_hash|
			ident_data << inner_mini_view(id_hash)
		end
				
		return ident_data	
	end

	def self.inner_mini_view(ident)
		field_list =["oa_id", "product", "certainty", "notes"]

		i_hash = Hash.new
		
		field_list.each do |key|
			if key == "product"
				val = Product.find_product(ident["product_id"])["name"]
				i_hash["display"] = val
			else
				val = ident[key]
				i_hash[key] = val
			end
		end
				
		return i_hash	
	end

end
