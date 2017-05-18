class CreateProductIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :product_ingredients do |t|
    	t.string :product_id
    	t.string :linked_product_id
    	t.string :plant_id
    	t.string :animal_id
      t.timestamps
    end
  end
end
