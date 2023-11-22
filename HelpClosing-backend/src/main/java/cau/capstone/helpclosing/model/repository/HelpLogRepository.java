package cau.capstone.helpclosing.model.repository;


import cau.capstone.helpclosing.model.Entity.HelpLog;
import cau.capstone.helpclosing.model.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HelpLogRepository extends JpaRepository<HelpLog, Long> {

    List<HelpLog> findByRequester(Long requesterId);

    List<HelpLog> findAllByRequester(User requester);

    List<HelpLog> findAllByRecipient(User recipient);
}
