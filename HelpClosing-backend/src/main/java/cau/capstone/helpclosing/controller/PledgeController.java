package cau.capstone.helpclosing.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class PledgeController {
<<<<<<< HEAD
=======

    @Autowired
    private  PledgeRepository pledgeRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/pledge/get")
    public Header<Pledge> getPledge(@RequestParam(required = true) String email) {

        try {
            Pledge pledge = pledgeRepository.findByUser(userRepository.findByEmail(email));

            return Header.OK(pledge, "");
        }
        catch (Exception e) {
            return Header.ERROR("Need to login for seeing pledge");
        }

    }



>>>>>>> 3ca3b45e503cd48976cbada1f1fa5d1ecf4ae4e8
}
