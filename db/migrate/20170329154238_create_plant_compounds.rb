class CreatePlantCompounds < ActiveRecord::Migration
  def change
    create_table :plant_compounds do |t|

      t.timestamps
    end
  end
end
