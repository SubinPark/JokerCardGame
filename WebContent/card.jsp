<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="table">테이블</div> <br>
	<div id="card_box">카드</div>
	<input type="button" id="init" value="초기화 " />
	<br>
	<input type="text" id="num" />
	<input type="button" id="btn" value="click" />
</body>
<script type="text/javascript">
	//초기화버튼을 누르면 
	document.getElementById('init').onclick = function() {
		init();
	};

	//클릭버튼을 누르면 
	document.getElementById('btn').onclick = function() {
		getCards();
	};

	function init() {
		var xmlhttp;
		xmlhttp = new XMLHttpRequest();

		xmlhttp.onreadystatechange = function() { //callback method, 아니면 넘어간다 
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				console.log("Initialized!");
			}
		};

		//서버로 보낸다 
		xmlhttp.open("GET", "game/init");
		xmlhttp.send();
		alert("카드가 초기화되었습니다!");
	}

	function getCards() {
		var xmlhttp;
		xmlhttp = new XMLHttpRequest();

		//서버로부터 받아온 응답을 처리하는 로직을 설정
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				//서버에 요청 후 받아온 응답을 처리하는 부분 
				drawCards(xmlhttp, "card_box");
				getTable();
			}
		};

		//넘값을 받아와서 서버로 넘겨준다 
		var num = document.getElementById("num").value;

		xmlhttp.open("GET", "game/getCard" + "?num=" + num, true);
		console.log("What number is sent? " + num);
		xmlhttp.send();

	}

	//테이블의 카드를 받아오는 함수 
	function getTable() {
		var xmlhttp;
		xmlhttp = new XMLHttpRequest();

		//서버로부터 받아온 응답을 처리하는 로직을 설정
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				//서버에 요청 후 받아온 응답을 처리하는 부분 
				drawCards(xmlhttp, "table");
			}
		};

		xmlhttp.open("GET", "game/table", true);
		xmlhttp.send();
	}

	//클릭된 이미지를 서버에 보내는 함수 
	var sendToServer = function(imgClicked) {
		
		//서버와 통신하는 '객체'
		var xmlhttp = new XMLHttpRequest();

		//서버로부터 받아온 응답을 처리하는 로직을 설정
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				//서버에 요청 후 받아온 응답을 처리하는 부분 
				console.log(imgClicked + " is clicked");
				//TODO
				//drawCards(xmlhttp, "card_box");
			}
		};

		//서버요청에대한 정보를 정의 
		//xmlhttp.open("GET", "전송요청할서버위치?파라미터이름=파라미터값" + num, true);

		xmlhttp.open("GET", "game/clicked" + "?imgClicked=" + imgClicked, true);
		//서버에 요청! 
		xmlhttp.send();
	};

	var drawCards = function(xmlhttp, whichDiv) {
		//받아온 이미지주소를 쪼개기 
		var allTheCards = xmlhttp.responseText.split("/");
		var length = allTheCards.length - 1;
		

		/////////////////////////////////TOOOO DOOOOOOOOOOOOOOOOOOOOO *******************************
		document.getElementById("card_box").innerHTML = "";

// 		//이전 카드 삭제 
// 		for (var i = 0; i < length; i++) {
// 			try {
// 				document.getElementById(whichDiv).removeChild(
// 						document.getElementById(whichDiv).childNodes[0]);
// 			} catch (e) {

// 			}
// 		}
		

		//이미지를 그린다 - append
		for (var i = 0; i < length; i++) {
			var img = new Image();
			img.id = allTheCards[i];
			img.src = "./cards_png/" + allTheCards[i];

			//클릭하면 테이블덱으로 넘어가는 함수 
			//클릭 -> 서버에 요청해서 그 player 덱에서 없앤다 -> 없앤 카드를 테이블덱에 넣는다  
			img.onclick = function() {
				sendToServer(this.id);
			};

			console.log(whichDiv);
			console.log(img.id + "그려짐 ");
			document.getElementById(whichDiv).appendChild(img);
		}
	};
</script>
</html>