package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.Direction;
import cau.capstone.helpclosing.model.Entity.Location;
import cau.capstone.helpclosing.model.Request.LocationRegisterRequest;
import cau.capstone.helpclosing.model.repository.LocationRepository;
import cau.capstone.helpclosing.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class LocationService {

    @Autowired
    private LocationRepository locationRepository;

    @Autowired
    private UserRepository userRepository;

    private final EntityManager em;

    public Location addLocation(LocationRegisterRequest locationRegisterRequest){

        try{
            Location location = Location.builder()
                    .description(locationRegisterRequest.getDescription())
                    .address(locationRegisterRequest.getAddress())
                    .longitude(locationRegisterRequest.getLongitude())
                    .latitude(locationRegisterRequest.getLatitude())
                    .user(userRepository.findByEmail(locationRegisterRequest.getEmail()))
                    .build();

            System.out.println(location.toString());

            return locationRepository.save(location);

        }
        catch (Exception e){
            return null;
        }

    }
//
//    double radiusInMeters = 100.0;
//    double radiusInDegrees = radiusInMeters / 111320.0; // 1 degree = 111.32 km
//
//
//    public List<Location> findAllAround(LocationRequest locationRequest){
//        List<Location> locationList = locationRepository.findLocationsWithinRadius(locationRequest.getCoordinates(), radiusInDegrees);
//
//        return locationList;
//    }
//
//    public List<Location> findAround100(LocationRequest locationRequest){
//        List<Location> locationList = locationRepository.findAll();
//        List<Location> returnLocationList = null;
//
//        for (Location l : locationList){
//            double distance = calculateDistance(locationRequest.getCoordinates().getX(), l.getCoordinates().getX(), locationRequest.getCoordinates().getY(), l.getCoordinates().getY());
//            if (distance <= 100){ //100m 이내
//                returnLocationList.add(l);
//            }
//        }
//        return returnLocationList;
//    }
//
//
//    private double calculateDistance(double lat1, double lat2, double long1, double long2){
//        double lat1Rad = Math.toRadians(lat1);
//        double lat2Rad = Math.toRadians(lat2);
//        double long1Rad = Math.toRadians(long1);
//        double long2Rad = Math.toRadians(long2);
//
//        double dLat = lat1Rad - lat2Rad;
//        double dLong = long1Rad - long2Rad;
//
//        double a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(lat1Rad) * Math.cos(lat2Rad) * Math.sin(dLong/2) * Math.sin(dLong/2);
//        double c =  2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
//
//        double distance = 6371 * c; //km
//
//        return distance * 1000; //km를 1000을 곱해 m로 변환
//    }
//
//

    //100m 미터 검색하려면 distance = 0.1
    @Transactional(readOnly = true)
    public List<Location> getNearByPlaces(double latitude, double longitude, double distance){
        Location northEast = calculate(latitude, longitude, distance, Direction.NORTHEAST.getBearing());
        Location southWest = calculate(latitude, longitude, distance, Direction.SOUTHWEST.getBearing());

        double x1 = northEast.getLatitude();
        double y1 = northEast.getLongitude();
        double x2 = southWest.getLatitude();
        double y2 = southWest.getLongitude();

        List<Location> locations = locationRepository.findLocationsWithinDistance(x2, y2, x1, y1);
        return locations;
    }

    // Haversine Formula
    public static Location calculate(double baseLatitude, double baseLongitude, double distance, double bearing){
        double radianLatitude = toRadian(baseLatitude);
        double radianLongitude = toRadian(baseLongitude);
        double radianAngle = toRadian(bearing);
        double distanceRadius = distance / 6371.01;

        double latitude = Math.asin(sin(radianLatitude) * cos(distanceRadius) + cos(radianLatitude) * sin(distanceRadius) * cos(radianAngle));
        double longitude = radianLongitude + Math.atan2(sin(radianAngle) * sin(distanceRadius) * cos(radianLatitude), cos(distanceRadius) - sin(radianLatitude) * sin(latitude));

        longitude = normalizeLongitude(longitude);
        return new Location(toDegree(latitude), toDegree(longitude));
    }

    private static double toRadian(double coordinate){
        return coordinate * Math.PI / 180.0;
    }

    private static double toDegree(double coordinate){
        return coordinate * 180.0 / Math.PI;
    }

    private static double sin(double coordinate){
        return Math.sin(coordinate);
    }

    private static double cos(double coordinate){
        return Math.cos(coordinate);
    }

    private static double normalizeLongitude(double longitude){
        return (longitude + 540) % 360 -180;
    }
}
