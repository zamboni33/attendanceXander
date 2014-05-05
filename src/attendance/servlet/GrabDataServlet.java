//	This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

package attendance.servlet;

import java.io.IOException;
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
			
			String unique = null;
			
			if(req.getParameter("classParam") == null){
				Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
						.filter("email", req.getParameter("email"));

				for(Student s : queryStudent){
					String course = s.getCourses().get(0);
					unique = course + req.getParameter("email");
				}
			}
			
			else{
				unique = req.getParameter("classParam") + req.getParameter("email");
			}

			Query<Attendance> queryAttendance = ObjectifyService.ofy().load().type(Attendance.class)
										.filter("attendanceKey", unique);
			
			for(Attendance a : queryAttendance){
			
				// Convert hashmap
				JSONObject json = new JSONObject(a.getMap());
				// Print to response stream
				ServletOutputStream rout = resp.getOutputStream();
				rout.println(json.toString());

			}

			
		}

	}