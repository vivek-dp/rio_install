$(document).ready(function(){
	$('#show_custcomp').css("display", "block");
	window.location = 'skp:getspace@' + 1;

	// $(document).on("click", ".comp1", function () { 
 //    $(this).addClass("orange");
 //    $('#clkcustcomp').removeClass("orange");
 //    $('#show_listcomp').css("display", "block");
 //    $('#show_custcomp').css("display", "none");
 //    window.location = 'skp:loadmaincatagory@' + 1;
	// });

	// $(document).on("click", ".comp2", function () {
 //    $(this).addClass("orange");
 //    $('#clkaddcomp').removeClass("orange");
 //    $('#show_listcomp').css("display", "none");
 //    $('#show_custcomp').css("display", "block");
 //    // window.location = 'skp:getspace@' + 1;
 //  });
});


// ------------------- Add Customize Components - Start

function passSpace(val){
	document.getElementById('load_space').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Main Category:</div>'+val+'</div></div></div>';
}

function changeSpaceCategory(){
	document.getElementById('load_subcat').innerHTML = "";
	document.getElementById('newupdate').innerHTML = "";
	var val = document.getElementById('main-space').value;
	if (val != 0) {
		window.location = 'skp:get_cat@' + val;
	}else{
		// document.getElementById('load_subcat').innerHTML = "";
		// document.getElementById('newupdate').innerHTML = "";
		// document.getElementById('load_sketchup').innerHTML = "";
	}
}

function passsubCat(input){
	document.getElementById('load_subcat').innerHTML = "";
	document.getElementById('load_carcass').innerHTML = "";
	document.getElementById('load_subcat').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Sub Category:</div>'+input+'</div></div></div>';
}

function changesubSpace(){
	document.getElementById('newupdate').innerHTML = "";
	$('#expcomp').addClass("disabled")
	var maival = document.getElementById('main-space').value;
	var subval = document.getElementById('sub-space').value;
	if (subval != 0){
		var value = maival +","+ subval
		window.location = 'skp:load-code@' + value;
	}
}

