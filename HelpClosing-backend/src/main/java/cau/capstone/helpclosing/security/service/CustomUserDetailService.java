package cau.capstone.helpclosing.security.service;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.repository.UserRepository;
import cau.capstone.helpclosing.security.entity.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
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
@RequiredArgsConstructor
public class CustomUserDetailService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;
    
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        
        User user = userRepository.findByEmail(email);

        if(user == null){
            throw new UsernameNotFoundException("이메일 없음");
        }

        return new CustomUserDetails(user);
    }

}
