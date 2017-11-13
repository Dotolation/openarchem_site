class AddPlantIdToSampleCompounds < ActiveRecord::Migration[5.0]
  def change
    add_column :sample_compounds, :plant_id, :string

    add_foreign_key :sample_compounds, :plants, column: :plant_id, primary_key: "oa_id"
  end
end
