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
