class CreatePlantCompounds < ActiveRecord::Migration
  def change
    create_table :plant_compounds do |t|
      t.string :plant_part,
      t.timestamps
    end
  end
end
