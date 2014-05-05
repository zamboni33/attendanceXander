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

import static com.googlecode.objectify.ObjectifyService.ofy;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignInServlet extends HttpServlet {
  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

@Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
	
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
	
    if (user==null)
    	resp.sendRedirect("/");
    
	// Where is the best place to register these?
	ObjectifyService.register(Professor.class);
	ObjectifyService.register(Student.class);
	
	Query<Professor> professors = ofy().load().type(Professor.class)
									.filter("email", Professor.normalize(user.getEmail()) );
	for(Professor professor : professors ) {
		if(professor.getRegistered()){
			resp.sendRedirect("/DashboardProfessor.jsp");
		}
		else{
			resp.sendRedirect("/Register.jsp");
		}
	}
	
	Query<Student> students = ofy().load().type(Student.class).filter("email", user.getEmail().toLowerCase() );
	for(Student student : students ) {
		if(student.getRegistered()){
			resp.sendRedirect("/DashboardStudent.jsp");
		}
		else{
			resp.sendRedirect("/Register.jsp");
//			resp.sendRedirect("/DashboardStudent.jsp");
		}
	}	
	
	resp.sendRedirect("/NotInDB.jsp");
  }
}

//	List<Professor> professors = ObjectifyService.ofy().load().type(Professor.class).list();	
//	for(Professor professor : professors ) {
		// Look for users in the database
		
//		if (professor.getEmail().equals (user.getEmail().toLowerCase()) ){
//			if(professor.getRegistered()){
//				resp.sendRedirect("/DashboardProfessor.jsp");
//			}
//			else{
//				resp.sendRedirect("/Register.jsp");
//			}
//		}
	
//		resp.getWriter().println(professor.getEmail().toLowerCase());
//		resp.getWriter().println(user.getEmail().toLowerCase());
//		System.out.println(professor.getEmail());
//		System.out.println(user.getEmail());
//	}
	
//	List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
//	
//	for(Student student : students ) {
//		// Look for users in the database
//		if (student.getEmail().equals (user.getEmail().toLowerCase()) ){
//			if(student.getRegistered()){
//				resp.sendRedirect("/DashboardStudent.jsp");
//			}
//			else{
//				resp.sendRedirect("/Register.jsp");
//			}
//		}
//	}