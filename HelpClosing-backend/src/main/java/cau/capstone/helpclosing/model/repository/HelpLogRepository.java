package cau.capstone.helpclosing.model.repository;


import cau.capstone.helpclosing.model.Entity.HelpLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HelpLogRepository extends JpaRepository<HelpLog, Long> {

    List<HelpLog> findByRequester(Long requesterId);
    List<HelpLog> findByHelper(Long helperId);

    List<HelpLog> findAllByRequesterId(Long requesterId, Long helperId);

    List<HelpLog> findAllByRecipientId(Long requesterId, Long helperId);
}
