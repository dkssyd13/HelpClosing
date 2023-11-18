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

    @Query("SELECT l FROM Location l WHERE within(l.coordinates, :point) = true")
    List<Location> findLocationsByPoint(@Param("point") Point point);

    // 반경 내의 위치를 찾는 쿼리
    @Query("SELECT l FROM Location l WHERE dwithin(l.coordinates, :point, :radius) = true")
    List<Location> findLocationsWithinRadius(@Param("point") Point point, @Param("radius") double radius);

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
