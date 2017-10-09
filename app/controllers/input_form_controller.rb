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

  def create
    #send params to the model
    #return display of data entered
    
  end

  def mini_compound

  end

end
