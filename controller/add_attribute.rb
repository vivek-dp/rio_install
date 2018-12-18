module Decor_Standards
	def self.get_attr_value()
		@model = Sketchup.active_model
		@selection = @model.selection[0]

		@get_vsides = DP::get_visible_sides @selection

		@show = 0
		if @selection.nil?
			UI.messagebox 'Component not selected!', MB_OK
			@show = 1
		elsif Sketchup.active_model.selection[1] != nil then
			UI.messagebox 'More than one component selected!', MB_OK
			@show = 1
		end
		
		if @show == 0
			@dict_name = 'carcase_spec'
			rawmat = @selection.get_attribute(@dict_name, 'attr_raw_material')
			rawmat = "" if rawmat.nil?

			if @get_vsides[0] == false && @get_vsides[1] == false && @get_vsides[2] == false
				lamcode = @selection.get_attribute(@dict_name, 'attr_lamination_color_code')
				lamcode = "" if lamcode.nil?
				single_laminate = 1
			else
				if @get_vsides[0] == true
					lam_left = @selection.get_attribute(@dict_name, 'attr_left_lamination')
					lam_left = "" if lam_left.nil?
					left_laminate = 1
				end

				if @get_vsides[1] == true
					lam_right = @selection.get_attribute(@dict_name, 'attr_right_lamination')
					lam_right = "" if lam_right.nil?
					right_laminate = 1
				end

				if @get_vsides[2] == true
					lam_top = @selection.get_attribute(@dict_name, 'attr_top_lamination')
					lam_top = "" if lam_top.nil?
					top_laminate = 1
				end
			end

			hand = @selection.get_attribute(@dict_name, 'attr_handles_type')
			hand = "" if hand.nil?

			softcl = @selection.get_attribute(@dict_name, 'attr_soft_close')
			softcl = "" if softcl.nil?

			fintyp = @selection.get_attribute(@dict_name, 'attr_finish_type')
			fintyp = "" if fintyp.nil?

			shutfin = @selection.get_attribute(@dict_name, 'attr_shutter_finish')
			shutfin = "" if shutfin.nil?

			intfin = @selection.get_attribute(@dict_name, 'attr_internal_finish')
			intfin = "" if intfin.nil?

			# defcode = @selection.definition.name
			defcode = @selection.definition.get_attribute(@dict_name, 'attr_product_code')

			defname = @selection.definition.get_attribute(@dict_name, 'attr_product_name')
			if !defname.nil?
				defname = defname.gsub("_", " ")
			else
				defname = ""
			end
			
			mainarr = []
			mainarr.push("attr_raw_material|"+rawmat)
		  mainarr.push("attr_handles_type|"+hand)
		  mainarr.push("attr_soft_close|"+softcl)
		  mainarr.push("attr_finish_type|"+fintyp)
			mainarr.push("attr_product_code|"+defcode)
			mainarr.push("attr_product_name|"+defname)
			mainarr.push("attr_shutter_finish|"+shutfin)
			mainarr.push("attr_internal_finish|"+intfin)

			if single_laminate == 1
		  	mainarr.push("attr_lamination_color_code|"+lamcode)
		  end
		  if left_laminate == 1
		  	mainarr.push("attr_left_lamination|"+lam_left)
		  end

		  if right_laminate == 1
		  	mainarr.push("attr_right_lamination|"+lam_right)
		  end

		  if top_laminate == 1
		  	mainarr.push("attr_top_lamination|"+lam_top)
		  end
		  
			return mainarr
		end
	end

	def self.update_attr(b)
		inph =	JSON.parse(b)
		inph.each{|k, v|
			@selection.set_attribute(@dict_name, k, v)
		}
		return 1
	end

	def self.uptdetail()
		newarr = []
		cliname = Sketchup.active_model.get_attribute(:rio_global, 'client_name')
		cliname = "" if cliname.nil?
		proname = Sketchup.active_model.get_attribute(:rio_global, 'project_name')
		proname = "" if proname.nil?
		cliid = Sketchup.active_model.get_attribute(:rio_global, 'client_id')
		cliid = "" if cliid.nil?
		aptname = Sketchup.active_model.get_attribute(:rio_global, 'apartment_name')
		aptname = "" if aptname.nil?
		desname = Sketchup.active_model.get_attribute(:rio_global, 'designer_name')
		desname = "" if desname.nil?
		flatno = Sketchup.active_model.get_attribute(:rio_global, 'flat_number')
		flatno = "" if flatno.nil?
		prono = Sketchup.active_model.get_attribute(:rio_global, 'project_number')
		prono = "" if prono.nil?
		visname = Sketchup.active_model.get_attribute(:rio_global, 'visualizer_name')
		visname = "" if visname.nil?

		newarr.push("client_name|"+cliname)
		newarr.push("project_name|"+proname)
		newarr.push("client_id|"+cliid)
		newarr.push("apartment_name|"+aptname)
		newarr.push("designer_name|"+desname)
		newarr.push("flat_number|"+flatno)
		newarr.push("project_number|"+prono)
		newarr.push("visualizer_name|"+visname)

		return newarr
	end


	def self.add_carcase_spec
		model = Sketchup.active_model
		selection = model.selection[0]
		if selection == nil
			UI.messagebox 'Component not selected!', MB_OK
			return
		elsif Sketchup.active_model.selection[1] != nil then
			UI.messagebox 'More than one component selected!', MB_OK
			return
		end
		$dict_name = 'carcase_spec'

		rawmat = selection.get_attribute('carcase_spec', 'raw_material')
		lamcode = selection.get_attribute('carcase_spec', 'lamination_color_code')
		hand = selection.get_attribute('carcase_spec', 'handler_type')
		softcl = selection.get_attribute('carcase_spec', 'soft_close')
		fintyp = selection.get_attribute('carcase_spec', 'finish_type')

		defcode = selection.definition.name
		spname = selection.definition.get_attribute($dict_name, 'attr_product_name')
		 if !spname.nil?
		 	defname = spname.gsub("_", " ")
		 else
		 	defname = ""
		 end
	end

	def self.update_attribute(comp, input)
		input.each{|k, v|
			comp.set_attribute($dict_name, k, v)
		}
	end

	def self.generate_html
		mainarr = []
		Sketchup.active_model.entities.each{|comp|
			if comp.attribute_dictionaries[$dict_name] != nil
				ahash = {}
				comp.attribute_dictionaries[$dict_name].each{|key, val|
					if !val.empty?
						ahash[key] = val
					end
				}
			end
			if !ahash.nil?
				mainarr.push(ahash)
			end
		}
		self.generate_html_str(mainarr)
	end

	def self.comp_html
		@model = Sketchup.active_model
		@selection = @model.selection[0]
		@show = 0
		if @selection.nil?
			UI.messagebox 'Component not selected!', MB_OK
			@show = 1
		elsif Sketchup.active_model.selection[1] != nil then
			UI.messagebox 'More than one component selected!', MB_OK
			@show = 1
		end

		if @show == 0
			dialog = UI::WebDialog.new("SketchUp HTML", true, "SketchUp HTML", 700, 600, 150, 150, true)
			html_path = File.join(WEBDIALOG_PATH, 'SketchHTML.html')
			dialog.set_file(html_path)
			dialog.show

			dialog.add_action_callback("closedlg"){|a, b|
				dialog.close
			}

			dialog.add_action_callback("load_datas"){|a, b|
				@dict_name = 'carcase_spec'

				rawmat = @selection.get_attribute(@dict_name, 'raw_material')
				rawmat = "" if rawmat.nil?

				lamcode = @selection.get_attribute(@dict_name, 'lamination_color_code')
				lamcode = "" if lamcode.nil?

				hand = @selection.get_attribute(@dict_name, 'handles_type')
				hand = "" if hand.nil?

				softcl = @selection.get_attribute(@dict_name, 'soft_close')
				softcl = "" if softcl.nil?

				fintyp = @selection.get_attribute(@dict_name, 'finish_type')
				fintyp = "" if fintyp.nil?

				defcode = @selection.definition.name
				defname = @selection.definition.get_attribute(@dict_name, 'product_name')
				if !defname.nil?
					defname = defname.gsub("_", " ")
				else
					defname = ""
				end
				
				mainarr = []
				mainarr.push("raw_material|"+rawmat)
			  mainarr.push("lamination_color_code|"+lamcode)
			  mainarr.push("handles_type|"+hand)
			  mainarr.push("soft_close|"+softcl)
			  mainarr.push("finish_type|"+fintyp)
				mainarr.push("product_code|"+defcode)
				mainarr.push("product_name|"+defname)

				js_maincat = "passValToJs("+mainarr.to_s+")"
			 	a.execute_script(js_maincat)
			}

			dialog.add_action_callback("get_json"){|a, b|
				inph =	JSON.parse(b)
				inph.each{|k, v|
					@selection.set_attribute(@dict_name, k, v)
				}
				js_maincat = "passUpdateToJs(1)"
			 	a.execute_script(js_maincat)
			}


		end
		# dialog = UI::WebDialog.new("SketchUp HTML", true, "SketchUp HTML", 700, 600, 150, 150, true)
		# html_path = File.join(WEBDIALOG_PATH, 'SketchHTML.html')
		# dialog.set_file(html_path)
		# dialog.show

		# dialog.add_action_callback("closedlg"){|a, b|
		# 	dialog.close
		# }

		# dialog.add_action_callback("getValue"){|a, b|
		# 	model = Sketchup.active_model
		# 	selection = model.selection[0]
		# 	show = 0
		# 	if selection == nil
		# 		UI.messagebox 'Component not selected!', MB_OK
		# 		show = 1
		# 	elsif Sketchup.active_model.selection[1] != nil then
		# 		UI.messagebox 'More than one component selected!', MB_OK
		# 		show = 1
		# 	end
		# 	if show == 0

		# 	end
		# 	$dict_name = 'carcase_spec'
		# }

		# dialog.add_action_callback("loadpage"){|a, b|
		# 	mainarr = []
		# 	ahash = {}
		# 	Sketchup.active_model.entities.each{|comp|
		# 		if comp.attribute_dictionaries[$dict_name] != nil
		# 			comp.attribute_dictionaries[$dict_name].each{|key, val|
		# 				if !val.empty?
		# 					# mainarr.push(key+'|'+val)
		# 					ahash[key] = val
		# 				end
		# 			}
		# 		end
		# 		puts ahash
		# 	}
		# 	js_maincat = "passCompToJs("+mainarr.to_s+")"
		# 	a.execute_script(js_maincat)
		# }
	end

	def self.generate_html_str(input)
		@input = input
		puts @input
		html_str = '
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
			<style type="text/css">
				.procode {font-weight:bold;}
				.vname {padding: 5px 17px 5px 10px; font-weight: bold;text-align: center; text-decoration: underline;}
				body {font-size: 12px;}
				.table-bordered > thead > tr > th{
				  border:1px solid black !important;
				}
				.table-bordered > tbody > tr > td{
				  border:1px solid black !important;
				}
				.pagebreak { page-break-before: always; }
				.btm-border {border-bottom: 1px solid #ccc; padding: 10px 5px 10px 5px;}
				.clinote {color: red !important; padding: 10px 0px 10px 0px; font-weight: bold;}
			</style>
		</head>
		<body>
			<div class="container-fluid">
				<section style="border-style: double;">
					<div style="padding: 5px;">
						<table class="table table-bordered">
							<thead>
								<tr>
									<td width="10%" style="padding: 0px;">
										<div class="col-lg-12">
											<div class="vname">Elevation&nbsp;A</div>
										</div>
										<div class="col-lg-12 btm-border">
											<label>Client Name:</label>
											<div class="cliname">Siva S</div>
										</div>
										<div class="col-lg-12 btm-border">
											<label>Client ID:</label>
											<div class="cliname">BUI-26541</div>
										</div>
										<div class="col-lg-12 btm-border">
											<label>Room Name:</label>
											<div class="cliname">Kitchen</div>
										</div>
										<div class="col-lg-12 btm-border">
											<label>Date:</label>
											<div class="cliname">Nov 13, 2018</div>
										</div>
										<div class="col-lg-12">
											<div class="clinote">NOTE:</div>
										</div>
									</td>
									<td width="80%">
										<!-- <div><img src="C:/Users/Admin/Desktop/imgexport/Front.jpg" height="300"></div> -->
										<div class="pull-right"><img src="C:/Users/Admin/Desktop/imgexport/demo.png"></div>
									</td>
								</tr>
							</thead>
						</table>
						<div class="row">
							<div class="col-lg-12">
								<table class="table table-bordered">
									<thead>
										<th>Product Code</th>
										<th>Product Name</th>
										<th>Raw Material</th>
										<th>Laminate Color/Code</th>
										<th>Handles</th>
										<th>Soft Close</th>
										<th>Finish Type</th>
									</thead>
									<tbody>'
									@input.each{|inp|
	html_str += '<tr>
											<td><div class="procode">'+inp["product_code"]+'</div></td>
											<td><div class="procode">'+inp["product_name"]+'</div></td>
											<td>'+inp["raw_material"]+'</td>
											<td>'+inp["lamination_color/code"]+'</td>
											<td>'+inp["handler_type"]+'</td>
											<td>'+inp["soft_close"]+'</td>
											<td>'+inp["finish_type"]+'</td>
										</tr>'
									}
		html_str += '</tbody>
								</table>
							</div>
						</div>
					</div>
				</section>
			</div>
		</body>
		</html>'
		File.write('C:/Users/Admin/Desktop/sample_html.html', html_str)
		UI.messagebox 'HTML Generated Successfully!', MB_OK
	end
end


# output_h = []
# comps = Sketchup.active_model.entities.grep(Sketchup::ComponentInstance)

# comps.each{|comp|

# 	dicts = comp.attribute_dictionaries
	
# 	attr_dict = dicts['carcase_spec']
# 	next if attr_dict.nil?

# 	attr_h = {}
# 	attr_dict.keys.each{|key|
# 		attr_h[key] = comp.get_attribute('carcase_spec', key)
# 	} 
	
# 	comp_h = {'product_name'=>comp.definition.name,
# 										'id'=>comp.persistent_id,
# 										'attr_h'=>attr_h
# 										}
# 	output_h << comp_h

# }


# def self.generate_html_str(input)
# 	@input = input
# end