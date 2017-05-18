class PlantCompound < ActiveRecord::Base

	def self.find_by_plant_id(oa_id)
		unless oa_id.empty?
			#may have several return rows, so give back the group of activerecords
			p_comp = PlantCompound.where("plant_id = ?", oa_id)
		end
	end

	def self.find_by_compound_id(oa_id)
		unless oa_id.empty?
			#may have several return rows, so give back the group of activerecords
			p_comp = PlantCompound.where("compound_id = ?", oa_id)
		end
	end

	def self.get_data_for_mini_view(oa_id, type)
		if type == "plant"
			p_comp = find_by_plant_id(oa_id)
		else
			p_comp = find_by_compound_id(oa_id)
		end

		#the above may return multiple results, is array of activerecords
		#need to get compound info for each
		p_comp_arr = []

		if p_comp
			p_comp.each do |ar|
				compound_id = ar["compound_id"]
				p_comp_arr << Compound.get_data_for_mini_view(compound_id)
			end
		end

		return p_comp_arr
	end
	
end
