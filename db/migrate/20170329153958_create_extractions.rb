class CreateExtractions < ActiveRecord::Migration
  def change
    create_table :extractions do |t|
      t.string :oa_id, null: false
      t.string :solvent
      t.boolean :buchi
      t.boolean :swished
      t.boolean :boiled_manually
      t.text :notes
      t.timestamps
    end

    add_index :extractions, :oa_id, unique: true
  end
end
