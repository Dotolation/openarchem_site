class CreatePeaks < ActiveRecord::Migration
  def change
    create_table :peaks do |t|
      t.string :oa_id, null: false
      t.integer :peak_number
      t.float :retention_time
      t.integer :peak_height
      t.integer :peak_area
      t.float :peak_area_div_height
      t.float :relative_abundance
      t.float :absolute_abundance
      t.timestamps
    end

    add_index :peaks, :oa_id, unique: true
  end
end
