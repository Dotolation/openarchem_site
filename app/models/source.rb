class Source < ActiveRecord::Base

	def self.new_source(source)
	end


	def self.find_source(id)
		unless id.empty?
			source = Source.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return source		
	end

	#mini_view is for pulling Source info to display on another entity's page
	def self.get_data_for_mini_view(id)
		source = Source.find_source(id)
		field_list = ["oa_id", "soil_sample", "object_type", "object_url", "image_file_path", "image_credit"] 
		#add in image field above
		source_hash = Hash.new
		
		field_list.each do |key|
			if key == "soil_sample"
				val = source[key] == false ? "object" : "soil sample"
				source_hash["display"] = val
			else
				val = source[key]
				source_hash[key] = val
			end
		end
				
		return source_hash		
	end


	#get_data is for the base mysql pull and collecting of other data to show on a Source page
	def self.get_data(oa_id)
 		doc = Source.find_source(oa_id)

 		#field_list is used to weed out unwanted fields in the display, like created_at 
 		field_list = ["oa_id", "coords", "soil_sample", "notes", "object_condition", "object_type", "petrograpy", "object_treatement", "published", "object_url", "image_file_path", "image_credit"]
 		added_fields = ["site_id", "sample_id"]

 		sou_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			sou_hash[key] = val
 		end

 		site_data, sample_data = Source.get_data_for_inner_list(oa_id)

 		return {"show_hash" => sou_hash, "inner_fields" => {}, "added_fields" => added_fields, "site_id" => site_data, "sample_id" => sample_data}
	end


	#inner list, associated samples and source site
	def self.get_data_for_inner_list(id)
		#this will return an active record relation, since there may be multiple samples for a source
		sample_data, site_id = Sample.get_data_for_mini_view(id, "source_id")

		site_data = Site.get_data_for_mini_view(site_id)

		return site_data, sample_data
	end

	def self.show_source_data(oa_id)
		data = get_data(oa_id)
	end

end
