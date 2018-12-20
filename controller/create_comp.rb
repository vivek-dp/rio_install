require "csv"
require "sqlite3"

module Decor_Standards
	@dbname = 'rio_std'
	@db = SQLite3::Database.new(@dbname)
	@table = 'rio_standards'
	@int_table = 'rio_slidings'
	@bucket_name = 'rio-sub-components'

	def self.get_main_space(input)
		getval = @db.execute("select distinct space from #{@table};")
		mainspace = ""
		getval.each {|val|
			spval = val[0].gsub("_", " ")
			if val[0] == input
				mainspace += '<option value="'+val[0]+'" selected="selected">'+spval+'</option>'
			else
				mainspace += '<option value="'+val[0]+'">'+spval+'</option>'
			end
		}
		mainspace1 = '<select class="ui dropdown" id="main-space" onchange="changeSpaceCategory()"><option value="0">Select...</option>'+mainspace+'</select>'
		return mainspace1
	end

	def self.get_sub_space(input, type)
		if type == 1
			getsub = @db.execute("select distinct category from #{@table} where space='#{input[0]}';")
		else
			getsub = @db.execute("select distinct category from #{@table} where space='#{input}';")
		end
		subspace = ""
		getsub.each{|subc|
			spval = subc[0].gsub("_", " ")
			if type.to_i == 1
				if subc[0] == input[1]
					subspace += '<option value="'+subc[0]+'" selected="selected">'+spval+'</option>' 
				else
					subspace += '<option value="'+subc[0]+'">'+spval+'</option>' 
				end
			else
				subspace += '<option value="'+subc[0]+'">'+spval+'</option>' 
			end
		}
		subspace1 = '<select class="ui dropdown" id="sub-space" onchange="changesubSpace()"><option value="0">Select...</option>'+subspace+'</select>'
		return subspace1
	end

	def self.get_pro_code(inp, type)
		getco = @db.execute("select distinct carcass_code from #{@table} where space='#{inp[0]}' and category='#{inp[1]}';" )
		proco = ""
		getco.each{|cod|
			spval = cod[0].gsub("_", " ")
			if type == 1
				if inp[2] == cod[0]
					proco += '<option value="'+cod[0]+'" selected="selected">'+spval+'</option>' 
				else
					proco += '<option value="'+cod[0]+'">'+spval+'</option>' 
				end
			else
				proco += '<option value="'+cod[0]+'">'+spval+'</option>' 
			end
		}
		proco1 = '<select class="ui dropdown" id="carcass-code" onchange="changeProCode()"><option value="0">Select...</option>'+proco+'</select>'
		return proco1
	end

	def self.get_comp_image(options)
		main_category = options[0]
		main_category = 'Crockery_Unit' if main_category.start_with?('Crockery')
		sub_category = options[1] #options['sub-category'] #We will use it for decription
		carcass_code = options[2]
		
		#------------------------------------------------------------------------------------------------
		carcass_jpg = carcass_code+'.jpg'
		aws_carcass_path = File.join('carcass',main_category,carcass_jpg)
		local_carcass_path = File.join(RIO_ROOT_PATH,'cache',carcass_jpg)

		RioAwsDownload::download_file @bucket_name, aws_carcass_path, local_carcass_path
		#skppath = DECORPOT_CUST_ASSETS + "/" + input[0] + "/" + imgname + ".jpg"
		# puts skppath
		#return skppath
		return local_carcass_path
	end

	def self.get_carcass_image(input)
		getimg = @db.execute("select distinct carcass_code, category from #{@table} where space='#{input[0]}' and category='#{input[1]}';" )
		cararr = []
		for i in getimg
			carcass_image = i[0] + '.jpg'
			aws_carcass_path = File.join('carcass',input[0],carcass_image)
			local_carcass_path = File.join(RIO_ROOT_PATH,'cache',carcass_image)
			RioAwsDownload::download_file @bucket_name, aws_carcass_path, local_carcass_path
			cararr.push(i[0]+"|"+i[1]+"|"+local_carcass_path)
		end
		return cararr
	end

	def self.get_shutter_image(input)
		getimg = @db.execute("select shutter_code from #{@table} where space='#{input[0]}' and category='#{input[1]}' and carcass_code='#{input[2]}';")
		inp = getimg[0][0].split("/")
		shutarr = []
		for i in inp
			shutter_image = i + '.jpg'
			aws_shutter_path = File.join('shutter',shutter_image)
			local_shut_path = File.join(RIO_ROOT_PATH,'cache', shutter_image)
			RioAwsDownload::download_file @bucket_name, aws_shutter_path, local_shut_path
			shutarr.push(local_shut_path)
		end
		return shutarr
	end

	def self.get_internal_data(val1, val2)
		val2 = val2.split("_")
		json = []
		getint = @db.execute("select left, center, right from #{@int_table} where door_type="+val2[1]+" and slide_width="+val2[2]+" and category="+val1+";")
		json.push("left|"+getint[0][0])
		json.push("center|"+getint[0][1])
		json.push("right|"+getint[0][2])
		return json
	end

	def self.get_intnal(catgry, carcode)
		json = []
		detail = @db.execute("select left, center, right from #{@int_table} where door_type="+carcode[1]+" and slide_width="+carcode[2]+" and category="+catgry+";")
		json.push("left|"+detail[0][0])
		json.push("center|"+detail[0][1])
		json.push("right|"+detail[0][2])
		return json
	end

	def self.place_component options
		comp_origin = nil
		return false if options.empty?
		bucket_name     = 'rio-sub-components'

		if options['edit'] == 1
			sel = Sketchup.active_model.selection[0]
			comp_origin = sel.transformation.origin
			comp_trans = sel.transformation
			Sketchup.active_model.entities.erase_entities sel
		end

		main_category = options['main-category']
		main_category = 'Crockery_Unit' if main_category.start_with?('Crockery') #Temporary mapping ....Move crockery to base unit and top unit later in the AWS server
		sub_category = options['sub-category']   #We will use it for decription
		carcass_code = options['carcass-code']
		shutter_code = options['shutter-code']||''
		internal_code = options['internal-category']||''
		origin = options['shutter-origin']||''

		#------------------------------------------------------------------------------------------------
		carcass_skp         = carcass_code+'.skp'
		aws_carcass_path    = File.join('carcass',main_category,carcass_skp)
		local_carcass_path  = File.join(RIO_ROOT_PATH,'cache',carcass_skp)

		if File.exists?(local_carcass_path)
		  puts "File already present "
		else
	    puts "Downloading file"
	    resp = RioAwsDownload::download_file bucket_name, aws_carcass_path, local_carcass_path
	    if resp.nil?
	        puts "Carcass file download error  : "+aws_carcass_path
	        return false
	    end
		end
		#------------------------------------------------------------------------------------------------
		if shutter_code.empty?
		  local_shutter_path = ''
		else
	    puts "Downloading shutter"
	    shutter_skp         = shutter_code+'.skp'
	    aws_shutter_path    = File.join('shutter',shutter_skp)
	    local_shutter_path  = File.join(RIO_ROOT_PATH,'cache',shutter_skp)
	    puts shutter_skp, aws_shutter_path
	    unless File.exists?(local_shutter_path)
	      RioAwsDownload::download_file bucket_name, aws_shutter_path, local_shutter_path
	    end
		end
		dict_name = 'carcase_spec'
		k = 'attr_product_name'
		v = sub_category
		k1 = 'attr_product_code'
		v1 = carcass_code

		defn = DP::create_carcass_definition local_carcass_path, local_shutter_path, origin, internal_code
		defn.set_attribute(:rio_atts, 'rio_comp', 'true')
		defn.set_attribute(dict_name, k, v)
		defn.set_attribute(dict_name, k1, v1)

		options.each{|k, v|
			defn.set_attribute(:rio_atts, k, v)
		}

		prev_active_layer = Sketchup.active_model.active_layer.name
		Sketchup.active_model.active_layer = 'DP_Comp_layer'

		if options['edit'] == 1
			Sketchup.active_model.entities.add_instance defn, comp_trans
		else
			placecomp = Sketchup.active_model.place_component defn
		end
		
		Sketchup.active_model.active_layer = prev_active_layer

		return true
  end

	def self.get_datas(inp, type)
		valhash = []
		getdat = @db.execute("select shutter_code, type, solid, glass, alu, ply, shutter_origin from #{@table} where space='#{inp[0]}' and category='#{inp[1]}' and carcass_code='#{inp[2]}';")
		if type == 1
			if !$shutter_code.nil?
				valhash.push("shutter_code|"+$shutter_code)
			else
				valhash.push("shutter_code|"+"No")
			end
		else
			valhash.push("shutter_code|"+getdat[0][0])
		end
		valhash.push("type|"+getdat[0][1])
		valhash.push("solid|"+getdat[0][2])
		valhash.push("glass|"+getdat[0][3])
		valhash.push("alu|"+getdat[0][4])
		valhash.push("ply|"+getdat[0][5])
		valhash.push("shut_org|"+getdat[0][6])

		return valhash
	end

	def self.get_internal_category(inp)
		if (inp[0].include?("Sliding") == true || inp[0].include?("sliding") == true)
			getcat = inp[2].split("_")
			get_val = @db.execute("select distinct category from #{@int_table} where door_type=#{getcat[1]} and slide_width=#{getcat[2]};")
		end

		if get_val.nil?
			return {}
		else
			return get_val 
		end
	end
end