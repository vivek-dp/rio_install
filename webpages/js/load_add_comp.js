$(document).ready(function(){
	window.location = 'skp:getspace@' + 1;

	$('#btn-shut').on('click', function(){
		var newarr = [];
		newarr.push($('#main-space').val())
		newarr.push($('#sub-space').val())
		newarr.push($('#carcass-code').val())
		window.location = 'skp:show_shutter@'+ newarr;
	});

	$('#btn-int').on('click', function(){
		var getc = $('#carcass-code').val();
		getc = getc.split("_")
		window.location = 'skp:show_int_html@'+ getc[1];
	});

});

function passSpace(val, type){
	if (val != ""){
		$('#load_space_list').html('<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Space Name:</div>'+val[0]+'</div></div></div>')
		$('#load_space').html('<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Main Category:</div>'+val[1]+'</div></div></div>')
	}
	if (type == 1){changeSpaceCategory()}
}

function changeSpaceCategory(){
	document.getElementById('load_subcat').innerHTML = "";
	document.getElementById('new').style.display = "none";
	var val = document.getElementById('main-space').value;
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
	if (type == 1){changesubSpace()}
}

function changesubSpace(){
	document.getElementById('new').style.display = "none";
	$('#expcomp').addClass("disabled")
	var maival = document.getElementById('main-space').value;
	var subval = document.getElementById('sub-space').value;
	if (subval != 0){
		var value = maival +","+ subval
		window.location = 'skp:load-code@' + value;
	}
}

function passCarCass(inp, type){
	if (inp != ""){
		document.getElementById('load_carcass').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Carcass Code:</div>'+inp+'</div></div></div>';
	}
	if (type == 1){changeProCode()}
}

function changeProCode(){
	var main = document.getElementById('main-space').value;
	var cat = document.getElementById('sub-space').value;
	var pro = document.getElementById('carcass-code').value;

	if (pro != 0){
		var input = main +","+ cat +","+ pro
		window.location = 'skp:load-datas@'+ input;
	}
}

function passDataVal(val, type){
	var nhash = {};
	for (var i = 0; i < val[2].length; i++){
		var splitval = val[2][i].split("|")
		nhash[splitval[0]] = splitval[1]
	}
	$origin = nhash['shut_org']
	
	if (val[0].length != undefined){
		$('#btn-int').css("display", "block");
	}else{
		$('#internal-cat').html('');
		$('#btn-int').css("display", "none");
	}
	
	var load_shut = "";
	var load_mat = "";
	if (nhash['type'] != ""){
		load_door = '<div class="column">Door Type</div><div class="column"><input type="hidden" id="door_type" value="'+nhash['type']+'"><span style="color: white !important;">'+nhash['type']+'</span></div>'
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
			load_shutcode = '<div class="column">Shutter Code</div><div class="column"><span style="color: white !important;">'+nhash['shutter_code']+'</span></div>'
		}else{
			$('#shut_code').val(nhash['shutter_code']);
			load_shutcode = ''
		}
	}
	$('#shutter-code').html(load_shutcode)

	if (nhash['solid'] == "Yes" & nhash['glass'] == "No"){
		shut_type = '<div class="column">Shutter Type</div><input type="hidden" value="solid" id="shttype"><div class="column"><span style="color:white !important;">Solid</span></div>'
	}else if (nhash['solid'] == "No" & nhash['glass'] == "Yes"){
		shut_type = '<div class="column">Shutter Type</div><input type="hidden" value="glass" id="shttype"><div class="column"><span style="color:white !important;">Glass</span></div>'
	}
	$('#shutter-type').html(shut_type)

	$('#new').css("display", "block")
	var res = val[1].replace(/skp/g, "jpg");
	$('#carcass-img').html('<span style="color:#FF2000;">Carcass Image:</span><img src="'+res+'" height="200" width="220" style="margin-top:2px;">');
	$('#expcomp').removeClass("disabled")
	
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
			valstr += '<div class="row"><div class="column" style="width:30% !important;">'+hname+':</div><div class="column" style="color: white;width:70% !important;">'+spval[1]+'</div></div>'
		}
	}
	var load_int = '<div class="ui stackable two column grid">'+valstr+'</div>'
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
	$('#shutter-code').html('<div class="column">Shutter Code</div><div class="column"><span style="color: white !important;">'+v[0]+'</span></div>')
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
		return false
	}
	
	if (val == 0){json['edit'] = 0}else if(val == 1){json['edit'] = 1}
	json['space-name'] = $('#space_list').val();
	json['main-category'] = $('#main-space').val();
	json['sub-category'] = $('#sub-space').val();
	json['carcass-code'] = $('#carcass-code').val();
	json['door-type'] = $('#door_type').val();
	json['shutter-code'] = $('#shut_code').val();
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
	setTimeout(function() {window.location = 'skp:send_compval@'+ str;}, 500);
}

function sentcompVal(v){
	document.getElementById("load").style.display = "none";
}