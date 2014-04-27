
package attendance.entity;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

import java.lang.String;
import java.util.ArrayList;


@Entity
public class Student {
	@Id String email;
	boolean registered;
	int courseCount;
	boolean recordLocation;
	double latitude;
	double longitude;
	ArrayList<String> attendanceKey;
	
	
	/** Use this method to normalize email addresses for lookup */
	public static String normalize(String email) {
		return email.toLowerCase();
	}	
	
	static {
		ObjectifyService.register(Student.class);
	}
	
	public Student(){}
	
	public Student (String email, String course)
	{
		this.email = email;
		this.registered = false;
		this.recordLocation = false;
		this.latitude = 0.0;
		this.longitude = 0.0;
		String temp = new String(course + email);
		this.attendanceKey = new ArrayList<String>();
		this.attendanceKey.add(temp);
		
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = Student.normalize(email);
	}
	public boolean getRegistered() {
		return registered;
	}
	public void setRegistered(boolean eval) {
		this.registered = eval;
	}
	
	public boolean getAttendance(){
		return this.recordLocation;
	}

	public void startAttendance(){
		this.recordLocation = true;
	}
	public void stopAttendance(){
		this.recordLocation = false;
	}
	
	public double getLatitude() {
		return this.latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return this.longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public ArrayList<String> getAttendanceKey() {
		return this.attendanceKey;
	}
	public void setAttendanceKey(String key) {
		this.attendanceKey.add(key);
	}	
	
}