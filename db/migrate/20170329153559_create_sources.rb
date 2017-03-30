class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :oa_id, null: false
      t.string :coords
      t.boolean :soil_sample
      t.text :notes
      t.string :object_condition
      t.string :object_type
      t.string :petrography
      t.string :object_treatment
      t.boolean :published
      t.string :object_url
      t.timestamps
    end

    add_index :sources, :oa_id, unique: true
  end
end
