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
 
import attendance.entity.Attendance;
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.googlecode.objectify.cmd.Query;
import com.googlecode.objectify.*;

import static com.googlecode.objectify.ObjectifyService.ofy; 

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Servlet to initialize courses within the datastore.
 
public class InitServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// Register the class in the servlet system
	static {
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Course.class);
	}

	// doPost Function
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		if (req.getParameter("initButton") != null) {
			
			if(req.getParameter("email").equals("c.julien@mail.utexas.edu")){
			
				Professor newProfessor = new Professor (req.getParameter("email"));
				ofy().save().entities(newProfessor).now();				
				Professor newProfessor2 = new Professor ("lucascoelhof@gmail.com");
				ofy().save().entities(newProfessor2).now();
				Professor newProfessor3 = new Professor ("giulianoprado@utexas.edu");
				ofy().save().entities(newProfessor3).now();	
				Professor newProfessor4 = new Professor ("a.balette@gmail.com");
				ofy().save().entities(newProfessor4).now();
				Professor newProfessor5 = new Professor ("c.julien@utexas.edu");
				ofy().save().entities(newProfessor5).now();
				Professor newProfessor6 = new Professor ("nick.kelly@utexas.edu");
				ofy().save().entities(newProfessor6).now();
				
				ArrayList<Integer> days = new ArrayList<Integer>();
				days.add(2);
				days.add(4);
				days.add(6);
				ArrayList<String> times = new ArrayList<String>();
				times.add("9:00");
				
				ArrayList<Integer> days2 = new ArrayList<Integer>();
				days2.add(3);
				days2.add(5);
				ArrayList<String> times2 = new ArrayList<String>();
				times2.add("15:00");
				
				ArrayList<String> courseUniqueList = new ArrayList<String>();
				courseUniqueList.add("12345");
				
				Course newCourse = new Course ("CPE 2.238", "Software Development", "12345", 
													days, times);
				newCourse.addStudent("a.balette@utexas.edu");
				newCourse.addStudent("acshulyak@utexas.edu");
				newCourse.addStudent("adamsak778@gmail.com");
				newCourse.addStudent("ads2666@me.com");
				newCourse.addStudent("ali.brinegar@gmail.com");
				newCourse.addStudent("astolz92@utexas.edu");
				newCourse.addStudent("colin.hickman@utexas.edu");
				newCourse.addStudent("juanncano@gmail.com");
				newCourse.addStudent("k.gowru@gmail.com");
				newCourse.addStudent("mphilipose@utexas.edu");
				newCourse.addStudent("nadeem.zaki@utexas.edu");
				newCourse.addStudent("tylerbusby@utexas.edu");
				newCourse.addStudent("romitkudtarkar@gmail.com");
				newCourse.addStudent("utravel461l@gmail.com");
				
				for(String s : newCourse.getStudents()){
					Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
							.filter("email", Student.normalize(s) );
					for(Student thisStudent : queryStudent){
						thisStudent.setCourses(courseUniqueList);
						
						ArrayList<String> temp2 = new ArrayList<String>();
						temp2.add("12345" + thisStudent.getEmail());
						
						thisStudent.setAttendanceKeyList(temp2);
						ofy().save().entities(thisStudent).now();
					}
//					if(s.equals("a.balette@utexas.edu")){
//						String temp = "12345" + Student.normalize(s);
//						Query<Attendance> queryAttendance = ObjectifyService.ofy().load().type(Attendance.class)
//															.filter("attendanceKey", temp );
//						for(Attendance a : queryAttendance){
//							a.getAttendance().put(key, value)
//							ofy().save().entities(a).now();
//						}
//					}
					
				}
				
				ofy().save().entities(newCourse).now();
				Course newCourse2 = new Course ("CPE 2.240", "Basket Weaving", "67890", 
													days, times2);
				ofy().save().entities(newCourse2).now();
			}
			else{
					resp.sendRedirect("/");
			}
		}
		resp.sendRedirect("/");
		
	}
}