class AddProductIdToSampleCompounds < ActiveRecord::Migration[5.0]
    add_column :sample_compounds, :product_id, :string

    add_foreign_key :sample_compounds, :products, column: :product_id, primary_key: "oa_id"
  def change
  end
end
