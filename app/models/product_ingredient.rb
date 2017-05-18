class ProductIngredient < ApplicationRecord

	def self.find_by_product_id(oa_id)
		unless oa_id.empty?
			#may have several return rows, so give back the group of activerecords
			p_comp = ProductIngredient.where("product_id = ?", oa_id)
		end
	end

	def self.find_by_linked_product_id(oa_id)
		unless oa_id.empty?
			#may have several return rows, so give back the group of activerecords
			p_comp = ProductIngredient.where("linked_product_id = ?", oa_id)
		end
	end

	def self.find_by_plant_id(oa_id)
		unless oa_id.empty?
			#may have several return rows, so give back the group of activerecords
			p_ing = ProductIngredient.where("plant_id = ?", oa_id)
		end
	end

	def self.get_data_for_mini_view(oa_id, type)
		if type == "linked_product"
			p_ing = find_by_linked_product_id(oa_id)
		else
			p_ing = find_by_product_id(oa_id)
		end

		#the above may return multiple results, is array of activerecords
		#need to get compound info for each
		p_ing_arr = []

		if p_ing
			p_ing.each do |ar|
				if ar["linked_product_id"]
					product_id = ar["linked_product_id"]
					p_ing_arr << Product.get_data_for_mini_view(product_id)
				else 
					plant_id = ar["plant_id"]
					p_ing_arr << Plant.get_data_for_mini_view(plant_id)
				end
			end
		end

		return p_ing_arr
	end

end
