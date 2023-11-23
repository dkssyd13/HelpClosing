package cau.capstone.helpclosing.FCM;

import cau.capstone.helpclosing.FCM.FCMRequestDTO;
import cau.capstone.helpclosing.FCM.FCMService;
import cau.capstone.helpclosing.model.Header;
import com.google.api.client.auth.oauth2.TokenRequest;
import lombok.RequiredArgsConstructor;
import okhttp3.Response;
import org.springframework.http.HttpStatus;
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
//        System.out.println(FCMRequestDTO.getTargetToken() + " " + FCMRequestDTO.getTitle() + " " + FCMRequestDTO.getBody());

        FCMResponseDTO fcmResponseDTO = new FCMResponseDTO();

        try{
            Response response = fcmService.sendMessageTo(
                    FCMRequestDTO.getTargetToken(),
                    FCMRequestDTO.getTitle(),
                    FCMRequestDTO.getBody());

            if (response.isSuccessful()) {
                fcmResponseDTO.setResponse("Message sent successfully");
                return ResponseEntity.ok(fcmResponseDTO);
            } else {
                fcmResponseDTO.setResponse("Failed to send message");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(fcmResponseDTO);
            }
        }
        catch (Exception e){
            fcmResponseDTO.setResponse("Error: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(fcmResponseDTO);
        }

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
