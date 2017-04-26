class CreateCompounds < ActiveRecord::Migration
  def change
    create_table :compounds do |t|
      t.string :oa_id, null: false
      t.string :formula
      t.float :molecular_weight
      t.string :name
      t.string :image_file_path
      t.boolean :ancient
      t.string :outside_db_url
      t.text :notes
      t.float :peak_time
      t.timestamps
    end

    add_index :compounds, :oa_id, unique: true
  end
end
