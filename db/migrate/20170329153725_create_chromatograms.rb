class CreateChromatograms < ActiveRecord::Migration
  def change
    create_table :chromatograms do |t|
      t.string :oa_id, null: false
      t.string :file_path
      t.text :notes
      t.timestamps
    end

    add_index :chromatograms, :oa_id, unique: true
  end
end
