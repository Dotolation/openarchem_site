class Person < ActiveRecord::Base

	def self.new_person(person)
	end

	def self.find_person(id)
		unless id.empty?
			person = Person.where("oa_id = ?", id).first
		end
		#returns nil if no record found
	end

	def self.get_data_for_mini_view(id)
		person = find_person(id)
		per_hash = Hash.new
		per_hash["oa_id"] = person["oa_id"]
		per_hash["display"] = person["first_name"] + " " + person["last_name"]
		per_hash["affiliation"] = person["affiliation"]

		return per_hash
	end

	def self.show_person_data(oa_id)
		data = get_data(oa_id)
	end	

	def self.get_data(oa_id)
		person = find_person(oa_id)
		field_list = ["oa_id", "last_name", "first_name", "affiliation"]
		added_fields = ["site_id"]
		per_hash = Hash.new

 		field_list.each do |key|
 			val = person[key]
 			per_hash[key] = val
 		end

 		site_data = get_data_for_inner_list(oa_id)
 		return {"show_hash" => per_hash, "inner_fields" => {}, "added_fields" => added_fields, "site_id" => site_data}
 	end

 	def self.get_data_for_inner_list(id)
 		sites = Site.get_data_for_mini_view(id, "director_id")
 	end	
end
