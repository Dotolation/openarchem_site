class Peak < ActiveRecord::Base
  require 'csv'

  def self.get_by_chromatogram_id(id)
    unless id.empty?
      peaks = Peak.where("chromatogram_id = ?", id)
      unless peaks.empty?
        table_data, keys = Peak.create_table(peaks)
        return {"table" => table_data, "keys" => keys}
      else
        nil
      end
    else
      nil
    end
  end

  def self.csv_download(chromatogram_id)
    peaks = Peak.where("chromatogram_id = ?", chromatogram_id)
    unless peaks.empty?
      table_data, keys = Peak.create_table(peaks)
      CSV.generate do |csv|
        csv << keys
        table_data.each do |row|
          csv << row
        end
      end
    end
  end

  def self.create_table(peaks)
    key_list = ["peak_number", "retention_time", "peak_height", "peak_area", "peak_area_div_height", "relative_abundance", "absolute_abundance"]
    pretty_keys = []
    key_list.each{|i| pretty_keys << i.capitalize.gsub(/_/, " ")}
    table_data = []
    peaks.each do |peak|
      row = []
      key_list.each{|col| row << peak[col]}
      table_data << row
    end
    return table_data, pretty_keys
  end

end


