require 'json'

module Decor_Standards
	UI.add_context_menu_handler do |menu|
		model = Sketchup.active_model
		selection = model.selection[0]
		rio_comp = selection.definition.get_attribute(:rio_atts, 'rio_comp')

		if rio_comp == 'true'
		  rbm = menu.add_submenu("Rio Tools")
	    rbm.add_item("Add Component") { self.add_comp_from_menu }
	    rbm.add_item("Add Attribute") { self.add_attr_from_menu }
	    rbm.add_item("Edit/View Component") { self.edit_view_component }
	  end
	end

	def self.add_comp_from_menu
		$rio_dialog.show
		js_cpage = "document.getElementById('add_comp').click();"
		$rio_dialog.execute_script(js_cpage)
	end

	def self.add_attr_from_menu
		$rio_dialog.show
		js_page = "document.getElementById('add_attr').click();"
		$rio_dialog.execute_script(js_page)
	end

	def self.edit_view_component
		$edit_val = 1
		$rio_dialog.show
		js_page = "document.getElementById('add_comp').click();"
		$rio_dialog.execute_script(js_page)
		sleep 0.1
		jspage = "document.getElementById('page_type').value=1;"
		$rio_dialog.execute_script(jspage)

		model = Sketchup.active_model
		selection = model.selection[0]

		$main_category = selection.definition.get_attribute(:rio_atts, 'main-category')
		$sub_category = selection.definition.get_attribute(:rio_atts, 'sub-category')
		$carcass_code = selection.definition.get_attribute(:rio_atts, 'carcass-code')
		$shutter_code = selection.definition.get_attribute(:rio_atts, 'shutter-code')
		$door_type = selection.definition.get_attribute(:rio_atts, 'door-type')
		$shutter_type = selection.definition.get_attribute(:rio_atts, 'shutter-type')
		$internal_category = selection.definition.get_attribute(:rio_atts, 'internal-category')
		$space_name = selection.definition.get_attribute(:rio_atts, 'space-name')
	end

	def self.set_window(inp_page, key, value)
	 	js_cpage = "document.getElementById('#{inp_page}').click();"
		$rio_dialog.execute_script(js_cpage)
		sleep 0.1
		js_1page = "document.getElementById('#{key}').value='#{value}';"
		$rio_dialog.execute_script(js_1page)
	end

	def self.decor_index(*args)
		$rio_dialog = UI::HtmlDialog.new({:dialog_title=>"RioSTD", :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>600, :height=>700, :style=>UI::HtmlDialog::STYLE_DIALOG})
		html_path = File.join(WEBDIALOG_PATH, 'index.html')
		$rio_dialog.set_file(html_path)
		$rio_dialog.set_position(0, 80)
		$rio_dialog.show

		$rio_dialog.add_action_callback("get_detail"){|a, b|
			cliname = Sketchup.active_model.get_attribute(:rio_global, 'client_name')
			proname = Sketchup.active_model.get_attribute(:rio_global, 'project_name')

			jscli = "document.getElementById('cliname').innerHTML='#{cliname}'"
			$rio_dialog.execute_script(jscli)
			sleep 0.1
			jspro = "document.getElementById('proname').innerHTML='#{proname}'"
			$rio_dialog.execute_script(jspro)
		}

		$rio_dialog.add_action_callback("uptdetail"){|a, b|
			uptdval = self.uptdetail()
			jsupt = "uptAttrValue("+uptdval.to_s+")"
			$rio_dialog.execute_script(jsupt)
		}

		$rio_dialog.add_action_callback("pro_details"){|a, b|
			params = JSON.parse(b)
			Sketchup.active_model.set_attribute(:rio_global, 'client_name', params['client_name'])
			Sketchup.active_model.set_attribute(:rio_global, 'project_name', params['project_name'])
			Sketchup.active_model.set_attribute(:rio_global, 'client_id', params['client_id'])
			Sketchup.active_model.set_attribute(:rio_global, 'apartment_name', params['apartment_name'])
			Sketchup.active_model.set_attribute(:rio_global, 'flat_number', params['flat_number'])
			Sketchup.active_model.set_attribute(:rio_global, 'project_number', params['project_number'])
			Sketchup.active_model.set_attribute(:rio_global, 'designer_name', params['designer_name'])
			Sketchup.active_model.set_attribute(:rio_global, 'visualizer_name', params['visualizer_name'])

			cliname = Sketchup.active_model.get_attribute(:rio_global, 'client_name')
			proname = Sketchup.active_model.get_attribute(:rio_global, 'project_name')

			jscli = "document.getElementById('cliname').innerHTML='#{cliname}'"
			$rio_dialog.execute_script(jscli)
			sleep 0.1
			jspro = "document.getElementById('proname').innerHTML='#{proname}'"
			$rio_dialog.execute_script(jspro)

			jscpage = "changePager()"
			$rio_dialog.execute_script(jscpage)
		}

		$rio_dialog.add_action_callback("getspacelist"){|a, b|
			getlist = self.add_option(0, 0)
			jsadd = "passSpaceList("+getlist.to_s+")"
		 	$rio_dialog.execute_script(jsadd)
		}

		$rio_dialog.add_action_callback("get-spdetail"){|a, b|
			spdetail = self.get_space_detail(b)
			if spdetail['door'] == true
				jsdoor = "document.getElementById('show_doorheight').style.display='block';"
				$rio_dialog.execute_script(jsdoor)
			end
			if spdetail['window'] == true
				jswino = "document.getElementById('show_winoff').style.display='block';"
				$rio_dialog.execute_script(jswino)
				sleep 0.1
				jswinh = "document.getElementById('show_winheight').style.display='block';"
				$rio_dialog.execute_script(jswinh)
			end
		}

		$rio_dialog.add_action_callback("submitval"){|i, j|
			# creat_wall = self.creating_wall(j)
			param = JSON.parse(j)
			creat_wall = DP::create_wall param
			js_done = "page_comp()"
			$rio_dialog.execute_script(js_done)
		}

		$rio_dialog.add_action_callback("loadmaincatagory"){|a, b|
			mainarr = []
			value = self.load_main_category()
			mainarr.push(value)
			js_maincat = "passMainCategoryToJs("+mainarr.to_s+")"
			$rio_dialog.execute_script(js_maincat)
		}

		$rio_dialog.add_action_callback("get_category"){|a, b|
			subarr = []
			subval = self.load_sub_category(b.to_s)
			subarr.push(subval)
			js_subcat = "passSubCategoryToJs("+subarr.to_s+")"
			$rio_dialog.execute_script(js_subcat)
		}

		$rio_dialog.add_action_callback("load-sketchupfile"){|a, b|
			cat = b.split(",")
			skpval = self.load_skp_file(cat)
			js_command = "passSkpToJavascript("+ skpval.to_s + ")"
			$rio_dialog.execute_script(js_command)
		}

		$rio_dialog.add_action_callback("place_model"){|a, b|
			self.place_Defcomponent(b)
		}

		$rio_dialog.add_action_callback("loaddatas"){|a, b|
			@model = Sketchup.active_model
			@selection = @model.selection[0]
			if @selection.nil?
				UI.messagebox 'Component not selected!', MB_OK
			elsif Sketchup.active_model.selection[1] != nil then
				UI.messagebox 'More than one component selected!', MB_OK
			else
				getval = self.get_attr_value()
				puts "get---#{getval}"
				js_maincat = "passValToJs("+getval.to_s+")"
				$rio_dialog.execute_script(js_maincat)
			end
		}

		$rio_dialog.add_action_callback("upd_attribute"){|a, b|
			uptval = self.update_attr(b)
			if uptval.to_i == 1
				js_maincat = "passUpdateToJs(1)"
	 			$rio_dialog.execute_script(js_maincat)
	 		else
	 		end
		}

		$rio_dialog.add_action_callback("exporthtml"){|a, b|
			newarr = []
			inp_h =	JSON.parse(b)
			passval = self.export_index(inp_h)
			newarr.push(passval)
			js_exped = "htmlDone("+newarr.to_s+")"
			$rio_dialog.execute_script(js_exped)
		}

		$rio_dialog.add_action_callback("upt_client"){|a, b|
			newarr = []
			@views = ["left", "back", "right", "front"]
			@views.each {|view|
				comps 	= DP::get_visible_comps view
				if !comps.empty? == true
					newarr.push(view)
				end
			}
			js_view = "passViews("+newarr.to_s+")"
			$rio_dialog.execute_script(js_view)
		}

		$rio_dialog.add_action_callback("open_modal"){|a, b|
			inpval = b.split(",")
			webdialog = UI::WebDialog.new("#{inpval[0]}", true, "#{inpval[0]}", 600, 600, 10, 100, true)
			webdialog.set_url(inpval[1])
			webdialog.show
		}

		$rio_dialog.add_action_callback("getspace"){|a, b|
			if $edit_val == 1
				params = $main_category
				type = 1
			else
				params = 0
				type = 0
			end
			mainsp = []
			splist = self.add_option($space_name, type)
			mainsp.push(splist)
			maincat = self.get_main_space(params);
			mainsp.push(maincat)
			js_sp = "passSpace("+mainsp.to_s+", "+type.to_s+")"
			$rio_dialog.execute_script(js_sp)
		}

		$rio_dialog.add_action_callback("get_cat"){|a, b|
			subcat = []

			if $edit_val == 1
				params = []
				params.push($main_category)
				params.push($sub_category)
				type = 1
			else
				params = b
				type = 0
			end
			subsp = self.get_sub_space(params, type)
			subcat.push(subsp)
			js_sub = "passsubCat("+subcat.to_s+", "+type.to_s+")"
			$rio_dialog.execute_script(js_sub)
		}

		$rio_dialog.add_action_callback("select-carcass"){|a, b|
			@spval = b.split(",")
			@title = "Choose Carcass"
			cardialog = UI::HtmlDialog.new({:dialog_title=>@title, :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :style=>UI::HtmlDialog::STYLE_DIALOG})
			html_path = File.join(WEBDIALOG_PATH, 'load_carcass.html')
			cardialog.set_file(html_path)
			cardialog.set_position(0, 150)
			cardialog.show

			cardialog.add_action_callback("load_carimg"){|d, v|
				getcar = self.get_carcass_image(@spval)
				jscar = "passCarImage("+getcar.to_s+")"
				cardialog.execute_script(jscar)
			}

			cardialog.add_action_callback("load_detail"){|d, v|
				valarr = []
				cardialog.close
				valarr.push(v)
				jspas = "passCarVal("+valarr.to_s+")"
				$rio_dialog.execute_script(jspas)
			}
		}

		$rio_dialog.add_action_callback("update_car"){|a, b|
			valarr = []
			valarr.push($carcass_code)
			jsval = "passCarVal("+valarr.to_s+")"
			$rio_dialog.execute_script(jsval)
		}

		$rio_dialog.add_action_callback("load-code"){|a, b|
			sp = b.split(",")
			parr = []
			if $edit_val == 1
				params = []
				params.push($main_category)
				params.push($sub_category)
				params.push($carcass_code)
				type = 1
			else
				params = sp
				type = 0
			end
			getcode = self.get_pro_code(params, type)
			parr.push(getcode)
			js_pro = "passCarCass("+parr.to_s+", "+type.to_s+")"
			$rio_dialog.execute_script(js_pro)
		}

		$rio_dialog.add_action_callback("load-datas"){|a, b|
			spinp = b.split(',')
			$intval = spinp
			newarr = []

			if $edit_val == 1
				type = 1
			else
				type = 0
			end
			get_int = self.get_internal_category(spinp)
			newarr.push(get_int)
			getval = self.get_datas(spinp, type)
			newarr.push(getval)

			puts "newarr---#{newarr}"
			js_data = "passDataVal("+newarr.to_s+", "+type.to_s+")"
			$rio_dialog.execute_script(js_data)
		}

		$rio_dialog.add_action_callback("send_compval"){|a, b|
			inph =	JSON.parse(b)
			puts inph
			self.place_component(inph)
			js_sent = "sentcompVal(1)"
			$rio_dialog.execute_script(js_sent)
		}

		$rio_dialog.add_action_callback("show_int_html"){|a, b|
			if b.to_i == 2
				@html = "2_intcategory.html"
				@title = "2 Door Sliding Internal Categories"
			elsif b.to_i == 3
				@html = "3_intcategory.html"
				@title = "3 Door Sliding Internal Categories"
			end
			int_dialog = UI::HtmlDialog.new({:dialog_title=>@title, :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>500, :height=>500, :style=>UI::HtmlDialog::STYLE_DIALOG})
			html_path = File.join(WEBDIALOG_PATH, @html)
			int_dialog.set_file(html_path)
			int_dialog.set_position(0, 150)
			int_dialog.show

			int_dialog.add_action_callback("load_cat"){|k, l|
				getint = self.get_internal_category($intval)
				jsint = "passintval("+getint.to_s+")"
				int_dialog.execute_script(jsint)
			}

			int_dialog.add_action_callback("getintcat"){|k, l|
				int_dialog.close
				if $internal_category == l
					type = 0
				else
					type = 2
				end
				getvals = self.get_internal_data(l, $intval[2])
				js_val = "passIntJs("+getvals.to_s+","+l+", "+type.to_s+")"
				$rio_dialog.execute_script(js_val)
			}
		}

		$rio_dialog.add_action_callback("show_shutter"){|a, b|
			@title = "Shutter Type"
			shutdialog = UI::HtmlDialog.new({:dialog_title=>@title, :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>500, :height=>500, :style=>UI::HtmlDialog::STYLE_DIALOG})
			html_path = File.join(WEBDIALOG_PATH, 'select_shutter.html')
			shutdialog.set_file(html_path)
			shutdialog.set_position(0, 150)
			shutdialog.show

			shutdialog.add_action_callback("load_shutimg"){|k, v|
				spval = b.split(",")
				getimg = self.get_shutter_image(spval)
				
				for i in getimg
					spval = i.split("/")
					@sname = spval.last.gsub(".jpg", "")
					@image = "<img src="+i+" width=250 height=200>"
					if spval.last.include?("AF")
						jsalu = "document.getElementById('alname').innerHTML='#{@sname}';"
						shutdialog.execute_script(jsalu)
						sleep 0.1
						jsval = "document.getElementById('alvalue').value='#{@sname}';"
						shutdialog.execute_script(jsval)
						sleep 0.1
						alimg = "document.getElementById('alimage').innerHTML='#{@image}';"
						shutdialog.execute_script(alimg)
					elsif spval.last.include?("PF")
						jsply = "document.getElementById('plname').innerHTML='#{@sname}';"
						shutdialog.execute_script(jsply)
						sleep 0.1
						jsval = "document.getElementById('plvalue').value='#{@sname}';"
						shutdialog.execute_script(jsval)
						sleep 0.1
						plimg = "document.getElementById('plimage').innerHTML='#{@image}';"
						shutdialog.execute_script(plimg)
					end
				end
			}

			shutdialog.add_action_callback("select_shutter"){|k, v|
				shutdialog.close
				arr = []
				arr.push(v)
				if $shutter_code == v
					arr.push(0)
				else
					arr.push(1)
				end
				jsval = "passShutJs("+arr.to_s+")"
				$rio_dialog.execute_script(jsval)
			}
		}

		$rio_dialog.add_action_callback("load-internal"){|a, b|
			cc = $carcass_code
			spval = cc.split("_")
			getd = self.get_intnal($internal_category, spval)
			js_val = "passIntJs("+getd.to_s+","+$internal_category.to_s+", "+1.to_s+")"
			$rio_dialog.execute_script(js_val)
		}

		$rio_dialog.add_action_callback("updateglobal"){|a, b|
			$edit_val = 0
		}

		$rio_dialog.add_action_callback("rotate-comp"){|a, b|
			DP::zrotate
		}

		$rio_dialog.add_action_callback("choose-color"){|a, b|
			CP::call_picker
		}
	end
end

