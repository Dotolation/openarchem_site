class Publication < ActiveRecord::Base
  def self.find_publication(id)
    unless id.empty?
      pub = Publication.where("oa_id = ?", id)
    else
      return nil
    end
    return pub
  end

end