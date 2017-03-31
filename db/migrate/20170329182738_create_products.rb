class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
    	t.string :oa_id, null: false
    	t.string :name
    	t.string :alternate_name
    	t.string :plant_id
    	t.string :plant_part
    	t.string :animal_id
    	t.string :animal_part
    	t.string :description
      t.timestamps
    end

    add_index :products, :oa_id, unique: true
  end
end
