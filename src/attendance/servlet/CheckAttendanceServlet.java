package attendance.servlet;

import java.lang.Math;
import java.util.Calendar;


public class CheckAttendanceServlet {
	
	@SuppressWarnings("unused")
	public CheckAttendanceServlet(){
		Calendar c = Calendar.getInstance();
		int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
		int hour_of_day= c.get(Calendar.HOUR_OF_DAY);
	}
	
	
	public Double haversine(Double lat1, Double lon1, Double lat2, Double lon2) {
        // TODO Auto-generated method stub
        final int R = 6371000; // Radius of the earth
        Double latDistance = toRad(lat2-lat1);
        Double lonDistance = toRad(lon2-lon1);
        Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + 
                   Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
                   Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Double distance = R * c;
         
        return distance;
 
    }
     
    private Double toRad(Double value) {
        return value * Math.PI / 180;
    }
 

}
