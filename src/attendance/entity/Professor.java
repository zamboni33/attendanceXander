
package attendance.entity;

import java.util.ArrayList;
import java.util.List;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;


@Entity
public class Professor {
//	@Id Long id;

	@Id
	String email;
	String first;
	String last;
	boolean registered;
	List<String> courses = null;

	/** Use this method to normalize email addresses for lookup */
	public static String normalize(String email) {
		return email.toLowerCase();
	}
	
	public static Key<Professor> key(String email) {
		return Key.create(Professor.class, email);
	}
	
	static {
		ObjectifyService.register(Professor.class);
	}
	
	public Professor(){
		this.email = null;
		this.first = null;
		this.last = null;
		this.registered = false;
		this.courses = new ArrayList<String>();		
	}
	
	public Professor (String email)
	{

		this.email = normalize(email);
		this.first = null;
		this.last = null;
		this.registered = false;

	}
	
	public Professor (String email, ArrayList<String> courses)
	{

		this.email = normalize(email);
		this.first = null;
		this.last = null;
		this.registered = false;
		this.courses = courses;

	}	
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = normalize(email);
	}
	
	public String getFirst() {
		return first;
	}
	public void setFirst(String first) {
		this.first = normalize(first);
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
	
	public List<String> getcourses() {
		return courses;
	}
	public void setcourses() {
		// TODO: Do nothing for the time being
	}
}