function passCarCass(inp){
	document.getElementById('load_carcass').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Carcass Code:</div>'+inp+'</div></div></div>';
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

function passDataVal(val){
	var nhash = {};
	for (var i = 0; i < val[2].length; i++){
		var splitval = val[2][i].split("|")
		// alert(splitval[0]+" - "+splitval[1])
		nhash[splitval[0]] = splitval[1]
	}
	$origin = nhash['shut_org']

	if (val[0].length != undefined){
		var int_cat = "";
		var load_intcat = "";
		for (var j = 0; j < val[0].length; j++){
			int_cat += '<option value="'+val[0][j]+'">'+val[0][j]+'</option>'
		}
		var int_cat1 = '<select class="ui dropdown" id="int_category"><option value="0">Select...</option>'+int_cat+'</select>'
		var load_intcat = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Internal Type:&nbsp;&nbsp;<i class="question circle outline icon info-icon" onclick="show_int_cat()"></i></div>'+int_cat1+'</div></div></div>';
	}else{
		var load_intcat = ''
	}

	// alert(nhash['shutter_code'].includes("/"))
	var res = val[1].replace(/skp/g, "jpg");
	var load_shut = "";
	var load_mat = "";
	if (nhash['type'] != ""){
		var load_door = '<div>Door Type:&emsp;<input type="hidden" id="door_type" value="'+nhash['type']+'"><span style="color: white !important;">'+nhash['type']+'</span></div>'
	}

	$sv = "";
	var shutter_val = "";
	if (nhash['shutter_code'].includes("/") == false && nhash['shutter_code'] != "No"){
		var load_stcode = '<div>Shutter Code:&emsp;<span style="color: white !important;">'+nhash['shutter_code']+'</span></div>'
		$sv = nhash['shutter_code']
		shutter_val = '';
	}else{
		shutter_val = nhash['shutter_code']
	}

	var showmat = 0
	var scount = 0
	if (nhash['solid'] == "Yes" & nhash['glass'] == "Yes"){
		showmat = 1
		load_shut += '<div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="shuttype" value="solid" id="chksolid" onclick="sho_mat(0)"><label>Solid</label></div></div></div><div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="shuttype" value="glass" id="chkglass" onclick="sho_mat(1)"><label>Glass</label></div></div></div>'
		scount = 2
	}else if (nhash['solid'] == "Yes" & nhash['glass'] == "No"){
		load_shut += '<div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="shuttype" value="solid" id="chksolid" checked><label>Solid</label></div></div></div>'
		scount = 1
	}else if (nhash['solid'] == "No" & nhash['glass'] == "Yes"){
		load_shut += '<div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="shuttype" value="glass" id="chkglass" checked><label>Glass</label></div></div></div>'
		scount = 1
	}

	var mcount = 0
	if (nhash['glass'] == "Yes"){
		if (nhash['alu'] == "Yes" & nhash['ply'] == "Yes"){
			load_mat += '<div class="column"><input type="hidden" value="'+shutter_val+'" id="shutter_val"><div class="field"><div class="ui radio checkbox"><input type="radio" name="mattype" value="aluminium" id="alu" onclick="show_shut(1)"><label>Aluminium</label></div></div></div><div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="mattype" value="plywood" id="alu" onclick="show_shut(2)"><label>Plywood</label></div></div></div>'
			mcount = 2
		}else if (nhash['alu'] == "Yes" & nhash['ply'] == "No"){
			load_mat += '<div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="mattype" value="aluminium" id="alu" checked><label>Aluminium</label></div></div></div>'
			mcount = 1
		}else if (nhash['alu'] == "No" & nhash['ply'] == "Yes"){
			load_mat += '<div class="column"><div class="field"><div class="ui radio checkbox"><input type="radio" name="mattype" value="plywood" id="alu" checked><label>Plywood</label></div></div></div>'
			mcount = 1
		}
		// load_mat += '<div class="field"><div class="ui radio checkbox"><input type="radio" name="mattype" value="aluminium" id="alu"><label>Aluminium</label></div></div>'
	}
	
	if (load_shut != ""){
		if (scount == 2){var sheader = 'Select Shutter Type'}else if (scount == 1){var sheader = 'Shutter Type'}
		var load_shut1 = '<h5 class="ui dividing header">'+sheader+'</h5><div class="ui two column grid">'+load_shut+'</div>'
	}else{var load_shut1 = ''}
	
	if (load_mat != ""){
		if (mcount == 2){var mheader = 'Select Material Type'}else if (mcount == 1){var mheader = 'Material Type'}
		if (showmat == 1){
			var load_mat1 = '<div id="show_material" style="display:none;margin-top:10px;"><h5 class="ui dividing header">'+mheader+'</h5><div class="ui two column grid">'+load_mat+'</div></div>'
		}else{
			var load_mat1 = '<h5 class="ui dividing header">'+mheader+'</h5><div class="ui two column grid">'+load_mat+'</div>'
		}
	}else{var load_mat1 = ''}

	if (load_stcode == undefined){
		load_stcode = ''
	}
	

	var newo = load_intcat+'<div class="ui grid" style="margin-top: .5em;"><div class="eight wide column"><img src="'+res+'" height="200" width="220" "></div><div class="eight wide column"><input type="hidden" value="" id="shut_value"><div id="show_shutcode"></div>'+load_stcode+load_door+load_shut1+load_mat1+'</div></div>'
	document.getElementById('newupdate').innerHTML = newo;
	$('#expcomp').removeClass("disabled")
}

function show_int_cat(){
	var getc = $('#carcass-code').val();
	getc = getc.split("_")
	window.location = 'skp:show_int_html@'+ getc[1];
}

function show_shut(inp){
	var val = document.getElementById('shutter_val').value;
	var splitval = val.split("/")
	var scode = "";
	if (inp == 1){
		if (splitval[0].includes("AF") == true){
			scode = splitval[0]
		}else{scode = ''}
	}else if (inp == 2){
		if (splitval[1].includes("PF") == true){
			scode = splitval[1]
		}else{scode=''}
	}
	document.getElementById('show_shutcode').innerHTML = '<div>Shutter Code:&emsp;<span style="color: white !important;">'+scode+'</span></div>'
	document.getElementById('shut_value').value = scode;
	$sv = scode;
}

function sho_mat(val){
	if (val == 1){
		document.getElementById('show_material').style.display = "block";
	}else{
		document.getElementById('show_material').style.display = "none";
	}
}

$(document).ready(function(){
  var json = {};
  $('#expcomp').on('click', function(){
  	$('#shut_value').val($sv);

  	var sutcot = $('[name="shuttype"]').length;
  	var sutlen = $('[name="shuttype"]:checked').length;
  	
  	if (sutcot != 0 && sutlen == 0){
			toastr.error("Shutter type can't be blank!", 'Error');
			return false;
  	}

  	var matcot = $('[name="mattype"]').length;
  	var matlen = $('[name="mattype"]:checked').length;
  	if (matcot != 0 && matlen == 0){
  		toastr.error("Material type can't be blank!", 'Error');
  		return false;
  	}

  	if ($('#main-space').val().includes("Sliding") || $('#main-space').val().includes("sliding")){
  		var inter = $('#int_category').val();
  		if (inter == 0){
  			toastr.error("Internal category can't be blank!", 'Error');
  			return false
  		}else{
  			json['internal-category'] = inter;
  		}
  	}
  	
		json['main-category'] = $('#main-space').val();
		json['sub-category'] = $('#sub-space').val();
		json['carcass-code'] = $('#carcass-code').val();
		json['shutter-code'] = $('#shut_value').val();
		json['door-type'] = $('#door_type').val()
		json['shutter-type'] = $('[name="shuttype"]:checked').val();
		json['material-type'] = $('[name="mattype"]:checked').val();
		json['shutter-origin'] = $origin
		
		var str = JSON.stringify(json);
		document.getElementById("load").style.display = "block";
		setTimeout(function() {window.location = 'skp:send_compval@'+ str;}, 200);
  });
});

function sentcompVal(v){
	document.getElementById("load").style.display = "none";
}
// ------------------- Add Customize Components - End


// ------------------- Add Standard Components - Start
// function passMainCategoryToJs(main){
// 	document.getElementById('load_maincategory').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Main Category:</div>'+main+'</div></div></div>';
// }

// function changeMainCategory() {
// 	var val = document.getElementById('main-category').value;
// 	if (val != 0) {
// 		window.location = 'skp:get_category@' + val;
// 	}else{
// 		document.getElementById('load_subcategory').innerHTML = "";
// 		document.getElementById('load_sketchup').innerHTML = "";
// 	}
// }

// function passSubCategoryToJs(cat){
// 	document.getElementById('load_sketchup').innerHTML = "";
// 	document.getElementById('load_subcategory').innerHTML = "";
// 	document.getElementById('load_subcategory').innerHTML = '<div class="ui form"><div class="field"><div class="ui labeled input"><div class="ui label">Sub Category:</div>'+cat+'</div></div></div>';
// }

// function changeSubCategory(){
// 	var maincat = document.getElementById('main-category').value;
// 	var subcat = document.getElementById('sub-category').value;
// 	if (subcat != 0){
// 		var value = maincat +","+ subcat
// 		window.location = 'skp:load-sketchupfile@' + value;
// 	}
// }

// function passSkpToJavascript(value) {
// 	document.getElementById('load_sketchup').innerHTML = "";
// 	var skpimg = "";
// 	if (value.length != 0){
// 		for (var i = 0; i < value.length; i++) {
// 			var split_val = value[i].split("/")
// 			var mname = split_val.slice(-1)
// 			var ename = mname[0].split(".")
// 			var res = value[i].replace(/skp/g, "jpg");
// 			skpimg += '<tr><td><div class="ui equal width grid"><div class="column" style="text-align:center;"><input type="hidden" id="imgicon_'+[i]+'" value="'+value[i]+'"><img src="'+res+'" height="40" width="50" "></div><div class="column" style="text-align:left;"><span style="vertical-align:top;line-height:40px;">'+ename[0]+'</span></div><div class="column" style="text-align:right;margin-top: 5px;"><button class="mini ui google plus vertical animated button" style="vertical-align:top;" onclick="viewimg('+[i]+')"><div class="visible content">VIEW</div><div class="hidden content"><i class="eye icon"></i></div></button></div><div class="column" style="margin-top: 5px;"><button class="mini ui positive animated button" style="vertical-align:top;" onclick="checkImage('+[i]+');"><div class="visible content">ADD</div><div class="hidden content"><i class="plus icon"></i></div></button></div></div></td></tr>'
// 		}
// 	} else {
// 		skpimg = '<tr><td style="text-align:center;"><i class="exclamation triangle icon" style="color:red; font-size:36px;"></i>&emsp;<span style="color:red;"><b>No file found!</b></span></td></tr>'
// 	}	
// 	var img = '<table class="ui inverted right aligned table">'+skpimg+'</table>';
// 	document.getElementById('load_sketchup').innerHTML = img;
// }

// function checkImage(id){
// 	var getid = document.getElementById("imgicon_"+id).value;
// 	window.location = 'skp:place_model@' + getid;
// }

// function viewimg(id){
// 	var imgarr = [];
// 	var getid = document.getElementById("imgicon_"+id).value;
// 	var split_val = getid.split("/")
// 	var mname = split_val.slice(-1)
// 	var ename = mname[0].split(".")
// 	var resp = getid.replace(/skp/g, "jpg");

// 	imgarr.push(ename[0])
// 	imgarr.push(resp)


// 	window.location = 'skp:open_modal@' + imgarr;

// 	// document.getElementById('mhead').innerHTML = ename[0];
// 	// document.getElementById('imgtag').innerHTML = '<img src="'+resp+'">'
// 	// $('.openmodal').modal('show'); 
// }
// ------------------- Add Standard Components - End