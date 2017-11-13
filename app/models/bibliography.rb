class Bibliography < ActiveRecord::Base

  def self.new_bibliography(vals_hash)
    @bibliography = Bibliography.create(vals_hash)
    
    return @bibliography
  end

  def self.find_pubs_by_source_id(id)
    unless id.empty?
      bib = Bibliography.where("source_id = ?", id)
      pubs = []
      bib.to_a.each do |rec|
        pub = Publication.find_publication(rec["publication_id"]).first
        pubs << Bibliography.pretty_bib(pub)
      end
    else
      return nil
    end
    return pubs
  end

  def self.find_pubs_by_sample_id(id)
    unless id.empty?
      bib = Bibliography.where("sample_id = ?", id)
      unless bib[0].nil?
        pubs = []
        bib.to_a.each do |rec|
          pub = Publication.find_publication(rec["publication_id"]).first
          pubs << Bibliography.pretty_bib(pub)
        end
      else
        return nil
      end
    else
      return nil
    end
    return pubs
  end


  def self.find_pubs_by_site_id(id)
    unless id.empty?
      bib = Bibliography.where("site_id = ?", id)
      pubs = []
      bib.to_a.each do |rec|
        pub = Publication.find_publication(rec["publication_id"]).first
        pubs << Bibliography.pretty_bib(pub)
      end
    else
      return nil
    end
    return pubs
  end


  def self.pretty_bib(bib)
    bib_str = ""
    bib.attributes.each do |k, v|
      unless k == "created_at" || k == "updated_at" || k == "id" || v == "" || v == nil || k == "oa_id"
        bib_str << v + ". "
      end
    end
    return bib_str
  end

end