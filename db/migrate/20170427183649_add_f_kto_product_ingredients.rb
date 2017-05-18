class AddFKtoProductIngredients < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :product_ingredients, :products, column: :product1_id, primary_key: "oa_id"
  	add_foreign_key :product_ingredients, :products, column: :product2_id, primary_key: "oa_id"
  	add_foreign_key :product_ingredients, :plants, column: :plant_id, primary_key: "oa_id"
  	add_foreign_key :product_ingredients, :animals, column: :animal_id, primary_key: "oa_id"
  end
end
