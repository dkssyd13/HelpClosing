package cau.capstone.helpclosing.dto;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@NoArgsConstructor
public class RequestDTO {
    private String targetToken;  //ID of the device to send the message to
    private String title;
    private String body;

    @JsonCreator
    private RequestDTO(@JsonProperty("targetToken") String targetToken,@JsonProperty("title") String title,@JsonProperty("body") String body) {
        this.targetToken = targetToken;
        this.title = title;
        this.body = body;
    }

}
