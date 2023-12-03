package cau.capstone.helpclosing.model.repository;

import cau.capstone.helpclosing.model.Entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom,Long> {
    ChatRoom findByChatRoomId(Long chatRoomId);

    void deleteByChatRoomId(Long chatRoomId);
}
