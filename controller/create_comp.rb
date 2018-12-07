require "csv"
require "sqlite3"

module Decor_Standards
	@dbname = 'rio_std'
	@db = SQLite3::Database.new(@dbname)
	@table = 'rio_standards'
	@int_table = 'rio_sliding'
	@bucket_name = 'rio-sub-components'

	def self.get_main_space()
		getval = @db.execute("select distinct space from #{@table};")
		mainspace = ""
		getval.each {|val|
			spval = val[0].gsub("_", " ")
			mainspace += '<option value="'+val[0]+'">'+spval+'</option>'
		}
		mainspace1 = '<select class="ui dropdown" id="main-space" onchange="changeSpaceCategory()"><option value="0">Select...</option>'+mainspace+'</select>'
		return mainspace1
	end

	def self.get_sub_space(input)
		getsub = @db.execute("select distinct category from #{@table} where space='#{input}';")
		subspace = ""
		getsub.each{|subc|
			spval = subc[0].gsub("_", " ")
			subspace += '<option value="'+subc[0]+'">'+spval+'</option>' 
		}
		subspace1 = '<select class="ui dropdown" id="sub-space" onchange="changesubSpace()"><option value="0">Select...</option>'+subspace+'</select>'
		return subspace1
	end

	def self.get_pro_code(inp)
		getco = @db.execute("select distinct carcass_code from #{@table} where space='#{inp[0]}' and category='#{inp[1]}';" )
		proco = ""
		getco.each{|cod|
			spval = cod[0].gsub("_", " ")
			proco += '<option value="'+cod[0].gsub(" ", "")+'">'+spval+'</option>' 
		}
		proco1 = '<select class="ui dropdown" id="carcass-code" onchange="changeProCode()"><option value="0">Select...</option>'+proco+'</select>'
		return proco1
	end

	def self.get_comp_image(options)
		 puts options		
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

	def self.place_cust_comp(inp)
		@model = Sketchup::active_model
		file = inp['carcass-code'].gsub("-", "_") + ".skp"
		path = DECORPOT_CUST_ASSETS + "/" + inp['main-category'] + "/" + file
		dict_name = 'carcase_spec'
		k = 'attr_product_name'
		v = inp['sub-category']
		k1 = 'attr_product_code'
		v1 = inp['carcass-code']
		cdef = @model.definitions.load(path)
		cdef.set_attribute(dict_name, k, v)
		cdef.set_attribute(dict_name, k1, v1)
		placecomp = @model.place_component cdef
	end

	def self.place_component options
        return false if options.empty?
        bucket_name     = 'rio-sub-components'

        main_category   = options['main-category']
        #Bad Mapping........:)
        main_category = 'Crockery_Unit' if main_category.start_with?('Crockery') #Temporary mapping ....Move crockery to base unit and top unit later in the AWS server
            
        sub_category    = options['sub-category']   #We will use it for decription
        carcass_code    = options['carcass-code']
        shutter_code    = options['shutter-code']||''
        internal_code   = options['internal-category']||''
        origin          = options['shutter-origin']||''

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
        defn.set_attribute(dict_name, k, v)
				defn.set_attribute(dict_name, k1, v1)

        prev_active_layer = Sketchup.active_model.active_layer.name
        Sketchup.active_model.active_layer='DP_Comp_layer'
        
        placecomp = Sketchup.active_model.place_component defn
        Sketchup.active_model.active_layer=prev_active_layer
        return true
    end

	def self.get_datas(inp)
		puts "inp--#{inp}"
		valhash = []
		getdat = @db.execute("select shutter_code, type, solid, glass, alu, ply, shutter_origin from #{@table} where space='#{inp[0]}' and category='#{inp[1]}' and carcass_code='#{inp[2]}';")
		valhash.push("shutter_code|"+getdat[0][0])
		valhash.push("type|"+getdat[0][1])
		valhash.push("solid|"+getdat[0][2])
		valhash.push("glass|"+getdat[0][3])
		valhash.push("alu|"+getdat[0][4])
		valhash.push("ply|"+getdat[0][5])
		valhash.push("shut_org|"+getdat[0][6])

		puts "val--- #{valhash}"
		return valhash
	end

	def self.get_internal_category(inp)
		if (inp[0].include?("Sliding") == true || inp[0].include?("sliding") == true)
			getcat = inp[2].split("_")
			get_val = @db.execute("select distinct category from #{@int_table} where slide_type=#{getcat[2]};")
		end

		if get_val.nil?
			return {}
		else
			return get_val 
		end
	end
end