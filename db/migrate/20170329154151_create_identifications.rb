class CreateIdentifications < ActiveRecord::Migration
  def change
    create_table :identifications do |t|
      t.string :oa_id, null: false
      t.string :certainty
      t.text :notes
      t.timestamps
    end

    add_index :identifications, :oa_id, unique: true
  end
end
