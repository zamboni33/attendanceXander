package attendance.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import java.util.ArrayList;
import java.util.TimeZone;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import attendance.entity.Classroom;
import attendance.entity.Course;
import attendance.entity.Professor;
import attendance.entity.Student;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;


public class StartAttendanceServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    int dayOfWeek;
    int hourOfDay;
    int minuteOfDay;

	public StartAttendanceServlet(){
	}
	
	static {
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Course.class);
		ObjectifyService.register(Classroom.class);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
	
//		Student cron = new Student("Test1", "Cron Job Fired");
//		ofy().save().entities(cron).now();
		
		
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("CST"));
		dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        DateFormat dateFormat = new SimpleDateFormat("HH:mm");
        dateFormat.setTimeZone(TimeZone.getTimeZone("CST"));
        
        String dateTotal = dateFormat.format(c.getTime());
        String[] timeParts = dateTotal.split(":");
		hourOfDay = Integer.parseInt(timeParts[0]);
		minuteOfDay = Integer.parseInt(timeParts[1]);
		
		List<Course> courses = ObjectifyService.ofy().load().type(Course.class).list();	
		for(Course course : courses ) {
			
//			Student cron2 = new Student("Test 2", course.getDays().toString());
//			ofy().save().entities(cron2).now();
			
			if(course.getDays().contains(dayOfWeek)){
				ArrayList<String> times = course.getTimes();
				
//				Student cron3 = new Student("Test3", course.getTimes().toString());
//				ofy().save().entities(cron3).now();
//				
//				Student cron4 = new Student("Test4", Integer.toString(hourOfDay));
//				ofy().save().entities(cron4).now();
//				
//				Student cron5 = new Student("Test5", Integer.toString(minuteOfDay));
//				ofy().save().entities(cron5).now();
				
				for(String time : times){
					String[] parts = time.split(":");
//					if(Integer.parseInt(parts[0]) == hourOfDay && Integer.parseInt(parts[1]) == minuteOfDay){
						ArrayList<String> theseStudents = course.getStudents();
						for(String studentEmail : theseStudents){
							
							
							Student cron6 = new Student("Test6", studentEmail);
							ofy().save().entities(cron6).now();
							
							
							Query<Student> students = ofy().load().type(Student.class).filter("email", studentEmail );
							for(Student student : students ) {
								student.startAttendance();
								ofy().save().entities(student).now();
							}
						}
					}
				}
//			}
		}
		
	}
}
