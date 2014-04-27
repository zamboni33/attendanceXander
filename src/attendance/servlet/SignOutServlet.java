package attendance.servlet;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignOutServlet extends HttpServlet {
  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

@Override
  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
	
    UserService userService = UserServiceFactory.getUserService();
    userService.createLogoutURL(req.getRequestURI());

    resp.sendRedirect("/NotInDB.jsp");
    }
}