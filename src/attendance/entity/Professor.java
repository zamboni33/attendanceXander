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

import java.util.ArrayList;
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
	ArrayList<String> courses = null;

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
	
	public ArrayList<String> getCourses() {
		return courses;
	}
	public void setcourses() {
		// TODO: Do nothing for the time being
	}
}
