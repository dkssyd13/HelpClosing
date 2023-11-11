package cau.capstone.helpclosing.model.repository;

import cau.capstone.helpclosing.model.Entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LocationRepository extends JpaRepository<Location, Long> {

    List<Location> findAll();
    Location findByUserEmail(String email);

    Location findByLatitudeAndLongitude(double latitude, double longitude);
}
