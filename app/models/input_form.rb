class InputForm 
   include ActiveModel::Model
#  To do:
#  add new fields to form
#  restructure to use the form helpers?
#  pass form contents to this model
#  create methods in the other models to actually enter everything
#    new_oa_id
#    new_record
  def self.new
    @input_form = []
  end

  def self.search_compounds(term)
    results = Compound.where('LOWER(formula) LIKE :term OR LOWER(name) LIKE :term', term: "%#{term.downcase}%").limit(20)
    final = results.sort{|x, y| (x =~ /#{term}/i) <=> (y =~ /#{term}/i) }
    return final
  end

  def self.search_sites(term)
    Site.where('LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end

  def self.get_plants(oa_id)
    plant_list = Plant.get_plants_from_compound(oa_id)
  end

  def self.get_ingredients(oa_id)
    ingredient_list = Product.find_by_plant_id(oa_id)
  end

  def self.create_sample(params)
    #"user"=>"", "catalog_number"=>"", "current_location"=>"", "object_type"=>"", "site"=>"", 
    #"site_region"=>"", "ora_number"=>"", "sample_type"=>, "sample_quality"=>"", 
    #"sample_quality_notes"=>"", "commit"=>"Submit", "diagnostic_compound"=>"", "interpretation"=>"", 
    #"interpretation_certainty"=>"", "interpretation_notes"=>"", "object_condition"=>"", 
    #"relative_date"=>"", "absolute_date"=>"", "object_fabric"=>"", "excavation_team"=>"", 
    #"excavation_date"=>"", "excavation_notes"=>"", "context"=>"", "object_biblio"=>""
    #locus_name, locus_type, sample_date, sample_time, 
    #subsample_amount, gcms_analysis_date, stored_in_plastic, plastic_in_gcms, 
    #ided_substance, notes, site_id, source_id, equipment_id, 
    #extraction_id, chromatogram_id, vetted, 
    sample_fields = Hash.new
    equipment_fields = Hash.new
    extraction_fields = Hash.new
    source_fields = Hash.new
    site_fields = Hash.new
    publication_fields = Hash.new
    biblio_fields = Hash.new

    params.each do |k, v|
      if k =~ /^sample/
        k1 = k.gsub(/^sample_/, "")
        sample_fields[k1] = v
      elsif k =~ /equipment/
        k1 = k.gsub(/equipment_/, "")
        equipment_fields[k1] = v
      elsif k =~ /extraction/
        k1 = k.gsub(/extraction_/, "")
        extraction_fields[k1] = v
      elsif k =~ /^source/
        k1 = k.gsub(/source_/, "")
        source_fields[k1] = v
      elsif k =~ /site/
        k1 = k.gsub(/site_/, "")
        site_fields[k1] = v
      elsif k =~ /publication/
        pub_and_bib_split(k, v, publication_fields)
      elsif k =~ /biblio/
        pub_and_bib_split(k, v, biblio_fields)
      end
           
    end
    #check if a sample exists

    ext_sample = Sample.where("archem_id = ?", sample_fields["archem_id"]).first
    if ext_sample
      raise "This sample id already exists, please check your data"
    else
      #new sample id
      sample_fields["oa_id"] = Sample.new_oa_id
      @sample = Sample.new_sample(sample_fields)

      #if a sample is new the extraction and equipment fields will also be new
      ex_id = Extraction.new_oa_id
      extraction_fields["oa_id"] = ex_id
      @extraction = Extraction.new_extraction(extraction_fields)
      @sample.extraction_id = ex_id

      eq_id = Equipment.new_oa_id
      equipment_fields["oa_id"] = eq_id
      @equipment = Equipment.new_equipment(equipment_fields)
      @sample.equipment_id = eq_id

      #check the site
      sit = Site.where("name = ?", site_fields["name"]).first
      if sit
        #site exists, don't add
        @site = sit
      else
        si_id = Site.new_oa_id
        site_fields["oa_id"] = si_id
        teams = []
        unless site_fields["director"].empty?
          #add the director or directors to the people and teams tables, keep the first for the director_id
          director = site_fields["director"]
          if director =~ /\s+and\s+/
            d_arr = director.split(/\s+and\s+/) 
          else
            d_arr = [director]
          end
          d_arr.each_index {|i| d_arr[i] = d_arr[i].split(/\s/)}
          people = []

          d_arr.each do |parts|
            #if person has more than two names listed, add the others to the first, can correct later if wrong
            if parts.length > 2
              parts[0] = parts[0] + " " + parts[1]
              parts.delete_at(1)
            end
            person_search = Person.where("last_name = ? and first_name = ?", parts[1], parts[0]).first
     
            unless person_search
              pers = Hash.new
              pers["oa_id"] = Person.new_oa_id
              pers["last_name"] = parts[1]
              pers["first_name"] = parts[0]
              @person = Person.new_person(pers)
              people << @person
            else
              @person = person_search
              people << person_search
            end
            #adding to teams table
            teams_hash = Hash.new
            teams_hash["sample_id"] = @sample.oa_id
            teams_hash["person_id"] = @person.oa_id
            teams_hash["site_id"] = site_fields["oa_id"] 
            teams << teams_hash
          end
        end
        site_fields["director_id"] = people[0].oa_id
        site_fields.delete("director")
        @site = Site.new_site(site_fields)
        teams.each {|t_h| Team.create(t_h)}
      end
      @sample.site_id = @site.oa_id

      #check source
      sou = Source.where("institution_id = ?", source_fields["institution_id"]).first
      if sou
        #source exists, don't add
        @source = sou
      else
        so_id = Source.new_oa_id
        source_fields["oa_id"] = so_id
        source_fields["site_id"] = @site.oa_id
        @source = Source.new_source(source_fields)
      end
      @sample.source_id = @source.oa_id

      #save images
      if params["img_source"]
        source_img_hash = Hash.new
        path, f_name = InputForm.upload(params["img_source"], "source") 
        source_img_hash["oa_id"] = Image.new_oa_id
        source_img_hash["image_file_path"] = path
        source_img_hash["image_credit"] = params["img_source_image_credit"]
        source_img_hash["source_id"] = @source.oa_id
        @source_img = Image.new_image(source_img_hash)

      elsif params["chrom_img"]

        path, f_name = InputForm.upload(params["chrom_img"], "chrom")
        chrom_hash = Hash.new
        #chromatogram is created here too
        chrom_hash["oa_id"] = Chromatogram.new_oa_id
        chrom_hash["sample_id"] = @sample.oa_id
        if params["chrom_file"]
          c_path, c_name = InputForm.upload(params["chrom_file"], "chrom_file") 
          chrom_hash["chrom_file_path"] = c_path
        end
        @chromatogram = Chromatogram.new_chromatogram(chrom_hash)
        @sample.chromatogram_id = @chromatogram.oa_id
        chrom_img_hash = Hash.new
        chrom_img_hash["oa_id"] = Image.new_oa_id
        chrom_img_hash["image_file_path"] = path
        chrom_img_hash["image_credit"] = params["chrom_img_image_credit"]
        chrom_img_hash["chromatogram_id"] = @chromatogram.oa_id
        @chrom_img = Image.new_image(chrom_img_hash)

      elsif params["petro_img"]
        petro_img_hash = Hash.new
        path, f_name = InputForm.upload(params["petro_img"], "petro")
        petro_img_hash["oa_id"] = Image.new_oa_id
        petro_img_hash["image_file_path"] = path
        petro_img_hash["image_credit"] = params["petro_img_image_credit"]
        @petro_img = Image.new_image(petro_img_hash)

      end

      #identification and product
      unless params["identification"] == ""
        #checks for an existing product name and adds if it doesn't exist, might want a suggestions list for this
        prod = Product.where("name = ?", params["identification"]).first
        if prod
          @product = prod
        else
          prod_hash = Hash.new
          prod_hash["oa_id"] = Product.new_oa_id
          prod_hash["name"] = params["identification"]
          @product = Product.new_product(prod_hash)
        end
        id_hash = Hash.new
        id_hash["oa_id"] = Identification.new_oa_id
        id_hash["certainty"] = params["identification_certainty"]
        id_hash["notes"] = params["identification_notes"]
        id_hash["sample_id"] = @sample.oa_id
        id_hash["product_id"] = @product.oa_id
        @identification = Identification.new_identification(id_hash)

      end

      #Publications and bibliography
      publication_fields.each do |key, pub_hash|
        pub_check = Publication.where("author = ? and title= ?", pub_hash["author"], pub_hash["title"]).first
        if pub_check
          @publication = pub_check
        else
          pub_hash["oa_id"] = Publication.new_oa_id
          @publication = Publication.new_publication(pub_hash)
        end

        if biblio_fields.has_key?(key)
          bib_hash = biblio_fields[key]
          #making a brand new fucking hash since I can't reassign values...
          different_hash = Hash.new
          different_hash["sample_id"] = @sample.oa_id if bib_hash["sample_id"] && bib_hash["sample_id"] == 1
          different_hash["chromatogram_id"] = @chromatogram.oa_id if bib_hash["chromatogram_id"] && bib_hash["chromatogram_id"] == 1
          different_hash["site_id"] = @site.oa_id if bib_hash["site_id"] && bib_hash["site_id"] == 1
          different_hash["source_id"] = @source.oa_id if bib_hash["source_id"] && bib_hash["source_id"] == 1
          different_hash["publication_id"] = @publication.oa_id
          Bibliography.new_bibliography(different_hash)
        end
      end

      #compounds
        #compounds should have been created earlier so just fill sample_compounds
      params.select{|k, v| k =~ /compound_id/}.each do |k1, v1|
        unless v1 == ""
          comp_hash = Hash.new
          comp_hash["sample_id"] = @sample.oa_id
          comp_hash["compound_id"] = v1

          #get the plant, accounting for fields with added numbers
          #product and plant name actually stores the oa_id, yeah, I know...
          add_on = k1.match(/\d+$/)
          comp_hash["plant_id"] = add_on ? params["plant_name" + add_on[0]] : params["plant_name"]

          #get product
          comp_hash["product_id"] = add_on ? params["product_name" + add_on[0]] : params["product_name"]

          @sample_compounds = SampleCompound.new_sample_compound(comp_hash)
        end

      end

      @sample.save
      return @sample
    end
    
  end

  def self.upload(uploaded_io, type)
    base = Rails.root.join('public', 'assets')
    if type == "chrom_file"
      f_name = uploaded_io.original_filename
      path = "data/chromatograms/" + uploaded_io.original_filename
      save_path = base.join(path)
      File.open(save_path, 'wb') do |file|
        file.write(uploaded_io.read)
        file.close
      end
    else
      if type == "source"
        f_name = uploaded_io.original_filename
        path = 'data/images/' + f_name
        save_path = base.join(path)
        File.open(save_path, 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end
      elsif type == "chrom"
        f_name = uploaded_io.original_filename
        path = 'data/chromatograms/' + f_name
        save_path = base.join(path)
        File.open(save_path, 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end
      elsif type == "petro"
        f_name = uploaded_io.original_filename
        path = 'data/images/' + f_name
        save_path = base.join(path)
        File.open(save_path, 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end      
      end
    end
    return path, f_name    
  end

  def self.mini_product(params)
    mp_hash = Hash.new
    mp_hash["oa_id"] = Product.new_oa_id
    mp_hash["name"] = params["product_name"]
    mp_hash["alternate_name"] = params["product_other_name"]
    mp_hash["plant_id"] = params["product_plant_id"]
    @product = Product.new_product(mp_hash)
    return @product
  end


  def self.pub_and_bib_split(k, v, p_or_b_hash)
    if k =~ /\d+$/
      parts = k.split(/_/)
      if parts[0] == "biblio"
        key = parts[1] + "_id"
      else
        key = parts[1]
      end
      if p_or_b_hash.has_key?(parts[2])
        p_or_b_hash[parts[2]][parts[1]] = v
      else
        p_or_b_hash[parts[2]] = {parts[1] => v}
      end
    else
      if k =~ /publication/
        k1 = k.gsub("publication_", "")
      else
        k3 = k.gsub("biblio_", "")
        k2 = k3.gsub(/_\d+$/, "")
        k1 = k2 + "_id"
      end
      if p_or_b_hash.has_key?("first")
        p_or_b_hash["first"][k1] = v
      else
        p_or_b_hash["first"] = {k1 => v}
      end
    end
  end
end