class Equipment < ActiveRecord::Base

	def self.find_equipment(id)
		unless id.empty?
			equipment = Equipment.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return equipment		
	end

	def self.get_data(document)
	end

	def self.get_data_for_mini_view(id)
		equip = Equipment.find_equipment(id)
		field_list = ["oa_id", "settings"] 
		equip_hash = Hash.new

		#combining two fields for a display in the mini list
		equip_hash["display"] = equip["manufacturer"] + " " + equip["model"]
		
		field_list.each do |key|
			val = equip[key]
			equip_hash[key] = val
		end

		return equip_hash
	end

end
