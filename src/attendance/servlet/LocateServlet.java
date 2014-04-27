package attendance.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import attendance.entity.Student;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.*;
import com.googlecode.objectify.cmd.Query;

public class LocateServlet extends HttpServlet {
	  /**
		 * 
		 */
		private static final long serialVersionUID = 1L;

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	      throws IOException {
		
		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
		
		Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
				.filter("email", Student.normalize(user.getEmail() ));
	
		for(Student student : queryStudent ) {
			if(student.getAttendance() == true){
				student.setLatitude(new Double(req.getParameter("latitude") ));
				student.setLongitude(new Double(req.getParameter("longitude") ));
				ofy().save().entities(student).now();
			}
		}	
		resp.sendRedirect("/DashboardStudent.jsp");
	}

}
