$(document).ready(function(){
	window.location = 'skp:get_detail@'+1;
	$('#page_content').load("load_welcome.html");
	$('#p0').css("display", "block");

	$(".fbutton").click(function (e) {
		var cname = $('#client_name').val();
		var pname = $('#project_name').val();
		if (cname != "" && pname != ""){
			$(this).addClass("active").siblings().removeClass("active");
		}
	});

	$('#clicklogin').on('click', function(){
		var email = $('#email').val();
		var pwd = $('#password').val();
		if ($.trim(pwd).length == 0){
			toastr.error("Password can't be blank!", 'Error');
			$('#password').focus();
			return false;
		}

		arrval = []
		if (email.length != 0 && pwd.length != 0){
			arrval.push(email)
			arrval.push(pwd)
			$('#load').css("display", "block");
			setTimeout(function() {window.location = 'skp:loginval@'+ arrval;}, 10);			
		}
	});

	$('#email').blur(function(){
		var mail = $('#email').val();
		if ($.trim(mail).length == 0){
			toastr.error("Email can't be blank!", 'Error')
			$('#email').focus();
			return false;
		}
		if (validateEmail(mail)){
			return true;
		}else{
			toastr.error('Invalid email address!', 'Error');
			$('#email').focus();
			$('#email').val('');
			return false;
		}
	});
});

function passStatus(line){
	if (line == 1){
		document.getElementById('showon').style.display = "block";
		document.getElementById('showoff').style.display = "none";
		document.getElementById('showoffnote').style.display = "none"
	}else{
		document.getElementById('showoff').style.display = "block";
		document.getElementById('showoffnote').style.display = "block"
		document.getElementById('showon').style.display = "none";
	}
}

function validateLog(inp){
	if (inp == 1){
		window.location = 'skp:openapp@'+ inp;
	}else if (inp == 0){
		document.getElementById('load').style.display = "none";
		toastr.error('Invalid email or password!', 'Error')
		return false;
	}
}

function hideLoad(val){
	document.getElementById("load").style.display = "none";
}

function htmlDone(path){
	document.getElementById("load").style.display = "none";
	toastr.success('HTML Generated Successfully!', 'Success')
	setTimeout(function() {window.location = 'skp:openfile@'+ path;}, 1000);			
}

function validateEmail(sEmail) {
	var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	if (filter.test(sEmail)) {
		return true;
	}
	else {
		return false;
	}
}

function passPageToJs(page){
	$('#fname').val(page);
}

function pager(pval){
	var cname = $('#client_name').val();
	var pname = $('#project_name').val();
	if (cname != "" && pname != ""){
		if (pval == 0){
			$('#page_content').load("load_welcome.html");
			hideicon(0)
		}else if (pval == 1){
			$('#page_content').load("load_wall.html");
			hideicon(1)
		}else if (pval == 2){
			$('#page_content').load("load_add_comp.html");
			hideicon(2)
		}else if (pval == 3){
			$('#page_content').load("load_add_attr.html");
			hideicon(3)
		}else if (pval == 4){
			$('#page_content').load("load_html.html");
			hideicon(4)
		}
	}else{
		toastr.info('Please fill the mandatory field!', 'Info')
		if (cname == ""){	$('#client_name').focus();}else if (pname == ""){$('#client_name').focus();}
		return false;
	}
}

function hideicon(val){
	if (val == 0){
		$('#p0').css("display", "block");
		$('#p1').css("display", "none");
		$('#p2').css("display", "none");
		$('#p3').css("display", "none");
		$('#p4').css("display", "none");
	}else if (val == 1){
		$('#p1').css("display", "block");
		$('#p0').css("display", "none");
		$('#p2').css("display", "none");
		$('#p3').css("display", "none");
		$('#p4').css("display", "none");
	}else if (val == 2){
		$('#p2').css("display", "block");
		$('#p1').css("display", "none");
		$('#p0').css("display", "none");
		$('#p3').css("display", "none");
		$('#p4').css("display", "none");
	}else if (val == 3){
		$('#p3').css("display", "block");
		$('#p1').css("display", "none");
		$('#p2').css("display", "none");
		$('#p0').css("display", "none");
		$('#p4').css("display", "none");
	}else if (val == 4){
		$('#p4').css("display", "block");
		$('#p1').css("display", "none");
		$('#p2').css("display", "none");
		$('#p3').css("display", "none");
		$('#p0').css("display", "none");
	}
}