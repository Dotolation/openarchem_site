class AddLitReferencesAndImages < ActiveRecord::Migration[5.0]
  def change
    #adding ancient references
    create_table :ancient_refs do |t|
      t.string :oa_id, null: false
      t.string :author
      t.string :work
      t.string :link
      t.text :excerpt
      t.text :excerpt_eng
      t.timestamps
    end
    add_index :ancient_refs, :oa_id, unique: true

    add_column :bibliography, :ancient_ref_id, :string
    add_foreign_key :bibliography, :ancient_refs, column: :ancient_ref_id, primary_key: "oa_id"


    #separate images table
    create_table :images do |t|
      t.string :oa_id, null: false
      t.string :image_file_path
      t.text :image_credit
      t.string :source_id
      t.string :site_id
      t.string :plant_id
      t.string :animal_id
      t.string :chromatogram_id
      t.string :compound_id
      t.string :product_id
      t.timestamps
    end
    add_index :images, :oa_id, unique: true

    add_foreign_key :images, :sources, column: :source_id, primary_key: "oa_id"
    add_foreign_key :images, :sites, column: :site_id, primary_key: "oa_id"
    add_foreign_key :images, :plants, column: :plant_id, primary_key: "oa_id"
    add_foreign_key :images, :animals, column: :animal_id, primary_key: "oa_id"
    add_foreign_key :images, :chromatograms, column: :chromatogram_id, primary_key: "oa_id"
    add_foreign_key :images, :compounds, column: :compound_id, primary_key: "oa_id"
    add_foreign_key :images, :products, column: :product_id, primary_key: "oa_id"

    #removing images from other tables
    change_table :animals do |t|
      t.remove :image_file_path, :image_credit
    end

    change_table :chromatograms do |t|
      t.remove :image_file_path
    end

    change_table :compounds do |t|
      t.remove :image_file_path, :image_credit
      t.string :nist_url
      t.rename :outside_db_url, :dukes_url
    end

    change_table :plants do |t|
      t.remove :image_file_path, :image_credit
    end

    change_table :sources do |t|
      t.remove :image_file_path, :image_credit
    end
  end
end
