class ChangeAncientRefsAndBib < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :bibliography, column: :ancient_ref_id
    remove_column :bibliography, :ancient_ref_id

    change_table :ancient_refs do |t|
      t.string :product_id
    end
    add_foreign_key :ancient_refs, :products, column: :product_id, primary_key: "oa_id"
    
  end
end
