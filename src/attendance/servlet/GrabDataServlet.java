package attendance.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GrabDataServlet extends HttpServlet{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		
//	    req.setAttribute("Return", "Success");
//
//	    RequestDispatcher rd = req.getRequestDispatcher("/Test.jsp");
//	    rd.forward(req,resp);
		
		resp.getWriter().println(req.getParameter("classParam") + '\n');
		resp.getWriter().println(req.getParameter("test") + '\n');
		resp.getWriter().println("Test Drop" + '\n');
		
	}

}
