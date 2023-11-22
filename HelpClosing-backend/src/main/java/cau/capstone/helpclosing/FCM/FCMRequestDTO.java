package cau.capstone.helpclosing.FCM;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FCMRequestDTO {
    private String targetToken;  //ID of the device to send the message to
    private String title;
    private String body;
    //private String image;

    @JsonCreator
    private FCMRequestDTO(@JsonProperty("targetToken") String targetToken, @JsonProperty("title") String title, @JsonProperty("body") String body) {
        this.targetToken = targetToken;
        this.title = title;
        this.body = body;
    }

}
