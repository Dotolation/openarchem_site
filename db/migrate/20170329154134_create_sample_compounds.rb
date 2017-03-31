class CreateSampleCompounds < ActiveRecord::Migration
  def change
    create_table :sample_compounds do |t|

      t.timestamps
    end
  end
end
