class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :oa_id, null: false
      t.string :archem_id
      t.string :site_orig_id
      t.string :locus_name
      t.string :locus_type
      t.date :sample_date
      t.time :sample_time
      t.string :subsample_amount
      t.date :gcms_analysis_date
      t.boolean :stored_in_plastic
      t.boolean :plastic_in_gcms
      t.boolean :ided_substance
      t.text :notes
      t.timestamps
    end

    add_index :samples, :oa_id, unique: true
  end
end
