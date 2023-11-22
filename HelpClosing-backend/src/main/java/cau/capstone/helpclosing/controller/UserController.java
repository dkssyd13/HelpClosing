package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.UserProfileRequest;
import cau.capstone.helpclosing.service.UserService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;


@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile/{email}")
    public Header read(@PathVariable String email){
        return Header.OK(userService.read(email), "send user profile");
    }

    @PutMapping("/profile/update")
    @ApiOperation(value = "수정 시 현재 로그인한 이메일과 프로필 보여주는 이메일이 다를 시 수정 버튼을 만들지 않음.")
    public Header update(@RequestBody UserProfileRequest userProfileRequest){
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getNickName();

            return Header.OK(userService.update(email, userProfileRequest), "Profile has been modified");
        }
        catch (Exception e){
            return Header.ERROR("Need to login for updating profile");
        }
    }
}
