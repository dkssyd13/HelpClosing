package cau.capstone.helpclosing.model.Entity;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain = true)
@ToString(exclude = {"chatRoomId"})
public class ChatRoom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chatRoomId;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "chatRoom")
    private List<ChatMessage> chatList = new ArrayList<>();

//
//
//    public void handleActions(WebSocketSession session, ChatMessage chatMessage, ChatServiceImpl chatService){
//        sessions.add(session);
//        sendMessage(chatMessage, chatService);
//    }
//
//    private <T> void sendMessage(T message, ChatServiceImpl chatService){
//        sessions.parallelStream()
//                .forEach(session -> chatService.sendMessage(session, message));
//    }
}
