package cau.capstone.helpclosing.model.repository;


import cau.capstone.helpclosing.model.Entity.Pledge;
import cau.capstone.helpclosing.model.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PledgeRepository extends JpaRepository<Pledge, Long> {

    Pledge findByPledgeId(Long pledgeId);

    Pledge findByUser(User user);
}
