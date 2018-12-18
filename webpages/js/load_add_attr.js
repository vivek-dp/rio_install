$(document).ready(function(){
	window.location = 'skp:loaddatas@' + 1;

});

function readOly(){
	toastr.info('This field is disabled!', 'Info')
}

$ids = []
function passValToJs(val){
	var showfin = 0;
	for(var i = 0; i < val.length; i++){
		spval = val[i].split("|")
		$ids.push(spval[0])
		if (!spval[1] == true){
			if (spval[0] == "attr_right_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_rightlam').style.display = "block";
				showfin = 1;
			}else if (spval[0] == "attr_left_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_leftlam').style.display = "block";
				showfin = 1;
			}else if (spval[0] == "attr_top_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_toplam').style.display = "block";
				showfin = 1;
			}
		}else{
			if (spval[0] == "attr_right_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_rightlam').style.display = "block";
				showfin = 1;
			}else if (spval[0] == "attr_left_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_leftlam').style.display = "block";
				showfin = 1;
			}else if (spval[0] == "attr_top_lamination"){
				document.getElementById(spval[0]).value = spval[1];
				document.getElementById('show_toplam').style.display = "block";
				showfin = 1;
			}else{
				document.getElementById(spval[0]).value = spval[1];
			}
		}
	}

	if (showfin == 1){
		$('#finish_head').css("display", "block");
	}
}

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

function uptvalue(){
	ids = $ids
	json = {}
	for (var l = 0; l < ids.length; l++){
		var vals = document.getElementById(ids[l]).value;
		var res1 = ids[l].replace(/attr_/g, "");
		var res = res1.replace(/_/g, " ");
		var mname = res.capitalize();
		if (ids[l] == "attr_soft_close" || ids[l] == "attr_finish_type"){
			if (vals == 0){
				toastr.error(mname+" can't be blank!", "Error")
				return false;
			}else{
				json[ids[l]] = vals;
			}
		}else{
			if (vals == ""){
				var fval = '';
				if (mname.includes("Left") == true){
					fval = 'Right'
				}else if (mname.includes("Right") == true){
					fval = 'Left'
				}else{
					fval = mname
				}
				toastr.error(fval+" can't be blank!", "Error")
				document.getElementById(ids[l]).focus();
				return false;
			}else{
				json[ids[l]] = vals;
			}
		}
	}
	var str = JSON.stringify(json);
	document.getElementById("load").style.display = "block";
	setTimeout(function() {window.location = 'skp:upd_attribute@'+ str;}, 1000);
	// window.location = 'skp:upd_attribute@'+ str;
}

function passUpdateToJs(inp){
	document.getElementById("load").style.display = "none";
	toastr.success("Attributes are updated successfully!", "Success")
	// setTimeout(function() {dlgClose()}, 5000);
}