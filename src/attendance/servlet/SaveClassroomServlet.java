package attendance.servlet;
 
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;
import attendance.entity.Classroom;

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
public class SaveClassroomServlet extends HttpServlet {
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
		
	}

	// doPost Function
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		ObjectifyService.register(Classroom.class);
		
		Classroom classroom = new Classroom(req.getParameter("classroomName"), 
										new Double(req.getParameter("classroomLat")),
										new Double(req.getParameter("classroomLon")));
		
		
		ofy().save().entities(classroom).now();
		////////////////////
		
	
	
		resp.sendRedirect("/Register.jsp");
		
	}
}