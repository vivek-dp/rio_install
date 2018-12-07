require 'json'

module Decor_Standards
	UI.add_context_menu_handler do |menu|
	  rbm = menu.add_submenu("Rio Tools")
    rbm.add_item("Add Component") { self.add_comp_fom_menu }
    rbm.add_item("Add Attribute") { self.add_attr_from_menu }
	end

	def self.add_comp_fom_menu
		$rio_dialog.show
		js_cpage = "document.getElementById('add_comp').click();"
		$rio_dialog.execute_script(js_cpage)
	end

	def self.add_attr_from_menu
		$rio_dialog.show
		js_page = "document.getElementById('add_attr').click();"
		$rio_dialog.execute_script(js_page)
	end

	def self.set_window(inp_page, key, value)
		# js_upt = "passUptVal("+inp_page+','+key+','+value+")"
		 js_cpage = "document.getElementById('#{inp_page}').click();"
		# js_upt = "passUptVal(1)"
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

			jscpage = "changePager()"
			$rio_dialog.execute_script(jscpage)
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
			# system(system('start %s' % (passval)))
			# system(system('start %s' % (RIO_ROOT_PATH+"/Report/WorkingDrawing")))
		}

		$rio_dialog.add_action_callback("openfile"){|a, b|
			puts b
			#system('start %s' % (b))
		}

		$rio_dialog.add_action_callback("open_modal"){|a, b|
			inpval = b.split(",")
			webdialog = UI::WebDialog.new("#{inpval[0]}", true, "#{inpval[0]}", 600, 600, 10, 100, true)
			webdialog.set_url(inpval[1])
			webdialog.show
		}

		$rio_dialog.add_action_callback("getspace"){|a, b|
			mainsp = []
			maincat = self.get_main_space()
			mainsp.push(maincat)
			js_sp = "passSpace("+mainsp.to_s+")"
			$rio_dialog.execute_script(js_sp)
		}

		$rio_dialog.add_action_callback("get_cat"){|a, b|
			subcat = []
			subsp = self.get_sub_space(b)
			subcat.push(subsp)
			js_sub = "passsubCat("+subcat.to_s+")"
			$rio_dialog.execute_script(js_sub)
		}

		$rio_dialog.add_action_callback("load-code"){|a, b|
			sp = b.split(",")
			parr = []
			getcode = self.get_pro_code(sp)
			parr.push(getcode)
			js_pro = "passCarCass("+parr.to_s+")"
			$rio_dialog.execute_script(js_pro)
		}

		$rio_dialog.add_action_callback("load-datas"){|a, b|
			puts "b : #{b}"
			#spinp = JSON.parse(b)
			spinp = b.split(',')
			newarr = []
			get_int = self.get_internal_category(spinp)
			newarr.push(get_int)
			getskp = self.get_comp_image(spinp)
			newarr.push(getskp)
			getval = self.get_datas(spinp)
			newarr.push(getval)
			js_data = "passDataVal("+newarr.to_s+")"
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
				@w = 500
				@h = 500
			elsif b.to_i == 3
				@html = "3_intcategory.html"
				@title = "3 Door Sliding Internal Categories"
				@w = 800
				@h = 500
			end
			int_dialog = UI::HtmlDialog.new({:dialog_title=>@title, :preferences_key=>"com.sample.plugin", :scrollable=>true, :resizable=>true, :width=>@w, :height=>@h, :style=>UI::HtmlDialog::STYLE_DIALOG})
			html_path = File.join(NEW_PAGE, @html)
			int_dialog.set_file(html_path)
			int_dialog.set_position(0, 150)
			int_dialog.show
		}

		# $rio_dialog.add_action_callback("upt_client"){|a, b|
		# 	cli_name = Sketchup.active_model.get_attribute(:rio_global, 'client_name')
		# 	cli_id = Sketchup.active_model.get_attribute(:rio_global, 'client_id')

		# 	js_cname = "document.getElementById('client_name').value='#{cli_name}'"
		# 	$rio_dialog.execute_script(js_cname)
		# 	sleep 0.1
		# 	js_cid = "document.getElementById('client_id').value='#{cli_id}'"
		#  	$rio_dialog.execute_script(js_cid)
		# }
	end
end

