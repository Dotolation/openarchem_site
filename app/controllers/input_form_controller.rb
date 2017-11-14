class InputFormController < ApplicationController

	def index

	end

  def samples
    respond_to do |format|
      format.html
      format.json { @compounds = InputForm.search_compounds(params[:term]) }
    end
  end

  def plant_select
    respond_to do |format|
      format.json{ @plants = InputForm.get_plants(params['comp_id'])}
    end
  end

  def ingredient_select
    respond_to do |format|
      format.json{ @ingredients = InputForm.get_ingredients(params['plant_id'])}
    end
  end 

  def site_select
    respond_to do |format|
      format.html
      format.json {@sites = InputForm.search_sites(params[:term])}
    end
  end

  def create   
    #handles multiple forms, splits according to certain params
    if params[:form_type]
      if params[:form_type] == "mini_plant"

      elsif params[:form_type] == "mini_product"
       
        @mini_product = InputForm.mini_product(params)

      elsif params[:form_type] == "mini_compound"
        
      end
    else

      begin
      
      @sample = InputForm.create_sample(params)
      flash[:success] = "Sample successfully saved, see it here: <a href='#{@sample.oa_id}'>#{@sample.oa_id}</a>" 
      redirect_to :action => "samples"
      rescue Exception => e
        flash[:error] = e.message + ", #{$!} #{e.backtrace}"
        puts e.message + ", #{$!} #{e.backtrace}"

        render :samples
      end

    end

    
  end


  


  def mini_compound

  end

end
