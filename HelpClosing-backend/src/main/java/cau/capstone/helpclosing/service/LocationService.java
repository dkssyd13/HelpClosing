package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.Location;
import cau.capstone.helpclosing.model.Request.LocationRequest;
import cau.capstone.helpclosing.model.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {

    @Autowired
    private LocationRepository locationRepository;


    public List<Location> findAround100(LocationRequest locationRequest){
        List<Location> locationList = locationRepository.findAll();
        List<Location> returnLocationList = null;

        for (Location l : locationList){
            double distance = calculateDistance(locationRequest.getLatitude(), l.getLatitude(), locationRequest.getLongitude(), l.getLongitude());
            if (distance <= 100){ //100m 이내
                returnLocationList.add(l);
            }
        }

        return returnLocationList;
    }

    private double calculateDistance(double lat1, double lat2, double long1, double long2){
        double lat1Rad = Math.toRadians(lat1);
        double lat2Rad = Math.toRadians(lat2);
        double long1Rad = Math.toRadians(long1);
        double long2Rad = Math.toRadians(long2);

        double dLat = lat1Rad - lat2Rad;
        double dLong = long1Rad - long2Rad;

        double a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(lat1Rad) * Math.cos(lat2Rad) * Math.sin(dLong/2) * Math.sin(dLong/2);
        double c =  2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        double distance = 6371 * c; //km

        return distance * 1000; //km를 1000을 곱해 m로 변환
    }
}
