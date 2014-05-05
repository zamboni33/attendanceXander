package attendance.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import attendance.entity.Attendance;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;

public class GrabDataServlet extends HttpServlet{
	
	//Servlet
		private static final long serialVersionUID = 1L;

		public void doGet(HttpServletRequest req, HttpServletResponse resp)
				throws IOException, ServletException {
			
			String unique = req.getParameter("classParam") + req.getParameter("email");
			Query<Attendance> queryAttendance = ObjectifyService.ofy().load().type(Attendance.class)
										.filter("attendanceKey", unique);
			
			for(Attendance a : queryAttendance){
			
				// Convert hashmap
				JSONObject json = new JSONObject(a.getMap());
				// Print to response stream
				ServletOutputStream rout = resp.getOutputStream();
				rout.println(json.toString());
			}
			
			resp.getWriter().println(req.getParameter("classParam") + '\n');
			resp.getWriter().println(req.getParameter("test") + '\n');
			resp.getWriter().println("Test Drop" + '\n');
			
		}

	}