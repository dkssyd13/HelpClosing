package cau.capstone.helpclosing.FCM;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.common.net.HttpHeaders;
import com.google.firebase.messaging.FirebaseMessaging;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.google.gson.JsonParseException;
import lombok.RequiredArgsConstructor;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;


import java.io.IOException;
import java.util.List;


@Component
@RequiredArgsConstructor
public class FCMService {

    private final String API_URL = "https://fcm.googleapis.com/v1/projects/cpastone-cau-helpclosing/messages:send";
    private final ObjectMapper objectMapper;
    @Autowired
    private final FirebaseMessaging firebaseMessaging;

    @Autowired
    private final FCMCRUD fcmcrud;

    public void sendPushNotification(String token, String title, String body) throws JsonProcessingException {
        Message message = makeMessage2(token, title, body);

        try {
            String response = firebaseMessaging.send(message);
            // 푸시 메시지 전송 후 반환된 응답 처리
            System.out.println("Successfully sent message: " + response);
        } catch (FirebaseMessagingException e) {
            // FirebaseMessagingException 발생 시 예외 처리
            System.err.println("Error sending message: " + e.getMessage());
        }
    }

    public Message makeMessage2(String token, String title, String body) {
        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(body)
                .build();

        // Create the message with the token and notification
        return Message.builder()
                .setToken(token)
                .setNotification(notification)
                .build();
    }

    public Response sendMessageTo(String targetToken, String title, String body) throws IOException {
        String message = makeMessage(targetToken, title, body);

        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(API_URL)
                .post(requestBody)
                .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
                .build();

        Response response = client.newCall(request).execute();


        return response;
    }

    private String makeMessage(String targetToken, String title, String body) throws JsonProcessingException{
        FcmMessage fcmMessage = FcmMessage.builder()
                .message(FcmMessage.Message.builder()
                        .token(targetToken)
                        .notification(FcmMessage.Notification.builder()
                                .title(title)
                                .body(body)
                                .build()
                        ).build()).validateOnly(false).build(); //false로 해야 실제로 메시지가 전송됨

        return objectMapper.writeValueAsString(fcmMessage);
    }


    // Firebase Admin SDK를 사용하여 Access Token을 받아옴
    //oath2를 이용해 인증
    //FCM Token: FCM을 사용하기 위해 앱을 등록할 때 발급받는 토큰, access token과는 다름
    // Access Token: Firebase Admin SDK를 사용하여 FCM에 접근할 때 필요한 인증 토큰
    //전송하는데 필요한 토큰은 별도!
    private String getAccessToken() throws IOException{
        String firebaseConfigPath = "firebase/serviceAccountKey.json";

        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }

}
