class AddLinksToAncientRefs < ActiveRecord::Migration[5.0]
  def change
    add_column :ancient_refs, :link1, :string
    add_column :ancient_refs, :link2, :string
    add_column :ancient_refs, :link3, :string

    add_column :sources, :site_id, :string

    add_foreign_key :sources, :sites, column: :site_id, primary_key: "oa_id"
  end
end
