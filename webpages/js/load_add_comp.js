$(document).ready(function(){
	window.location = 'skp:getspace@' + 1;

	$('#btn-shut').on('click', function(){
		var newarr = [];
		newarr.push($('#main-space').val())
		newarr.push($('#sub-space').val())
		newarr.push($('#carcass_code').val())
		window.location = 'skp:show_shutter@'+ newarr;
	});

	$('#btn-int').on('click', function(){
		var getc = $('#carcass_code').val();
		getc = getc.split("_")
		window.location = 'skp:show_int_html@'+ getc[1];
	});

	$('#rotatebtn').on('click', function(){
		window.location = 'skp:rotate-comp@'+1;
	})
});

function passSpace(val, type){
	if (val != ""){
		$('#load_space').html('<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Main Category:</div>'+val[1]+'</div></div></div>')
	}
	if (type == 1){changeSpaceCategory()}
}

function changeSpaceCategory(){
	$('#load_subcat').html('');
	$('#load_comp_detail').css("display", "none");
	var val = $('#main-space').val();
	if (val != 0) {
		window.location = 'skp:get_cat@' + val;
	}
}

function passsubCat(input, type){
	document.getElementById('load_subcat').innerHTML = "";
	document.getElementById('load_carcass').innerHTML = "";
	if (input != ""){
		document.getElementById('load_subcat').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Sub Category:</div>'+input+'</div></div></div>';
	}
	if (type == 1){changesubSpace(type)}
}

function changesubSpace(type){
	$('#btn-carcass').css("display", "block");
	$('#load_comp_detail').css("display", "none");
	$('#expcomp').addClass("disabled");
	$('#rotatebtn').addClass("disabled");
	if (type == 1){
		window.location = 'skp:update_car@' + 1;
	}
}

function passCarVal(inp){
	$('#carcass_code').val(inp)
	m = $('#main-space').val();
	s = $('#sub-space').val();
	cname = s+"_"+inp
	$('#car-code').html('<div class="four wide column">Carcass Code</div><div class="twelve wide column"><span style="color: white !important;">'+cname+'</span></div>')
	val = m + "," + s + "," + inp
	window.location = 'skp:load-datas@'+ val;
}

function clkCarcass(){
	main = $('#main-space').val();
	sub = $('#sub-space').val();
	val = main + "," + sub
	window.location = 'skp:select-carcass@' + val;
}

function passDataVal(val, type){
	var nhash = {};
	for (var i = 0; i < val[1].length; i++){
		var splitval = val[1][i].split("|")
		nhash[splitval[0]] = splitval[1]
	}
	$origin = nhash['shut_org']
	
	if (val[0].length != undefined){
		$('#btn-int').css("display", "block");
	}else{
		$('#internal-cat').html('');
		$('#btn-int').css("display", "none");
	}
	
	if (nhash['type'] != ""){
		load_door = '<div class="four wide column">Door Type</div><div class="twelve wide column"><input type="hidden" id="door_type" value="'+nhash['type']+'"><span style="color: white !important;">'+nhash['type']+'</span></div>'
	}
	$('#door-type').html(load_door)

	if (nhash['shutter_code'].includes("/") == true){
		$('#shut_code').val('');
		load_shutcode = ''
		$('#btn-shut').css("display", "block");
	}else{
		if (type == 1 && (nhash['shutter_code'].includes("AF") == true || nhash['shutter_code'].includes("PF") == true)){
		$('#btn-shut').css("display", "block");	
		}else{$('#btn-shut').css("display", "none");}		
		if (nhash['shutter_code'] != 'No'){
			$('#shut_code').val(nhash['shutter_code']);
			load_shutcode = '<div class="four wide column">Shutter Code</div><div class="twelve wide column"><span style="color: white !important;">'+nhash['shutter_code']+'</span></div>'
		}else{
			$('#shut_code').val(nhash['shutter_code']);
			load_shutcode = ''
		}
	}
	$('#shutter-code').html(load_shutcode)

	if (nhash['solid'] == "Yes" & nhash['glass'] == "No"){
		shut_type = '<div class="four wide column">Shutter Type</div><input type="hidden" value="solid" id="shttype"><div class="twelve wide column"><span style="color:white !important;">Solid</span></div>'
	}else if (nhash['solid'] == "No" & nhash['glass'] == "Yes"){
		shut_type = '<div class="four wide column">Shutter Type</div><input type="hidden" value="glass" id="shttype"><div class="twelve wide column"><span style="color:white !important;">Glass</span></div>'
	}
	$('#shutter-type').html(shut_type)

	$('#load_comp_detail').css("display", "block");
	$('#expcomp').removeClass("disabled");
	$('#rotatebtn').removeClass("disabled");

	if (type == 1){
		if ($('#main-space').val().includes("Sliding") || $('#main-space').val().includes("sliding")){
			window.location = 'skp:load-internal@'+1;
		}else{
			window.location = 'skp:updateglobal@'+1;
		}
	}
}

function passIntJs(vals, cat, type){
	var valstr = "";
	for (var k = 0; k < vals.length; k++){
		var spval = vals[k].split("|")
		var hname = spval[0].capitalize();
		if (spval[1] != "no"){
			valstr += '<div class="row"><div class="four wide column">'+hname+':</div><div class="twelve wide column" style="color: white;">'+spval[1]+'</div></div>'
		}
	}
	var load_int = '<div class="ui grid">'+valstr+'</div>'
	$('#internal_code').val(cat)
	$('#internal-cat').html('<h5 class="ui dividing header">Internal Catgory</h5>'+load_int)
	$('#showint').css("margin-top", "10px");

	if (type == 2 && $('#page_type').val() == 1){
		$('#uptcomp').removeClass("disabled");
	}else{
		$('#uptcomp').addClass("disabled");
	}
	window.location = 'skp:updateglobal@'+1;
}

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

function passShutJs(v){
	$('#shut_code').val(v[0]);
	$('#shutter-code').html('<div class="four wide column">Shutter Code</div><div class="twelve wide column"><span style="color: white !important;">'+v[0]+'</span></div>')
	if (v[1] == 1 && $('#page_type').val() == 1){
		$('#uptcomp').removeClass("disabled");
	}else{
		$('#uptcomp').addClass("disabled");
	}
}

function createcomp(val){
	var json = {};

	if ($('#shut_code').val() == "" && $('#shut_code').val() != "No"){
		toastr.error('Please select a shutter to create!', 'Error');
	}
	
	if (val == 0){json['edit'] = 0}else if(val == 1){json['edit'] = 1}
	json['space-name'] = $('#space_list').val();
	json['main-category'] = $('#main-space').val();
	json['sub-category'] = $('#sub-space').val();
	json['carcass-code'] = $('#carcass_code').val();
	json['door-type'] = $('#door_type').val();
	if ($('#shut_code').val() != "No"){
		json['shutter-code'] = $('#shut_code').val();
	}
	json['shutter-type'] = $('#shttype').val();
	json['shutter-origin'] = $origin

	if ($('#main-space').val().includes("Sliding") || $('#main-space').val().includes("sliding")){
		var intval = $('#internal_code').val();
		if (intval == ""){
			toastr.error('Please select a Internal category!', 'Error');
			return false
		}else{
			json['internal-category'] = intval;
		}
	}

	var str = JSON.stringify(json);
	$('#load').css("display", "block");
	if (val == 1){$('#uptcomp').addClass("disabled");}
	setTimeout(function() {window.location = 'skp:send_compval@'+ str;}, 500);
}

function sentcompVal(v){
	document.getElementById("load").style.display = "none";
}