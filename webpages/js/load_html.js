$(document).ready(function(){
	window.location = 'skp:upt_client@'+1;

	ids = ["show_outline", "show_dimen", "show_laminate", "top_view"]
	for (var i = 0; i < ids.length; i++){
		$('#'+ids[i]).prop('checked', true);
	}
});

function passViews(val){
	for (var j = 0; j < val.length; j++){
		$('#'+val[j]+'_view').prop('checked', true)
	}
}

function expSubmit(){
	json = {};
	htmlids = ["show_outline", "show_dimen", "show_laminate"]
	htmlarr = [];
	for (var i = 0; i < htmlids.length; i++){
		var val = document.getElementById(htmlids[i]);
		if (val.checked == true){
			htmlarr.push(htmlids[i])
		}
	}
	json["draw"] = htmlarr

	viewids = ["left_view", "back_view", "right_view", "front_view"]
	viewarr = [];
	for (var j = 0; j < viewids.length; j++){
		var val = document.getElementById(viewids[j]);
		if (val.checked == true){
			var getval = document.getElementById(viewids[j]).value;
			viewarr.push(getval)
		}
	}
	json["views"] = viewarr

	var str = JSON.stringify(json);
	document.getElementById("load").style.display = "block";
	setTimeout(function() {window.location = 'skp:exporthtml@'+str;}, 500);	
}