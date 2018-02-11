class Peak < ActiveRecord::Base

  def self.get_by_chromatogram_id(id)
    unless id.empty?
      peaks = Peak.where("chromatogram_id = ?", id)
      unless peaks.empty?
        key_list = ["peak_number", "retention_time", "peak_height", "peak_area", "peak_area_div_height", "relative_abundance", "absolute_abundance"]
        pretty_keys = []
        key_list.each{|i| pretty_keys << i.capitalize.gsub(/_/, " ")}
        table_data = [pretty_keys]
        peaks.each do |peak|
          row = []
          key_list.each{|col| row << peak[col]}
          table_data << row
        end
        return table_data
      else
        nil
      end
    else
      nil
    end
  end
end
