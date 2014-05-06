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
import java.util.HashMap;
import java.util.ArrayList;

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
			
			Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
					.filter("email", Student.normalize(req.getParameter("email")) );
			Query<Professor> queryProfessor = ObjectifyService.ofy().load().type(Professor.class)
								.filter("email", Professor.normalize(req.getParameter("email")) );
			
			// Grab Student Data
			if(queryStudent.count() > 0){
				String unique = null;
				if(req.getParameter("classParam") == null){
	
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
			else{
				// Grab Professor Data
				String uniqueCourse = null;
				if(req.getParameter("classParam") == null){
	
					for(Professor p : queryProfessor){
						String course = p.getCourses().get(0);
						uniqueCourse = course;
					}
				}
				else{
					uniqueCourse = req.getParameter("classParam");
				}
				Query<Course> queryCourse = ObjectifyService.ofy().load().type(Course.class)
											.filter("classUnique", uniqueCourse);
				
				// We have the course unique
					// Get list of students and count those present
				
				for(Course c : queryCourse){
					HashMap<String, Integer> legend = new HashMap<String, Integer>();
					for(String s : c.getStudents()){
						
						String unique = uniqueCourse + s;
						Query<Attendance> queryAttendance = ObjectifyService.ofy().load().type(Attendance.class)
															.filter("attendanceKey", unique);
						
						ArrayList<String> thisAttendance = null;
						for(Attendance a : queryAttendance){
							thisAttendance = a.getKeys();
							
							for(String date : thisAttendance){
								if(legend.get(date) == null){
									legend.put(date, 0);
								}
								
								if(a.getAttendance().get(date) == true){
									legend.put(date, legend.get(date) + 1);
								}
							}
						}
						
					}
					// Create JSON from hashmap
					// Convert hashmap
					JSONObject json = new JSONObject(legend);
					// Print to response stream
					ServletOutputStream rout = resp.getOutputStream();
					rout.println(json.toString());
	
				}
				
				
			}

			
		}

	}