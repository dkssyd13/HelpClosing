package cau.capstone.helpclosing.dto;


import cau.capstone.helpclosing.model.Entity.ChatRoom;
import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FChatRoomDTO {

    private ChatRoom chatRoom;

    @JsonCreator
    public FChatRoomDTO(ChatRoom chatRoom){
        this.chatRoom = chatRoom;
    }



}
