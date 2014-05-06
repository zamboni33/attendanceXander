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
import java.util.Collections;
import java.util.HashMap;
import java.util.Set;

import javax.jdo.annotations.Persistent;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Attendance {

	@Id String attendanceKey;
	@Persistent(serialized="true")
	HashMap<String, Boolean> attendance;
	
	public Attendance(){}
	
	public Attendance(String attendanceKey){
		this.attendanceKey = attendanceKey;
		this.attendance = new HashMap<String, Boolean>();
	}
	
	// Copy Constructor
	public Attendance(Attendance copy){
		this.attendanceKey = new String (copy.getAttendanceKey());
		this.attendance = new HashMap<String, Boolean>(copy.getAttendance());
	}
	
	public String getAttendanceKey(){
		return this.attendanceKey;
	}
	
	public void setAttendanceKey(String key){
		this.attendanceKey = key;
	}
	
	public HashMap<String, Boolean> getAttendance(){
		return this.attendance;
	}
	
	public void setAttendance(HashMap<String, Boolean> map){
		this.attendance = map;
	}
	
	// Altering Map Data
	
	public void assignPresent(String day) {
		attendance.put(day, true);
	}
	
	public void assignAbsent(String day) {
		attendance.put(day, false);
	}
	
	// Access Map Data
	
	public ArrayList<String> getKeys () {
		System.out.println("Retrieving Keys");
		Set<String> keySet = this.attendance.keySet();
		ArrayList<String> keys = new ArrayList<String>(keySet);
		Collections.sort(keys);
		return (keys);
	}
	public HashMap<String, Boolean> getMap () {
		return (this.attendance);
	}	
	
}
