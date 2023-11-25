package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.Location;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.LocationRegisterRequest;
import cau.capstone.helpclosing.model.Request.LocationRequest;
import cau.capstone.helpclosing.service.LocationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RequiredArgsConstructor
@RestController
public class LocationController {

    @Autowired
    private LocationService locationService;

    @GetMapping("/location/find")
    public Header<List<Location>> findAround(@RequestBody LocationRequest locationRequest){
        try{

            return Header.OK(locationService.getNearByPlaces(locationRequest.getLatitude(), locationRequest.getLongitude(), locationRequest.getDistance()),"list of users around 100m");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for finding around");
        }

    }

    @PostMapping("/location/add")
    public Header<Location> addLocation(@RequestBody LocationRegisterRequest locationRegisterRequest){
        try{
            return Header.OK(locationService.addLocation(locationRegisterRequest),"");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for adding location");
        }
    }
}
