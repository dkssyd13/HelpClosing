package cau.capstone.helpclosing.model.repository;

import cau.capstone.helpclosing.model.Entity.Invitation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InvitationRepository extends JpaRepository<Invitation, Long> {
    // 초대 목록을 보기 위한 메소드
    @Query("select u from Invitation u where u.invitedPerson = ?1")
    List<Invitation> findByInvitedPerson(String email);

    @Query("select u from Invitation u where u.invitedPerson = ?1 and u.invitePerson = ?2")
    Invitation findByInvitedPersonAndInvitePerson(String InvitedPerson, String InvitePerson);


    @Query("select u from Invitation  u where u.invitedPerson=?1 and u.chatRoomId=?2")
    Invitation findByInvitedPersonAndChatRoomId(String InvitedPerson, Long chatRoomId);

    @Query("select u from Invitation u where (u.invitedPerson = ?1 and u.invitePerson = ?2) or (u.invitedPerson = ?2 and u.invitePerson = ?1)")
    Invitation alreadyMatching(String InvitedPerson, String InvitePerson);

    @Query("select u from Invitation  u where u.invitePerson=?1 and u.chatRoomId=?2")
    Invitation findByInvitePersonAndChatRoomId(String sender, Long chatRoomId);
}
