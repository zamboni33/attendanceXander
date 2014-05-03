package attendance.servlet;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.lang.Math;
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
import attendance.entity.Attendance;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.cmd.Query;


public class StopAttendanceServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
    int dayOfWeek;
    int hourOfDay;
    int minuteOfDay;

	public StopAttendanceServlet(){
	}
	
	static {
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Course.class);
		ObjectifyService.register(Classroom.class);
		ObjectifyService.register(Attendance.class);
	}
								
								
								
								
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
	
//									Student cron = new Student("Test1", "Cron Job Fired");
//									ofy().save().entities(cron).now();
		ObjectifyService.register(Professor.class);
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Course.class);
		ObjectifyService.register(Classroom.class);
		ObjectifyService.register(Attendance.class);
		
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("CST"));
		dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        DateFormat dateFormat = new SimpleDateFormat("HH:mm");
        DateFormat dateFormatCalendar = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setTimeZone(TimeZone.getTimeZone("CST"));
        dateFormatCalendar.setTimeZone(TimeZone.getTimeZone("CST"));
        
        String dateTotal = dateFormat.format(c.getTime());
        String dateCalendar = new String(dateFormatCalendar.format(c.getTime()));
        String[] timeParts = dateTotal.split(":");
		hourOfDay = Integer.parseInt(timeParts[0]);
		minuteOfDay = Integer.parseInt(timeParts[1]);
		
		List<Course> courses = ObjectifyService.ofy().load().type(Course.class).list();	
		for(Course course : courses ) {
			
//										Student cron2 = new Student("Test 2", course.getDays().toString());
//										ofy().save().entities(cron2).now();
			
			if(course.getDays().contains(dayOfWeek)){
				ArrayList<String> times = course.getTimes();
				
//											Student cron3 = new Student("Test3", course.getTimes().toString());
//											ofy().save().entities(cron3).now();
//											
//											Student cron4 = new Student("Test4", Integer.toString(hourOfDay));
//											ofy().save().entities(cron4).now();
//											
//											Student cron5 = new Student("Test5", Integer.toString(minuteOfDay));
//											ofy().save().entities(cron5).now();
				
				for(String time : times){
					String[] parts = time.split(":");
					if(Integer.parseInt(parts[0]) == hourOfDay && Integer.parseInt(parts[1]) + 15 == minuteOfDay){
						ArrayList<String> theseStudents = course.getStudents();
						for(String studentEmail : theseStudents){
							
							
//							Student cron6 = new Student("Test6", studentEmail);
//							ofy().save().entities(cron6).now();
//							
//							Student cron7 = new Student("Test7", dateCalendar);
//							ofy().save().entities(cron7).now();
							
							
							Query<Student> students = ofy().load().type(Student.class).filter("email", studentEmail );
							for(Student student : students ) {								
								
								
								
								
								student.stopAttendance();
							
								if(student.getLatitude() != 0.0 && student.getLongitude() != 0.0){
		//							TODO THIS IS WHERE WE RUN THE HAVERSINE AND MARK ATTENDANT OR ABSENT
									Double distance = new Double (haversine(course.getLatitude(), course.getLongitude(),
															student.getLatitude(), student.getLongitude()));
							
									
									if(distance < 100){
										String attendanceKey = new String(course.getClassUnique() + student.getEmail());
										Query<Attendance> attendance = ofy().load().type(Attendance.class).filter("attendanceKey", attendanceKey );
										for(Attendance dayTable : attendance){
											
											dayTable.assignPresent(dateCalendar);
											ofy().save().entity(dayTable).now();
											
											student.setDistance(distance);
											ofy().save().entities(student).now();
											
//											resp.getWriter().println(dateCalendar);
//											resp.getWriter().println(dayTable.getAttendance().toString());
//											resp.getWriter().println(student.getEmail());
//											resp.getWriter().println(distance.toString());
											
//											Student cron9 = new Student("Test9", distance.toString());
//											ofy().save().entities(cron9).now();
											
//											dayTable.assignPresent(dateCalendar);
//											ofy().save().entities(dayTable).now();
										}
									}
									else{
										String attendanceKey = new String(course.getClassUnique() + student.getEmail());
										Query<Attendance> attendance = ofy().load().type(Attendance.class).filter("attendanceKey", attendanceKey );
										for(Attendance dayTable : attendance){
											
											dayTable.assignPresent(dateCalendar);
											ofy().save().entity(dayTable).now();
											
											student.setDistance(distance);
											ofy().save().entities(student).now();
											
//											resp.getWriter().println(dateCalendar);
//											resp.getWriter().println(dayTable.getAttendance().toString());
//											resp.getWriter().println(student.getEmail());
//											resp.getWriter().println(distance.toString());
											
//											dayTable.assignAbsent(dateCalendar);
//											ofy().save().entities(dayTable).now();
										}
									}
								}
								else {
									String attendanceKey = new String(course.getClassUnique() + student.getEmail());
									Query<Attendance> attendance = ofy().load().type(Attendance.class).filter("attendanceKey", attendanceKey );
									for(Attendance dayTable : attendance){
										
//										Student cron8 = new Student("Test8", attendanceKey);
//										ofy().save().entities(cron8).now();
										
										dayTable.assignPresent(dateCalendar);
										ofy().save().entity(dayTable).now();
										
//										dayTable.assignAbsent(dateCalendar);
//										ofy().save().entities(dayTable).now();
									}
								}
								
								student.setLatitude(0.0);
								student.setLongitude(0.0);
								
								ofy().save().entities(student).now();
								
							}
							
						}
					}
				}
			}
		}
		
	}
	
	public Double haversine(Double lat1, Double lon1, Double lat2, Double lon2) {
        // TODO Auto-generated method stub
        final int R = 6371; // Radius of the earth
        Double latDistance = toRad(lat2-lat1);
        Double lonDistance = toRad(lon2-lon1);
        Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + 
                   Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
                   Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Double distance = new Double(R * c * 1000);
         
        return distance;
 
    }
     
    private Double toRad(Double value) {
        return value * Math.PI / 180;
    }
 

}
