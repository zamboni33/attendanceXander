package attendance.servlet;

import java.io.IOException;
import java.util.*;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SendEmail extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		if (req.getParameter("postButton") != null) {
			// Get system properties, set mail server and get the session
			Properties properties = System.getProperties();
			properties.setProperty("mail.smtp.host", "localhost");
			Session session = Session.getDefaultInstance(properties);

			try {
				MimeMessage message = new MimeMessage(session);
				message.setFrom(new InternetAddress(
						"admin@attendance-utexas.appspotmail.com"));
				message.setSubject("Error information");
				String messageText = "";
				messageText += "\nDate:" + new Date().toString();
				
				// TODO This date is the wrong time zone.
				
				messageText += "\nEmail:" + req.getParameter("email");
				
				
				
				messageText += "\nExtra information: " + req.getParameter("description");
				message.setText(messageText);

				message.addRecipient(Message.RecipientType.TO,
						new InternetAddress("giulianoprado@gmail.com"));
				Transport.send(message);
				resp.sendRedirect("/AttendanceXander.jsp");
			} catch (MessagingException mex) {
				mex.printStackTrace();
			}
		}
	}
}
