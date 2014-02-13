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

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		PrintWriter pw = resp.getWriter();
		ServletContext context = req.getServletContext();
		String realPath = context.getRealPath("/");
		String imgPath = realPath + "/cards_png";

		// 큰 리스트에 그림 불러오기
		File file = new File(imgPath);
		List<String> imgList = new ArrayList<String>();
		for (String fn : file.list()) {
			// 필요없는 카드와 조커 제거
			if (fn == "index.html" || fn.startsWith("b")
					|| !fn.endsWith(".png") || fn.startsWith("jr.png")
					|| fn.startsWith("jb.png")) {
				continue;
			}
			imgList.add(fn);
		}
		Collections.shuffle(imgList);

		// 작은 리스트에 그림 넣기
		List<String> selectedList = new ArrayList<String>();
		for (int i = 0; i < 8; i++) {
			selectedList.add(imgList.get(i));
		}
		selectedList.add("jr.png");
		selectedList.add("jb.png");
		Collections.shuffle(selectedList);

		for (int i = 0; i < 10; i++) {
			String returnImgFilePath = selectedList.get(i);
			pw.write(returnImgFilePath + "/");
		}

		pw.flush();
		pw.close();

	}

}
