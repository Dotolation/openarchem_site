class Product < ActiveRecord::Base
	def self.new_oa_id
    oa_id = Product.last.oa_id.sub(/\d+$/) {|d| (d.to_i + 1).to_s}
  end

	def self.new_product(vals_hash)
		@product = Product.create(vals_hash)
	end
	#base method called by the catalog_show_helper to pull product info
	def self.show_product_data(oa_id)
		data_arr = get_data(oa_id)
	end


	def self.find_product(id)
		unless id.empty?
			prod = Product.where("oa_id = ?", id).first
		end
		#returns nil if no record found
	end

	def self.find_by_plant_id(id)
		unless id.empty?
			prod = Product.where("plant_id = ?", id)
		else
			return nil
		end
		return prod
	end


	#get_data is for the base mysql pull and collecting of other data to show on a Site page
	def self.get_data(oa_id)
		doc = find_product(oa_id)

 		#field_list is used to weed out unwanted fields in the display, like created_at 
 		field_list = ["oa_id", "name", "alternate_name", "plant_id", "plant_part", "description"]
 		linked_fields = ["plant_id"] #will add animal_id and animal_part when it becomes relevant
 		added_fields = ["product_ingredients"]

 		pro_hash = Hash.new

 		field_list.each do |key|
 			val = doc[key]
 			pro_hash[key] = val
 		end

 		plant_data, product_data = get_data_for_inner_list(doc["plant_id"], oa_id)

 		return {"show_hash" => pro_hash, "inner_fields" => linked_fields, "added_fields" => added_fields, "plant_id" => plant_data, "product_ingredients" => product_data}
	end


	#mini_view is for pulling Product info to display on another entity's page
	def self.get_data_for_mini_view(id)
		prod = find_product(id)
		field_list = ["oa_id", "name", "description"]
		prod_hash = Hash.new

 		field_list.each do |key|
 			if key == "name"
				val = prod[key]
				prod_hash["display"] = val
			else
	 			val = prod[key]
	 			prod_hash[key] = val
	 		end
 		end

 		return prod_hash
	end


	#inner_list is for getting other entities' data to put on a Product page
	#will add animal info when it becomes relevant
	def self.get_data_for_inner_list(plant_id, product_id)
		if plant_id
			plant_data = Plant.get_data_for_mini_view(plant_id)
		else
			plant_data = nil
		end
		
		product_data = ProductIngredient.get_data_for_mini_view(product_id, "product_id")

		return plant_data, product_data
	end
end
