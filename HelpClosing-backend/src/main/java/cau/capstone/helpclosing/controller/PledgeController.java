//package cau.capstone.helpclosing.controller;
//
//
//import cau.capstone.helpclosing.model.Entity.Pledge;
//import cau.capstone.helpclosing.model.Header;
//import cau.capstone.helpclosing.model.repository.PledgeRepository;
//import cau.capstone.helpclosing.model.repository.UserRepository;
//import lombok.RequiredArgsConstructor;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//
//@RequiredArgsConstructor
//@RestController
//public class PledgeController {
//
//    @Autowired
//    private  PledgeRepository pledgeRepository;
//
//    @Autowired
//    private UserRepository userRepository;
//
//    @GetMapping("/pledge/get")
//    public Header<Pledge> getPledge(@RequestParam(required = true) String email) {
//
//        try {
//            Pledge pledge = pledgeRepository.findByUser(userRepository.findByEmail(email));
//
//            return Header.OK(pledge, "");
//        }
//        catch (Exception e) {
//            return Header.ERROR("Need to login for seeing pledge");
//        }
//
//    }
//
//
//
//}
