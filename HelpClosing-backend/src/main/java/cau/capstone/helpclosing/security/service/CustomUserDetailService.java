package cau.capstone.helpclosing.security.service;

import cau.capstone.helpclosing.model.repository.UserRepository;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

/**
 * DB에서 UserDetail을 얻어와 AuthenticationManager에게
 * 제공하는 역할
 */

@Service
public class CustomUserDetailService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @SneakyThrows
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        cau.capstone.helpclosing.model.Entity.User user = userRepository.findByEmail(email);

        if(user == null) {
            throw new Exception("해당 유저를 찾지 못했습니다.");
        }

        // email로 user객체를 찾고 유저의 이메일과 비밀번호를 가진 UserDetail객체 리턴
        return new org.springframework.security.core.userdetails.User(user.getName(), user.getPassword(), new ArrayList<>());

    }

}
