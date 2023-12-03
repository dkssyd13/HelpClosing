package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.Location;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.LocationRequest;
import cau.capstone.helpclosing.model.Response.LocationResponse;
import cau.capstone.helpclosing.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
<<<<<<< HEAD
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
=======
import org.springframework.web.bind.annotation.*;
>>>>>>> 3ca3b45e503cd48976cbada1f1fa5d1ecf4ae4e8

import java.util.List;


@RequiredArgsConstructor
@RestController
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/location/find")
    public Header<List<Location>> findAround(@RequestParam double latitude, @RequestParam double longitude, @RequestParam double distance){
        try{
<<<<<<< HEAD
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getEmail();

            return Header.OK(locationService.getNearByPlaces(locationRequest.getLatitude(), locationRequest.getLongitude(), locationRequest.getDistance()),"list of users around 100m");
=======
            return Header.OK(locationService.getNearByPlaces(latitude, longitude, distance),"list of users around 100m");
>>>>>>> 3ca3b45e503cd48976cbada1f1fa5d1ecf4ae4e8
        }
        catch(Exception e){
            return Header.ERROR("Need to login for finding around");
        }

    }
<<<<<<< HEAD
=======

    @GetMapping("/location/distance")
    public List<LocationResponse> findAroundDistance(@RequestParam double latitude, @RequestParam double longitude, @RequestParam double distance){
        try{
            return locationService.getRankedLocations(latitude, longitude, distance);
        }
        catch(Exception e){
            return null;
        }

    }

    @PostMapping("/location/add")
    public ResponseEntity<Location> addLocation(@RequestBody LocationRegisterRequest locationRegisterRequest){
        try{
            return ResponseEntity.ok(locationService.addLocation(locationRegisterRequest));
        }
        catch(Exception e){
            return ResponseEntity.badRequest().build();
        }

    }
>>>>>>> 3ca3b45e503cd48976cbada1f1fa5d1ecf4ae4e8
}
