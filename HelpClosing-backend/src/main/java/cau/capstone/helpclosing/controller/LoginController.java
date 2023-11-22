package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.LoginRequest;
import cau.capstone.helpclosing.model.Response.LoginResponse;
import cau.capstone.helpclosing.model.repository.UserRepository;
import cau.capstone.helpclosing.security.entity.JwtUtil;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @ApiOperation(value = "로그인 페이지", notes = "JWT 토큰을 전달")
    @PostMapping("/login")
    @CrossOrigin(origins = "*", maxAge = 3600)
    public Header generateToken(
            @ApiParam(value = "!!이메일 주소, 비밀번호 필수!!", required = true, example = "email:test@naver.com, password: ****")
            @RequestBody LoginRequest loginRequest
            ) {
        try {
            //로그인 정보로 AuthenticationManager 에서 사용할 수 있는 UsernamePasswordAuthenticationToken 생성
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
            );
            User user = userRepository.findByEmail(loginRequest.getEmail());
            LoginResponse loginResponse = LoginResponse.builder()
                    .jwtToken(jwtUtil.generateToken(loginRequest.getEmail()))
                    .email(user.getEmail())
                    .name(user.getName())
                    .nickName(user.getNickName())
                    .image(user.getImage())
                    .build();
            return Header.OK(loginResponse, "Sign in successfully.");

        }   catch (Exception e) {
            return Header.ERROR("Wrong id or password.");
        }
    }

}
