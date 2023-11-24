package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Request.LoginRequest;
import cau.capstone.helpclosing.model.Response.LoginResponse;
import cau.capstone.helpclosing.model.repository.UserRepository;
import cau.capstone.helpclosing.service.UserService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {



    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserService userService;

    @ApiOperation(value = "로그인 페이지", notes = "JWT 토큰을 전달")
    @PostMapping("/login")
    @CrossOrigin(origins = "*", maxAge = 3600)
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) throws Exception {
        return new ResponseEntity<>(userService.login(request), HttpStatus.OK);
    }

}
