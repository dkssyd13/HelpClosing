package cau.capstone.helpclosing.model.repository;


import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Entity.Matching;
import cau.capstone.helpclosing.model.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatchingRepository extends JpaRepository<Matching, Long> {

    List<Matching> findAllByUserEmail(String userEmail);
    List<Matching> findByUserEmail(String userEmail);
    List<Matching> findByUser(User user);
    List<Matching> findAllByUser(User user);
    List<Matching> findByChatRoom(ChatRoom chatRoom);
    Matching findByChatRoomAndUserEmail(ChatRoom chatRoom, String email);
}
