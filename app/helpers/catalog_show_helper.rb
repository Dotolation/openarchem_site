module CatalogShowHelper

#control logic for displaying db keys and vales in show partials

#helper methods for getting mysql data for views, probably a better way to do this...
	def sample_show_data(id)
		Sample.show_sample_data(id)
	end

	def source_show_data(id)
		Source.show_source_data(id)
	end

	def site_show_data(id)
		Site.show_site_data(id)
	end

	def equipment_show_data(id)
		Equipment.show_equipment_data(id)
	end

	def extraction_show_data(id)
		Extraction.show_extraction_data(id)
	end

	def chromatogram_show_data(id)
		Chromatogram.show_chromatogram_data(id)
	end

	def person_show_data(id)
		Person.show_person_data(id)
	end

	def plant_show_data(id)
		Plant.show_plant_data(id)
	end

	def compound_show_data(id)
		Compound.show_compound_data(id)
	end


  #value formatting
  def render_value(val, image_credit=nil)
  	if image_credit || val =~ /data/
  		show_image(val, image_credit)
  	elsif val =~ /http/
  			url_to_link(val)
  	else
  		val
  	end
  end

  #render urls as links
	def url_to_link(url)
		only_url = url.match(/http.+$/)[0]
		link_to(url, only_url, :target => "_blank")
	end

	#display images with image_credit alt text
	def show_image(path, credit)
		if credit
			matches = credit.match(/http.+$/)
			if matches && matches[0]
				url = matches[0]
				link_to(image_tag(path, :alt => credit), url, :target =>"_blank")
			else
				image_tag(path, :alt => credit)
			end
		else
			image_tag(path)
		end
	end

end

