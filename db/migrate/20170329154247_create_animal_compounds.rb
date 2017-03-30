class CreateAnimalCompounds < ActiveRecord::Migration
  def change
    create_table :animal_compounds do |t|

      t.timestamps
    end
  end
end
