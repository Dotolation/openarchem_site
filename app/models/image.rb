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


  def self.get_image_data(source_id, chromatogram_id)
    image_hash = Hash.new
    source_img = Image.find_image_by_source_id(source_id) 
    chrom_img = Image.find_image_by_chromatogram_id(chromatogram_id)

    
    source_img.each do |rec|
      image_hash[rec["oa_id"]] = [rec["source_id"], rec["image_file_path"], rec["image_credit"]]
    end

    chrom_img.each do |rec|
      image_hash[rec["oa_id"]] = [rec["chromatogram_id"], rec["image_file_path"], rec["image_credit"]]
    end

    return image_hash
  end
end