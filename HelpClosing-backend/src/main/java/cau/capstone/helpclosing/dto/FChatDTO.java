package cau.capstone.helpclosing.dto;


import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FChatDTO {
    private String chatRoomId;
    private String sender;
    private String message;

    @JsonCreator
    private FChatDTO(String chatRoomId, String sender, String message) {
        this.chatRoomId = chatRoomId;
        this.sender = sender;
        this.message = message;
    }
}
