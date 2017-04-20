module CatalogShowHelper

	#control logic for displaying db keys and vales in show partials
	def render_show(arr)
		show_data = arr[1]
		link_fields = arr[2]
		show_data.each do |key, val|
			unless val == nil || key == "image_credit"
				unless link_fields.include?(key)
					dt = key == "oa_id" ? "OA Id:" : "#{key.gsub("_", " ").capitalize}:"
					dd = val	

				else

				end
			end
		end
	end

	def sample_show_data(id)
		Sample.show_sample_data(id)
	end

	#control logic for inner_list
	def data_for_inner_list(key, val, data_arr)
		# data_arr => 0 sam_hash, 1 link_fields, 2 site_data, 3 source_data, 4 equipment_data, 5 extraction_data, 6 chromatogram_data]
		name = "#{key.gsub('_id', '').capitalize}"
  	case key
  	when /site/
  		locals = {:name => name, :oa_id => val, :data => data_arr[2], :num => "1"}
  	when /source/ 
  		locals = {:name => name, :oa_id => val, :data => data_arr[3], :num => "2"}
  	# when /equipment/ %>
  		# locals = {:name => name, :oa_id => val, :data => data_arr[4], :num => "3"}
  	when /extraction/
  		locals = {:name => name, :oa_id => val, :data => data_arr[5], :num => "4"}
  	else
   		locals = {:name => name, :oa_id => val, :data => data_arr[6], :num => "5"}		
  	end
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
		link_to(url, url, :target => "_blank")
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

