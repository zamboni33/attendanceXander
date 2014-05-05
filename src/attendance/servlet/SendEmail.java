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
