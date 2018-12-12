$(document).ready(function(){
	document.getElementById('startproject').classList.add("disabled");
	window.location = 'skp:get_detail@'+1;
	window.location = 'skp:uptdetail@'+1;

	$('#startproject').on('click', function(){
		var chkids = ["client_name", "client_id", "apartment_name", "flat_number", "project_name", "project_number", "designer_name", "visualizer_name"]
		var json = {};
		for(var i = 0; i < chkids.length; i++){
			var value = $('#'+chkids[i]).val();
			if (chkids[i] == "client_name" || chkids[i] == "project_name"){
				if (value == ""){
					var res = chkids[i].replace(/_/g, " ");
					var cname = res.charAt(0).toUpperCase() + res.slice(1)
					toastr.error(cname+" can't be blank!", 'Error');
					$('#'+chkids[i]).focus();
					return false
				}else{
					json[chkids[i]] = value
				}
			}else{
				json[chkids[i]] = value
			}
		}
		var str = JSON.stringify(json);
		$('#load').css("display", "block")
		setTimeout(function() {window.location = 'skp:pro_details@'+ str;}, 1000);			
	});
});

function changePager(){
	document.getElementById("load").style.display = "none";
	// $('#page_content').load("load_wall.html");
	document.getElementById('add_wall').click();
}

function enableskip(){
	var cli = document.getElementById('client_name').value;
	var pro = document.getElementById('project_name').value;
	if (cli != "" && pro != ""){
		document.getElementById('startproject').classList.remove("disabled");
	}else{
		document.getElementById('startproject').classList.add("disabled");
	}
}

function uptAttrValue(inp){
	for(var i = 0; i < inp.length; i++){
		var sval = inp[i].split("|")
		$('#'+sval[0]).val(sval[1]);
	}
	$('#startproject').removeClass("disabled")
}