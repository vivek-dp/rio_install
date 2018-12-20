module Decor_Standards
	def self.export_index(input)
		if input['draw'].length != 0
			self.show_work_drawing(input['draw'])
		end

		if input['views'].length != 0
			@views = self.export_html(input['views'])
		end
		# puts "@views---------#{@views}"
		return @views
	end

	def self.show_work_drawing(input)
		# puts "draw------------",input
	end

	def self.add_option(input, type)
		values = ["test", "test1", "test2", "test3", "test4"]
		arrval = []
		if values.count != 0
			mainspace = ""
			values.each {|val|
				if type == 1
					if val == input
						mainspace += '<option value="'+val+'" selected="selected">'+val+'</option>'
					else
						mainspace += '<option value="'+val+'">'+val+'</option>'
					end
				else
					mainspace += '<option value="'+val+'">'+val+'</option>'
				end
			}
			mainspace1 = '<select class="ui dropdown" id="space_list" onchange="changeSpaceList(this.value)"><option value="0">Select...</option>'+mainspace+'</select>'
			arrval.push(mainspace1)
		end
		return arrval
	end

	def self.get_space_detail(input)
		json = {}
		json['door'] = false
		json['window'] = true

		return json
	end

	def self.generate_html
		dict_name = 'carcase_spec'
		mainarr = []
		Sketchup.active_model.entities.each{|comp|
			if comp.attribute_dictionaries[dict_name] != nil
				ahash = {}
				comp.attribute_dictionaries[dict_name].each{|key, val|
					if !val.empty?
						ahash[key] = val
					end
				}
			end
			if !ahash.nil?
				mainarr.push(ahash)
			end
		}
		# self.generate_html_str(mainarr)
		return mainarr
	end

	def self.get_attributes(vi)
		dict_name = 'carcase_spec'
		call_image = WorkingDrawing::get_working_image(vi)
		newh = call_image
		return {} if newh.empty?
		mainarr = []
		mainh = {}
		newh[0].keys.each{|x| 
			shash = {}
			# puts "newh[0][x].attribute_dictionaries : #{newh[0][x].attribute_dictionaries}"
			if !newh[0][x].attribute_dictionaries.nil?
				if !newh[0][x].attribute_dictionaries[dict_name].nil?
					newh[0][x].attribute_dictionaries[dict_name].each{|key, val|
						shash[key] = val
					}
					shash["id"] = x
					mainarr.push(shash)
				end
			else
				shash["attr_product_name"] = newh[0][x].definition.get_attribute(dict_name, 'attr_product_name')
				shash["attr_product_code"] = newh[0][x].definition.get_attribute(dict_name, 'attr_product_code')
				shash["id"] = x
				mainarr.push(shash)
			end
		}
		mainh["attributes"] = mainarr
		mainh["image"] = newh[1]

		return mainh
	end

	def self.get_homeimg(inp)
		# call_image = WorkingDrawing::get_working_image(inp)
		call_image = 'D:/Decorpot_Extension/workspace/cache/'+inp+'.jpg'
		return call_image
	end

	def self.export_html(input)
		clientname = Sketchup.active_model.get_attribute(:rio_global, 'client_name')
		clientid = Sketchup.active_model.get_attribute(:rio_global, 'client_id')
		elevation_image = File.join(WEBDIALOG_PATH,"../images/elevation.png")
		clientid = clientid.empty? ? 'N/A' : clientid
		@views = input
		@topviews = ["top", "top_section1", "top_section2", "top_section3"]

		html = '<!DOCTYPE html>
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
									.table-bordered > thead > tr > th {border:1px solid black !important;}
									.table-bordered > tbody > tr > td {border:1px solid black !important;}
									.pagebreak { page-break-before: always; }
									.btm-border {border-bottom: 1px solid black; padding: 10px 5px 10px 5px;}
									.clinote {color: red !important; padding: 10px 0px 10px 0px; font-weight: bold;}
									.page-break {page-break-before:always !important;}
									.chead {color:#d60000 !important;}
									.imgB1 { position:absolute; top: 42%; left: 53%; z-index: 3; } 
								</style>
							</head>

							<body>
								<div class="container-fluid">'
									@topviews.each{|tv|
										if tv == "top"
											pname = "floor plan"
										else
											pname = tv.gsub("_", " ")
										end
										@topimg = self.get_homeimg(tv)
		html +=	'<section style="border-style: double;">
										<div style="padding: 5px;">
											<table class="table table-bordered">
												<tbody>
													<tr>
														<td width="20%"  style="padding: 0px;">
															<div class="col-lg-12 btm-border">
																<div class="cliname"><b>Client Name: </b>'+clientname+'</div>
															</div>
															<div class="col-lg-12 btm-border">
																<div class="cliname"><b>Client ID: </b>'+clientid+'</div>
															</div>
															<div class="col-lg-12 btm-border">
																<div class="cliname"><b>Room Name:</b> Kitchen</div>
															</div>
															<div class="col-lg-12 btm-border">
																<div class="cliname"><b>Date: </b>'+Time.now.strftime('%b %Y, %d')+'</div>
															</div>
															<div class="col-lg-12">
																<div class="clinote">Color Codes:</div>
																<div>Dimension:<br><span style="color:red !important; vertical-align:super;">______</span></div>
																<div>Layout Dimension:<br><span style="color:#1D8C2C !important; vertical-align:super;">______</span></div>
																<div>Component ID:<br><span style="color:#7A003D !important; vertical-align:super;">______</span></div>
															</div>
														</td>
														<td width="80%" style="padding: 1px;"><div style="text-align:center;"><h3>'+pname.capitalize+'</h3></div><div class="pull-right"><img src="'+@topimg+'" width="820" height="620"><img class="imgB1" src="'+elevation_image+'" width="120" height="120"></div></td>
													</tr>
												</tbody>
											</table>
										</div>
									</section>'
									}						
		html +='</div>
								<div class="page-break"></div>
								<div class="container-fluid">'
									@views.each{|vi|
										elevate = {"left"=>"A", "back"=>"B", "right"=>"C", "front"=>"D", "top"=>"top"}
										@skps = self.get_attributes(vi)
										next if @skps.empty?
										# puts "@skp : #{@skps}"
		html += '<section style="border-style: double;">
									<div style="padding: 5px;">
										<table class="table table-bordered">
											<tbody>
												<tr>
													<td width="20%" style="padding: 0px;">
														<div class="col-lg-12">
															<div class="vname">Elevation&nbsp;'+elevate[vi].capitalize+'</div>
														</div>
														<div class="col-lg-12 btm-border">
															<div class="cliname"><b>Client Name: </b>'+clientname+'</div>
														</div>
														<div class="col-lg-12 btm-border">
															<div class="cliname"><b>Client ID: </b>'+clientid+'</div>
														</div>
														<div class="col-lg-12 btm-border">
															<div class="cliname"><b>Room Name:</b> Kitchen</div>
														</div>
														<div class="col-lg-12 btm-border">
															<div class="cliname"><b>Date: </b>'+Time.now.strftime('%b %Y, %d')+'</div>
														</div>
														<div class="col-lg-12">
															<div class="clinote">Color Codes:</div>
															<div>Dimension:<br><span style="color:red !important; vertical-align:super;">______</span></div>
															<div>Layout Dimension:<br><span style="color:#1D8C2C !important; vertical-align:super;">______</span></div>
															<div>Component ID:<br><span style="color:#7A003D !important; vertical-align:super;">______</span></div>
														</div>
													</td>
													<td width="80%">
														<div class="pull-right"><img src="'+@skps['image']+'"></div>
													</td>
												</tr>
											</ttbody>
										</table>
										<div class="row">
											<div class="col-lg-12">
												<table class="table table-bordered">
													<thead>
														<tr>
															<th class="chead">ID</th>
															<th class="chead">Product Code</th>
															<th class="chead">Product Name</th>
															<th class="chead">Raw Material</th>
															<th class="chead">Top Laminate</th>
															<th class="chead">Right Laminate</th>
															<th class="chead">Left Laminate</th>
															<th class="chead">Handles</th>
															<th class="chead">Soft Close</th>
															<th class="chead">Finish Type</th>
														</tr>
													</thead>
													<tbody>'
													@skps['attributes'].each{|skp|
														pro_code = skp["attr_product_code"].nil? ? 'N/A' : skp["attr_product_code"]
														pro_name = skp["attr_product_name"].nil? ? 'N/A' : skp["attr_product_name"]
														raw_mat = skp["attr_raw_material"].nil? ? 'N/A' : skp["attr_raw_material"]
														top_lamn_code = skp["attr_top_lamination"].nil? ? 'N/A' : skp["attr_top_lamination"]
														left_lamn_code = skp["attr_left_lamination"].nil? ? 'N/A' : skp["attr_left_lamination"]
														right_lamn_code = skp["attr_right_lamination"].nil? ? 'N/A' : skp["attr_right_lamination"]
														hand_type = skp["attr_handles_type"].nil? ? 'N/A' : skp["attr_handles_type"]
														soft_close = skp["attr_soft_close"].nil? ? 'N/A' : skp["attr_soft_close"]
														finish_type = skp["attr_finish_type"].nil? ? 'N/A' : skp["attr_finish_type"]

		html +=						'<tr>
															<td><div class="procode">'+skp["id"]+'</div></td>
															<td><div class="procode">'+pro_code+'</div></td>
															<td><div class="procode">'+pro_name+'</div></td>
															<td>'+raw_mat+'</td>
															<td>'+top_lamn_code+'</td>
															<td>'+left_lamn_code+'</td>
															<td>'+right_lamn_code+'</td>
															<td>'+hand_type+'</td>
															<td>'+soft_close+'</td>
															<td>'+finish_type+'</td>
														</tr>'
													}
		html +=					'</tbody>
												</table>
											</div>
										</div>
									</div>
								</section>
								<div class="page-break"></div>'
								}
		html+=	'</div>
							</body>
							</html>'
		if Sketchup.active_model.title != ""
			@title = Sketchup.active_model.title
		else
			@title = "Untitled"
		end
		@datetitle = Time.now.strftime('%d-%m_%H-%M')
		@outpath = RIO_ROOT_PATH+"/reports/WorkingDrawing/#{@title}_#{@datetitle}.html"
		File.write(@outpath, html)

		# system(system('start %s' % (@outpath)))
		return @outpath
	end
end