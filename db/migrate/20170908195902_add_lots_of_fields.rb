class AddLotsOfFields < ActiveRecord::Migration[5.0]
  def change
    #additions to schema
    #chromatograms
    add_column :chromatograms, :image_file_path, :string
    
    #equipment
    add_column :equipment, :date, :string
    add_column :equipment, :location, :string
    add_column :equipment, :solvent, :string
    
    #extractions
    add_column :extractions, :date, :string
    add_column :extractions, :location, :string
    add_column :extractions, :ext_number, :string

    #samples
    add_column :samples, :author_id, :string
    add_column :samples, :editor_id, :string
    add_column :samples, :vetted, :boolean
    add_column :samples, :sample_type, :string
    add_column :samples, :sample_quality, :integer
    add_column :samples, :quality_notes, :string

    #sites
    add_column :sites, :date, :string

    #sources
    add_column :sources, :petro_image, :string
    add_column :sources, :date, :string
    add_column :sources, :excavation_date, :string
    add_column :sources, :excavation_notes, :text
    add_column :sources, :current_location, :string
    add_column :sources, :institution_id, :string

    #collectors/teams
    rename_table :collectors, :teams
    add_column :teams, :extraction_id, :string
    add_column :teams, :equipment_id, :string
    add_column :teams, :site_id, :string

    #adding tables
    create_table :publications do |t|
      t.string :oa_id
      t.string :author
      t.string :title
      t.string :journal_name
      t.string :publisher
      t.string :year
      t.string :pages
      t.timestamps
    end

    create_table :bibliography do |t|
      t.string :publication_id
      t.string :sample_id
      t.string :chromatogram_id
      t.string :site_id
      t.string :source_id
      t.string :other_analysis_id
      t.timestamps
    end

    create_table :other_analysis do |t|
      t.string :oa_id
      t.string :type
      t.timestamps
    end

    #fk creation
    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_auth_id`
      FOREIGN KEY (`author_id` )
      REFERENCES `openarchem`.`people` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_auth_idx` (`author_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`samples` 
      ADD CONSTRAINT `sam_ed_id`
      FOREIGN KEY (`editor_id` )
      REFERENCES `openarchem`.`people` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `sam_ed_idx` (`editor_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`teams` 
      ADD CONSTRAINT `t_ext_id`
      FOREIGN KEY (`extraction_id` )
      REFERENCES `openarchem`.`extractions` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `t_ext_idx` (`extraction_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`teams` 
      ADD CONSTRAINT `t_equ_id`
      FOREIGN KEY (`equipment_id` )
      REFERENCES `openarchem`.`equipment` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `t_equ_idx` (`equipment_id` ASC) ;
    SQL

    

  end
end
