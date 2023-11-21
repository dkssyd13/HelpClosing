package cau.capstone.helpclosing.FCM;

import cau.capstone.helpclosing.FCM.FCMRequestDTO;
import cau.capstone.helpclosing.FCM.FCMService;
import cau.capstone.helpclosing.model.Header;
import com.google.api.client.auth.oauth2.TokenRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
public class FCMController {

    private final FCMService fcmService;
    private final FCMCRUD fcmcrud;

    @PostMapping("/fb/fcm")
    public ResponseEntity pushMessage(@RequestBody FCMRequestDTO FCMRequestDTO) throws IOException{
        System.out.println(FCMRequestDTO.getTargetToken() + " " + FCMRequestDTO.getTitle() + " " + FCMRequestDTO.getBody());

        fcmService.sendMessageTo(
                FCMRequestDTO.getTargetToken(),
                FCMRequestDTO.getTitle(),
                FCMRequestDTO.getBody());

        return ResponseEntity.ok().build();
    }

    @PostMapping("/fb/saveFCMToken")
    public Header saveFCMToken(@RequestBody FCMTokenRequest tokenRequest) throws Exception {
        System.out.println(tokenRequest.getEmail() + " " + tokenRequest.getFCMToken());

        FCMToken fcmToken = FCMToken.builder()
                .email(tokenRequest.getEmail())
                .FCMToken(tokenRequest.getFCMToken())
                .build();

        try{
            return Header.OK(fcmcrud.insertFCMToken(fcmToken), "FCM Token Inserted");
        }
        catch (Exception e){
            return Header.ERROR("FCM Token Insert Failed");
        }

    }
    @GetMapping("/fb/getFCMToken")
    public Header<FCMToken> getFCMToken(@RequestParam String email) throws Exception {
        System.out.println(email);

        try{
            return Header.OK(fcmcrud.getFCMToken(email), "FCM Token Retrieved");
        }
        catch (Exception e){
            return Header.ERROR("FCM Token Retrieve Failed");
        }
    }

}
