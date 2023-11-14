package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Request.RegisterApiRequest;
import cau.capstone.helpclosing.model.Request.UserProfileRequest;
import cau.capstone.helpclosing.model.Response.UserProfileResponse;
import cau.capstone.helpclosing.model.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    public User create(RegisterApiRequest request) {

        User user=User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .nickName(request.getNickname())
                .reported_count(0)
                .reporter_count(3)
                .build();

        return userRepository.save(user);
    }

    public boolean emailCheck(String email){
        User findUser = userRepository.findByEmail(email);

        if(findUser != null){ // 이미존재하는 email
            return false;
        }
        return true;
    }

    public static boolean nicknameCheck(String nickname) {

        User findUser= userRepository.findByNickName(nickname);

        if(findUser!=null)
            return false;
        return true;
    }

    public boolean delete(String email) {
        User user = userRepository.findByEmail(email);

        if (user != null) {
            userRepository.delete(user);
            return true;
        }
        else
            return false;
    }

    /**
     * User Profile 확인 페이지
     */
    public UserProfileResponse read(String email) {
        User user = userRepository.findByEmail(email);

        return UserProfileResponse.builder()
                .email(user.getEmail())
                .nickName(user.getNickName())
                .image(user.getImage())
                .build();
    }

    public UserProfileResponse update(String email,
                                      UserProfileRequest userProfileRequest) {
        User user = userRepository.findByEmail(email);

        user.setNickName(userProfileRequest.getNickName())
                .setName(userProfileRequest.getName())
                .setImage(userProfileRequest.getImage());

        userRepository.save(user);

        return UserProfileResponse.builder()
                .email(email)
                .nickName(user.getNickName())
                .image(user.getImage())

                .build();

    }
}
