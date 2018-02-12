# -*- encoding : utf-8 -*-
class DownloadController < ApplicationController  

  def index
    
  end


  def peaks
    c_id = params[:c_id]
    @peaks = Peak.csv_download(c_id)
    respond_to do |format|
      format.csv { send_data @peaks, filename: "#{c_id}_peaks.csv" }
    end
  end
end