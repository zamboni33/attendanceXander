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

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Classroom {
	
	@Id String room;
	Double latitude;
	Double longitude;
	
	
	public Classroom(){
		
	}
	
	public Classroom(String room, Double latitude, Double longitude){
		this.room = room;
		this.latitude = latitude;
		this.longitude = longitude;
	}
	
	public String getRoom(){
		return this.room;
	}
	
	public void setRoom(String room){
		this.room = room;
	}
	
	public Double getLatitude(){
		return this.latitude;
	}
	
	public void setLatitude(Double latitude){
		this.latitude = latitude;
	}
	
	public Double getLongitude(){
		return this.latitude;
	}
	
	public void setLongitude(Double longitude){
		this.longitude = longitude;
	}

}
