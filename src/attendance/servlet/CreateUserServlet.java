package attendance.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import attendance.entity.Attendance;
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;

public class CreateUserServlet  extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Attendance.class);
		ObjectifyService.register(Course.class);
		
		String studentEmail = new String(Student.normalize(req.getParameter("email")));
		String classUnique = new String(req.getParameter("courseDropDown"));
		
		Query<Course> courses = ofy().load().type(Course.class).filter("classUnique", classUnique );
		
		resp.getWriter().println(req.getParameter("email"));
		resp.getWriter().println(req.getParameter("courseDropDown"));
		
		if(courses.count() == 0){
			resp.getWriter().println(req.getParameter("email"));
			resp.getWriter().println(req.getParameter("courseDropDown"));
		}
		else {
			for(Course course : courses){
				course.addStudent(studentEmail);
				ofy().save().entities(course).now();
			}
			
			String attendanceKey = new String(classUnique + studentEmail);
				
			Student thisStudent = new Student(Student.normalize(req.getParameter("email")), 
												req.getParameter("courseDropDown"));
			ofy().save().entities(thisStudent).now();
			
			Attendance newAttendance = new Attendance(attendanceKey);
			newAttendance.assignAbsent("0000-00-00");
			ofy().save().entities(newAttendance).now();
			
			resp.sendRedirect("/");
		}
	}
}
