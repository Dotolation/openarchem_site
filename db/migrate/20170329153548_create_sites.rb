class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :oa_id, null: false
      t.string :geo_coords
      t.string :name
      t.string :project_url
      t.text :notes
      t.timestamps
    end

    add_index :sites, :oa_id, unique: true
  end
end
