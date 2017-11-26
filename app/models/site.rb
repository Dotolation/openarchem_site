class Site < ActiveRecord::Base
	belongs_to :sample
	has_many :people

	def self.new_oa_id
    oa_id = Site.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_site(vals_hash)
		@site = Site.create(vals_hash)
	end



	def self.find_site(id)
		unless id.empty?
			site = Site.where("oa_id = ?", id).first
		end
		#returns nil if no record found
	end


	def self.find_site_by_other_id(id, id_name)
		site = Site.where("#{id_name} = ?", id)
	end


	#get_data is for the base mysql pull and collecting of other data to show on a Site page
	def self.get_data(oa_id)
		doc = Site.find_site(oa_id)

 		#field_list is used to weed out unwanted fields in the display, like created_at 
 		field_list = ["oa_id", "geo_coords", "name", "project_url", "notes", "director_id"]
 		linked_fields = ["director_id"]
 		added_fields = ["sample_id"]

 		sit_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			sit_hash[key] = val
 		end

 		director_data, sample_data = Site.get_data_for_inner_list(doc["oa_id"], doc["director_id"])

 		return {"show_hash" => sit_hash, "inner_fields" => linked_fields, "added_fields" => added_fields, "director_id" => director_data, "sample_id" => sample_data}
	end


	#mini_view is for pulling Site info to display on another entity's page
	def self.get_data_for_mini_view(id, id_name=nil)
		field_list = ["name", "oa_id", "geo_coords", "project_url"]
		site_data = []
		
		if id_name
			site = Site.find_site_by_other_id(id, id_name)
			site.each do |site_rec|		
				site_data << field_list_run(field_list, site_rec)
			end
		else
			site = Site.find_site(id)
			site_data << field_list_run(field_list, site)
		end

		if site_data.length == 1
			return site_data[0]
		else
			return site_data
		end
	end


	def self.field_list_run(field_list, site)
		site_hash = Hash.new
		field_list.each do |key|	
			val = site[key]
			#setting the display field in the mini list
			if key == "name"
				site_hash["display"] = val
			else
				site_hash[key] = val
			end
		end
		return site_hash
	end


	#base method called by the catalog_show_helper to pull Site infoS
	def self.show_site_data(oa_id)
		data_arr = new_get_data(oa_id)
	end

	#inner_list is for getting other entities' data to put on a Site page
	def self.get_data_for_inner_list(site_id, director_id)
		director = Person.get_data_for_mini_view(director_id)

		sample_data = Sample.get_data_for_mini_view(site_id, "site_id")

		return director, sample_data
	end


	def self.get_id_and_name(oa_id)
		site = Site.find_site(oa_id)
		arr = [oa_id, site["name"], site["region"]]
		return arr
	end

	def self.get_atlas_link(oa_id)
		site = Site.find_site(oa_id)
		atlas = site["atlas_url"]
		return atlas
	end


	def self.new_get_data(oa_id)
		site = find_site(oa_id)
		director = Person.find_person(site["director_id"])
		bibliography = Bibliography.find_pubs_by_site_id(oa_id)
		objects = get_sources(oa_id)

		return {"show_hash" => site, "bib_hash" => bibliography, "director_hash" => director, "source_hash" => objects}
	end


	def self.get_sources(oa_id)
		sams = Sample.select(:source_id).distinct.where("site_id = ?", oa_id)
		sources = []
		sams.each{|rec| sources << rec["source_id"]}
		source_hash = Hash.new
		unless sams[0].nil?
			sources.each do |rec|
				sou = Source.find_source(rec)
				source_hash[sou["oa_id"]] = [sou["object_type"], sou["date"], sou["current_location"], sou["object_url"]]
			end
		else
			source_hash = nil
		end
		return source_hash
	end


end
