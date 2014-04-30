package attendance.servlet;
 
import attendance.entity.Attendance;
import attendance.entity.Classroom;
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.apphosting.api.DatastorePb.DatastoreService;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;

import static com.googlecode.objectify.ObjectifyService.ofy; 

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.lang.String;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
@SuppressWarnings("unused")
public class RegisterServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// Register the class in the servlet system
	static {
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Course.class);
		ObjectifyService.register(Classroom.class);
		ObjectifyService.register(Attendance.class);
	}

	// doPost Function
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
		
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Attendance.class);
		ObjectifyService.register(Course.class);		
		
		Query<Student> queryStudents = ofy().load().type(Student.class)
										.filter("email", Student.normalize(user.getEmail()) );
		if (queryStudents.count() > 0){
			Student thisStudent = null;
			for(Student student : queryStudents ) {
				// Grab professor out of query
					thisStudent = student;
			}
			thisStudent.setFirst(req.getParameter("first"));
			thisStudent.setLast(req.getParameter("last"));
			thisStudent.setRegistered(true);
			ofy().save().entities(thisStudent).now();
			resp.sendRedirect("/DashboardStudent.jsp");
		}
		else{
			// Update Course Entity
			
			Query<Course> courses = ofy().load().type(Course.class)
									.filter("classUnique", req.getParameter("courseDropDown") );
			Course thisCourse = null;
			for(Course course : courses ) {
				// Grab professor out of query
				thisCourse = course;
			}
			thisCourse.setProfessor(Professor.normalize(user.getEmail()));
			thisCourse.setLatitude(Double.parseDouble(req.getParameter("latitude")));
			thisCourse.setLongitude(Double.parseDouble(req.getParameter("longitude")));
			ofy().save().entities(thisCourse).now();
			
			// Update Professor Entity
			Query<Professor> professors = ofy().load().type(Professor.class)
					.filter("email", Professor.normalize(user.getEmail()) );
			Professor thisProfessor = null;
			
			for(Professor professor : professors ) {
				// Grab professor out of query
					thisProfessor = professor;
			}
			
			thisProfessor.setFirst(req.getParameter("first"));
			thisProfessor.setLast(req.getParameter("last"));
			thisProfessor.setRegistered(true);
			ofy().save().entities(thisProfessor).now();

			
//			List<String> students = thisProfessor.getStudents();
//			for(String student : students){
//				resp.getWriter().println(student);
//				
//				Query<Student> queryStudent = ofy().load().type(Student.class)
//						.filter("email", Student.normalize(student) );
//				
//				if(queryStudent.count() != 0){
//					Student existingStudent = null;
//					for(Student scanStudent : queryStudent ) {
//						// Grab professor out of query
//						existingStudent = scanStudent;
//					}
//					
//					String attendanceKey = new String(req.getParameter("courseDropDown") + Student.normalize(student));
//					
//	//				String[] parts = attendanceKey.split(": ");
//	//				attendanceKey = parts[1];
//					
//					existingStudent.setAttendanceKey(attendanceKey);
//					ofy().save().entities(existingStudent).now();
//					
//					Attendance newAttendance = new Attendance(attendanceKey);
//					newAttendance.assignAbsent("0000-00-00");
//					ofy().save().entities(newAttendance).now();
//				}
//				else {
//					String attendanceKey = new String(req.getParameter("courseDropDown") + Student.normalize(student));
//					
//	//				String[] parts = attendanceKey.split(": ");
//	//				attendanceKey = parts[1];
//					
//					Student thisStudent = new Student(student, req.getParameter("courseDropDown"));
//	//				thisStudent.startAttendance();
//					ofy().save().entities(thisStudent).now();
//					
//					Attendance newAttendance = new Attendance(attendanceKey);
//					newAttendance.assignAbsent("0000-00-00");
//					ofy().save().entities(newAttendance).now();
//				}
//			}				
		
			resp.sendRedirect("/DashboardProfessor.jsp");
		} //End of register Prof
	}
}