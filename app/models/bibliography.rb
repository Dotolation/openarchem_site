class Bibliography < ActiveRecord::Base

  def self.find_pubs_by_source_id(id)
    unless id.empty?
      bib = Bibliography.where("source_id = ?", id).first
      pubs = Publication.find_publication(bib["publication_id"])
    else
      return nil
    end
    return pubs
  end

end