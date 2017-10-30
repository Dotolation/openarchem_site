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

      end
    else
      byebug

      InputForm.upload(params["source_img"], "source") if params["source_img"] != ""
      InputForm.upload(params["chrom_img"], "chrom") if params["chrom_img"] != ""
      InputForm.upload(params["petro_img"], "petro") if params["source_img"] != ""
      InputForm.create_sample(params)
    end

    
  end


  


  def mini_compound

  end

end
