package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.domain.User;
import com.google.firebase.internal.FirebaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@org.springframework.web.bind.annotation.RestController
public class RestController {
    @Autowired
    FirebaseService firebaseServiceImpl;

    @GetMapping("/insertUser")
    public String insertUser(@RequestParam User user) throws Exception{
        return firebaseServiceImpl.insertUser(user);
    }

    @GetMapping("/getUserDetail")
    public User getUserDetail(@RequestParam String id) throws Exception{
        return firebaseServiceImpl.getUserDetail(id);
    }

    @GetMapping("/updateUser")
    public String updateUser(@RequestParam User user) throws Exception{
        return firebaseServiceImpl.updateUser(user);
    }

    @GetMapping("/deleteUser")
    public String deleteUser(@RequestParam String id) throws Exception {
        return firebaseServiceImpl.deleteUser(id);
    }


}
