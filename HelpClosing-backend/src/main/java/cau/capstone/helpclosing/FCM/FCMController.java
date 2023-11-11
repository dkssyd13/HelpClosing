package cau.capstone.helpclosing.FCM;

import cau.capstone.helpclosing.FCM.FCMRequestDTO;
import cau.capstone.helpclosing.FCM.FCMService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
public class FCMController {
    private final FCMService fcmService;

    @PostMapping("api/fcm")
    public ResponseEntity pushMessage(@RequestBody FCMRequestDTO FCMRequestDTO) throws IOException{
        System.out.println(FCMRequestDTO.getTargetToken() + " " + FCMRequestDTO.getTitle() + " " + FCMRequestDTO.getBody());

        fcmService.sendMessageTo(
                FCMRequestDTO.getTargetToken(),
                FCMRequestDTO.getTitle(),
                FCMRequestDTO.getBody());

        return ResponseEntity.ok().build();
    }
}
