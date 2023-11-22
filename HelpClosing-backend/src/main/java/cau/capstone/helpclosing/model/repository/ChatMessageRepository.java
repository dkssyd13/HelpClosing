package cau.capstone.helpclosing.model.repository;

import cau.capstone.helpclosing.model.Entity.ChatMessage;
import cau.capstone.helpclosing.model.Entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage,Long> {
    List<ChatMessage> findAllByChatRoom(ChatRoom chatRoomId);

}
