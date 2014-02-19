package com;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ServletTest extends HttpServlet {
		
	List<String> selectedList1 = new ArrayList<String>();
	List<String> selectedList2 = new ArrayList<String>();
	List<String> selectedList3 = new ArrayList<String>();
	List<String> selectedList4 = new ArrayList<String>();
	
	List<String> table = new ArrayList<String>();
	List<List<String>> selectedListList = new ArrayList<List<String>>();
	//함수밖에서 selectedListList.add() 사용할수없다  
	
	int playerNum;
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String path = req.getRequestURI();
		System.out.println("This is the URI: " + path);
		
		PrintWriter pw = resp.getWriter();
		
		//초기화 request면은 
		if (path.contains("init")) {
			
			//individual 리스트에 카드들이 들어있으면 (이미 한번 이닛이 됬다는 뜻) -> 다시 초기
			if (!selectedList1.isEmpty()) {
				selectedList1.clear();
				selectedList2.clear();
				selectedList3.clear();
				selectedList4.clear();
				selectedListList.clear();
			}
			
			table.clear();
			ServletContext context = req.getServletContext();
			String realPath = context.getRealPath("/");
			String imgPath = realPath + "/cards_png";

			// 큰 리스트에 그림 불러오기
			File file = new File(imgPath);
			List<String> imgList = new ArrayList<String>();
			for (String fn : file.list()) {
				// 필요없는 카드와 조커 제거
				if (fn == "index.html" || fn.startsWith("b")
						|| !fn.endsWith(".png")) {
					continue;
				}
				imgList.add(fn);
			}
			Collections.shuffle(imgList);
			
			
			// 14개의 카드를 각각 4개의 리스트에 넣는다 
			for (int i = 0; i < 14; i++) {
				selectedList1.add(imgList.get(i));
				selectedList2.add(imgList.get(14 + i));
				selectedList3.add(imgList.get(28 + i));
				selectedList4.add(imgList.get(42 + i));
			}
			selectedListList.add(selectedList1);
			selectedListList.add(selectedList2);
			selectedListList.add(selectedList3);
			selectedListList.add(selectedList4);
		}

		//getCard request이면 
		else if (path.contains("getCard")) { 
			playerNum = Integer.parseInt(req.getParameter("num")); //받아온 num값을 int로 고친다 
			System.out.println("what is the num? " + playerNum);
			playerNum--; //because arraylist index starts from 0 to 3 not 1 to 4 
			List<String> eachList = selectedListList.get(playerNum);

			for (int i = 0; i < 14; i++) {// 작은 리스트들에 14개씩 그림 넣기
				String returnImgFilePath = eachList.get(i);
				pw.write(returnImgFilePath + "/");
			}

			pw.flush();
			pw.close();
		}
		
		//clicked request이면 
		else if (path.contains("clicked")) {
			String imgClicked = req.getParameter("imgClicked");
			System.out.println("playerNum is " + playerNum);
			System.out.println(selectedListList.get(playerNum));
			List<String> theList = selectedListList.get(playerNum);
			
			//클릭된 카드를 정해진 플레이어의 덱에서 지우고 테이블덱에 올린다 
			theList.remove(imgClicked);
			System.out.println(theList);
			table.add(imgClicked);
			
			for (int i = 0; i < theList.size(); i++) {// 작은 리스트들에 14개씩 그림 넣기
				String returnImgFilePath = theList.get(i);
				pw.write(returnImgFilePath + "/");
			}

			pw.flush();
			pw.close();
		}
		
		else if (path.contains("table")) {
			for (int i = 0; i < table.size(); i++) {// 작은 리스트들에 14개씩 그림 넣기
				String returnImgFilePath = table.get(i);
				pw.write(returnImgFilePath + "/");
			}

			pw.flush();
			pw.close();
		}
	}

}
