class Equipment < ActiveRecord::Base

	def self.new_oa_id
    oa_id = Equipment.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_equipment(vals_hash)
    @equipment = Equipment.create(vals_hash)
	end

	def self.find_equipment(id)
		unless id.empty?
			equipment = Equipment.where("oa_id = ?", id).first
		end

		#returns nil if no record found
		return equipment		
	end


	def self.get_data(oa_id)
		equip = find_equipment(oa_id)

		field_list = ["oa_id", "manufacturer", "model", "column_manufacturer", "column_model", "detector", "settings", "notes"]
 		linked_fields = []
 		added_fields = []

 		equ_hash = Hash.new

 		field_list.each do |key|
 			val = equip[key]
 			equ_hash[key] = val
 		end

 		return {"show_hash" => equ_hash, "inner_fields" => linked_fields, "added_fields" => added_fields}
	end


	def self.show_equipment_data(oa_id)
		data = get_data(oa_id)
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
