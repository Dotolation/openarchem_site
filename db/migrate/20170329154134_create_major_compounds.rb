class CreateMajorCompounds < ActiveRecord::Migration
  def change
    create_table :major_compounds do |t|

      t.timestamps
    end
  end
end
