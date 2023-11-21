package cau.capstone.helpclosing.model.repository;

import cau.capstone.helpclosing.model.Entity.Location;
import org.locationtech.jts.algorithm.Distance;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.Point;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LocationRepository extends JpaRepository<Location, Long> {

    List<Location> findAll();

    Location findByUserEmail(String email);

    Location findByLatitudeAndLongitude(double latitude, double longitude);

    Location findByLocationId(Long locationId);

    @Query("SELECT l FROM Location l " +
            "WHERE MBRContains(" +
            "    GeomFromText(" +
            "        CONCAT('POLYGON((' , " +
            "            :minLongitude , ' ' , :minLatitude , ',' , " +
            "            :maxLongitude , ' ' , :minLatitude , ',' , " +
            "            :maxLongitude , ' ' , :maxLatitude , ',' , " +
            "            :minLongitude , ' ' , :maxLatitude , ',' , " +
            "            :minLongitude , ' ' , :minLatitude , " +
            "        '))')" +
            "    ), " +
            "    Point(l.longitude, l.latitude)" +
            ") = true")
    List<Location> findLocationsWithinDistance(
            @Param("minLatitude") double minLatitude,
            @Param("minLongitude") double minLongitude,
            @Param("maxLatitude") double maxLatitude,
            @Param("maxLongitude") double maxLongitude
    );
}
