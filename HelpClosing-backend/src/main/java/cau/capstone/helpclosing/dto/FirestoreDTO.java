package cau.capstone.helpclosing.dto;


import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class FirestoreDTO {
    private String chatRoomId;
    private String sender;
    private String message;

    @JsonCreator
    public FirestoreDTO(@JsonProperty("chatRoomId") String chatRoomId, @JsonProperty("sender") List<String> members, @JsonProperty("message") String message) {
        this.chatRoomId = chatRoomId;
        this.sender = sender;
        this.message = message;
    }
}
