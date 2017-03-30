class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :oa_id, null: false
      t.string :manufacturer
      t.string :model
      t.integer :year
      t.string :column_manufacturer
      t.string :column_model
      t.text :settings
      t.text :notes
      t.timestamps
    end

    add_index :equipment, :oa_id, unique: true
  end
end
