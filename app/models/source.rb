class Source < ActiveRecord::Base

	def self.new_oa_id
    oa_id = Source.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_source(vals_hash)
		@source = Source.create(vals_hash)
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
		field_list = ["oa_id", "soil_sample", "object_type", "object_url"] 

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
 		field_list = ["oa_id", "coords", "soil_sample", "notes", "object_condition", "object_type", "petrograpy", "object_treatement", "published", "object_url"]
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
		data = new_get_data(oa_id)
	end


	def self.get_source_and_bib(oa_id)
		source = Source.find_source(oa_id)
		pubs = Bibliography.find_pubs_by_source_id(oa_id)
		arr = [source, pubs]
	end


	def self.new_get_data(oa_id)
		source = Source.find_source(oa_id)
		source_hash = Hash.new
		sample_data, site_id = Sample.get_data_for_mini_view(oa_id, "source_id")
		image_hash = Image.get_image_data(oa_id, nil)
		site = Site.get_id_and_name(site_id)
		site << Site.get_atlas_link(site_id)
		sample_ids = []
		sample_data.each{|a| sample_ids << a["oa_id"]}
		
		source_hash["sample_ids"] = sample_ids
		source_hash["oa_id"] = oa_id
		source_hash["site"] = site
		source_hash["date"] = source["date"]
		source_hash["object_type"] = source["object_type"]
		source_hash["petrograpy"] = source["petrograpy"]
		source_hash["bibliography"] = Bibliography.find_pubs_by_source_id(oa_id).to_a

		details_hash = Source.get_details(source, site_id)

		return {"source_hash" => source_hash, "image_hash" => image_hash, "details_hash" => details_hash}

	end


	def self.get_details(source, site_id)
		site = Site.find_site(site_id)

		details_hash = {"Source" => source, "Site" => site}
	end

end
