class AddDbFields < ActiveRecord::Migration[5.0]
  def change
    add_column :sources, :absolute_date, :string
    add_column :sources, :production_location, :string
    add_column :sources, :lcp_url, :string

    add_column :sites, :atlas_url, :string

    add_column :plants, :flora_url, :string

    add_column :publications, :url, :string

  end
end
