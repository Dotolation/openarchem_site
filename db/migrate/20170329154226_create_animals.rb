class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :oa_id, null: false
      t.string :scientific_name
      t.string :common_name
      t.text :description
      t.string :image_file_path
      t.string :reference_url
      t.timestamps
    end

    add_index :animals, :oa_id, unique: true
  end
end
