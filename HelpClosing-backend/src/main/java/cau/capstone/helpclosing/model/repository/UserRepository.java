package cau.capstone.helpclosing.model.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import cau.capstone.helpclosing.model.Entity.User;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);

    User findByUserId(Long id);

    @Query(value = "SELECT u FROM User u WHERE u.name = ?1")
    User findByName(String name);

    List<User> findUsersByEmailNotIn(List<String> existedList);

    User findByNickName(String nickname);

}
