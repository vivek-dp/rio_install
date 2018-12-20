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
		if (spval[0].includes("left") == true){
			$('#show_leftlam').css('display', 'block');
		}else if (spval[0].includes("right") == true){
			$('#show_rightlam').css('display', 'block');
		}else if (spval[0].includes("top") == true){
			$('#show_toplam').css('display', 'block');
		}
		$('#'+spval[0]).val(spval[1]);
		if (spval[0] == "attr_finish_type" && (spval[1] != 0 || spval[1] != "")){
			$('#finish_head').css('display', 'block');
		}
	}

	if ($('#attr_product_name').val().includes("Sliding") || $('#attr_product_name').val().includes("sliding")){
		$('#show_int').css('display', 'block');
	}else{
		$('#show_int').css('display', 'none');
	}
}

function changeFinish(val){
	if (val != 0){
		$('#finish_head').css('display', 'block');
	}else{
		$('#finish_head').css('display', 'none');
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
	$('#load').css('display', 'block');
	setTimeout(function() {window.location = 'skp:upd_attribute@'+ str;}, 500);
	// window.location = 'skp:upd_attribute@'+ str;
}

function passUpdateToJs(inp){
	$('#load').css('display', 'none');
	toastr.success("Attributes are updated successfully!", "Success")
	// setTimeout(function() {dlgClose()}, 5000);
}