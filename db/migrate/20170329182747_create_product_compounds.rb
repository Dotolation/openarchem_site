class CreateProductCompounds < ActiveRecord::Migration
  def change
    create_table :product_compounds do |t|
    	t.string :product_id
    	t.string :compound_id
      t.timestamps
    end
  end
end
