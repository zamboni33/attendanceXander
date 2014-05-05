package attendance.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import attendance.entity.Attendance;
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.google.appengine.labs.repackaged.org.json.JSONObject;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;

public class GrabDataServlet extends HttpServlet{
	
	//Servlet
		private static final long serialVersionUID = 1L;

		public void doGet(HttpServletRequest req, HttpServletResponse resp)
				throws IOException, ServletException {
			
			ObjectifyService.register(Professor.class);
			ObjectifyService.register(Student.class);
			ObjectifyService.register(Attendance.class);
			ObjectifyService.register(Course.class);
			
//			String unique = req.getParameter("classParam") + req.getParameter("email");
			String unique = req.getParameter("classParam") + "a.balette@utexas.edu";
			resp.getWriter().println(unique);
			Query<Attendance> queryAttendance = ObjectifyService.ofy().load().type(Attendance.class)
										.filter("attendanceKey", unique);
			
			for(Attendance a : queryAttendance){
			
				// Convert hashmap
				JSONObject json = new JSONObject(a.getMap());
				// Print to response stream
//				ServletOutputStream rout = resp.getOutputStream();
//				PrintWriter out = resp.getWriter();
//				out.println(json.toString());
//				resp.getWriter().println(json.toString());
//				rout.println(json.toString());
				resp.setContentType("text/html");
				req.setAttribute("json",json.toString());
			    req.getRequestDispatcher("/DashboardProfessor.jsp").forward(req, resp);
			}
			
			resp.getWriter().println(req.getParameter("classParam") + '\n');
			resp.getWriter().println(req.getParameter("email") + '\n');
			resp.getWriter().println("Test Drop" + '\n');
			
		}

	}