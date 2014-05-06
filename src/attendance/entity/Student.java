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

package attendance.entity;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

import java.lang.String;
import java.util.ArrayList;


@Entity
public class Student {
	@Id String email;
	String first;
	String last;
	boolean registered;
	boolean recordLocation;
	double latitude;
	double longitude;
	double distance;
	ArrayList<String> attendanceKey;
	ArrayList<String> courses;
	
	
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
		this.first = null;
		this.last = null;
		this.registered = false;
		this.recordLocation = false;
		this.latitude = 0.0;
		this.longitude = 0.0;
		this.distance = 0.0;
		String temp = new String(course + email);
		this.attendanceKey = new ArrayList<String>();
		this.attendanceKey.add(temp);
		this.courses = new ArrayList<String>();
		this.courses.add(course);
		
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = Student.normalize(email);
	}
	public String getFirst() {
		return first;
	}
	public void setFirst(String first) {
		this.first =normalize(first);
	}
	public String getLast() {
		return last;
	}
	public void setLast(String last) {
		this.last = normalize(last);
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
	public double getDistance() {
		return this.distance;
	}
	public void setDistance(double distance) {
		this.distance = distance;
	}
	public ArrayList<String> getAttendanceKey() {
		return this.attendanceKey;
	}
	public void setAttendanceKey(String key) {
		this.attendanceKey.add(key);
	}
	public void setAttendanceKeyList(ArrayList<String> key) {
		this.attendanceKey = key;
	}
	public ArrayList<String> getCourses() {
		return this.courses;
	}
	public void setCourses(ArrayList<String> courses) {
		this.courses = courses;
	}
	
	
}