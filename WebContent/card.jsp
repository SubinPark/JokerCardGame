<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div id="card_box"></div>
	<input type="text" id="num" />
	<input type="button" id="btn" value="click" />
</body>
<script type="text/javascript">
	document.getElementById('btn').onclick = function() {
		loadXMLDoc();
	}

	function loadXMLDoc() {
		var xmlhttp;
		xmlhttp = new XMLHttpRequest();

		xmlhttp.onreadystatechange = function() { //callback method, 아니면 넘어간다 
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				console.log(xmlhttp.responseText);
				//쪼개기
				var cards = xmlhttp.responseText.split("/", 10);

				//이전 카드 삭제 
				for (var i = 0; i < cards.length; i++) {
					try {
						document
								.getElementById("card_box")
								.removeChild(
										document.getElementById("card_box").childNodes[0]);
					} catch (e) {

					}
				}

				//이미지를 그린다 - append
				for (var i = 0; i < cards.length; i++) {
					var img = new Image();
					img.id = cards[i];
					img.src = "./cards_png/b1fv.png";

					var complete = false;
					img.onclick = function() {
						if (complete == true) {
							return;
						} else {
							console.log(this.id);
							this.src = "./cards_png/" + this.id;
							if (this.id == "jb.png" || this.id == "jr.png") {
								alert("조커를 찾았습니다");
								complete = true;
							}
						}
					};
					document.getElementById("card_box").appendChild(img);
				}
			}
		};

		var num = document.getElementById("num").value;
		xmlhttp.open("GET", "getCard" + "?num=" + num, true);
		console.log(num);
		xmlhttp.send();
	}
</script>
</html>