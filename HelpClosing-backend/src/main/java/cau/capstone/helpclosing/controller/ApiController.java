package cau.capstone.helpclosing.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiController {
    @GetMapping("hello")
    @CrossOrigin(origins = "*", maxAge = 3600)
    public String hello()
    {
        System.out.println("hello");
        return "hello";
    }
}
