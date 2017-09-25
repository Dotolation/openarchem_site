class AddMoreFKs < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
      ALTER TABLE `openarchem`.`teams` 
      ADD CONSTRAINT `t_sit_id`
      FOREIGN KEY (`site_id` )
      REFERENCES `openarchem`.`sites` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `t_sit_idx` (`site_id` ASC) ;
    SQL
    change_column_null :publications, :oa_id, false
    add_index :publications, :oa_id, unique: true
    
    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_pub_id`
      FOREIGN KEY (`publication_id` )
      REFERENCES `openarchem`.`publications` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_pub_idx` (`publication_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_sam_id`
      FOREIGN KEY (`sample_id` )
      REFERENCES `openarchem`.`samples` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_sam_idx` (`sample_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_chro_id`
      FOREIGN KEY (`chromatogram_id` )
      REFERENCES `openarchem`.`chromatograms` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_chro_idx` (`chromatogram_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_sit_id`
      FOREIGN KEY (`site_id` )
      REFERENCES `openarchem`.`sites` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_sit_idx` (`site_id` ASC) ;
    SQL

    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_sou_id`
      FOREIGN KEY (`source_id` )
      REFERENCES `openarchem`.`sources` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_sou_idx` (`source_id` ASC) ;
    SQL

    change_column_null :other_analysis, :oa_id, false
    add_index :other_analysis, :oa_id, unique: true

    execute <<-SQL
      ALTER TABLE `openarchem`.`bibliographies` 
      ADD CONSTRAINT `bib_oth_id`
      FOREIGN KEY (`other_analysis_id` )
      REFERENCES `openarchem`.`other_analysis` (`oa_id` )
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
      ADD INDEX `bib_oth_idx` (`other_analysis_id` ASC) ;
    SQL

  end
end
