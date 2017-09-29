class Image < ActiveRecord::Base

  def self.find_image_by_source_id(id)
    unless id.empty?
      source = Image.where("source_id = ?", id)
    else
      nil
    end
  end


  def self.find_image_by_chromatogram_id(id)
    unless id.empty?
      chrom = Image.where("chromatogram_id = ?", id)
    else
      nil
    end
  end


  def self.find_image_by_plant_id(id)
    unless id.empty?
      pla = Image.where("plant_id = ?", id)
    else
      nil
    end
  end


  def self.find_image_by_compound_id(id)
    unless id.empty?
      pla = Image.where("compound_id = ?", id)
    else
      nil
    end
  end


  def self.get_image_data(source_id, chromatogram_id)
    image_hash = Hash.new

    unless source_id == nil
      source_img = Image.find_image_by_source_id(source_id) 
      source_img.each do |rec|
        image_hash[rec["oa_id"]] = [rec["source_id"], rec["image_file_path"], rec["image_credit"]]
      end
    end

    unless chromatogram_id == nil
      chrom_img = Image.find_image_by_chromatogram_id(chromatogram_id)
      chrom_img.each do |rec|
        image_hash[rec["oa_id"]] = [rec["chromatogram_id"], rec["image_file_path"], rec["image_credit"]]
      end
    end

    return image_hash
  end

  def self.get_plant_images(plant_id)
    image_hash = Hash.new

    unless plant_id == nil
      p_img = Image.find_image_by_plant_id(plant_id)
      p_img.each do |rec|
        image_hash[rec["oa_id"]] = [rec["plant_id"], rec["image_file_path"], rec["image_credit"]]
      end
    end
    return image_hash
  end

  def self.get_compound_images(compound_id)
    image_hash = Hash.new
    
    unless compound_id.nil?
      com_img = Image.find_image_by_compound_id(compound_id)
      com_img.each do |rec|
        image_hash[rec["oa_id"]] = [rec["compound_id"], rec["image_file_path"], rec["image_credit"]]
      end
    end
    return image_hash
  end

end