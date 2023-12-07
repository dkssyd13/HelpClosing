package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.aws.S3Service;
import cau.capstone.helpclosing.model.CustomException;
import cau.capstone.helpclosing.model.Entity.Authority;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Request.LoginRequest;
import cau.capstone.helpclosing.model.Request.RegisterRequest;
import cau.capstone.helpclosing.model.Request.UserProfileRequest;
import cau.capstone.helpclosing.model.Response.LoginResponse;
import cau.capstone.helpclosing.model.Response.UserProfileResponse;
import cau.capstone.helpclosing.model.repository.UserRepository;
import cau.capstone.helpclosing.security.entity.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Collections;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {


    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JwtProvider jwtProvider;

    // Assuming you have an S3Service to handle S3 interactions
    @Autowired
    private S3Service s3Service;

    public LoginResponse login(LoginRequest request) throws CustomException {
        User user = userRepository.findByEmail(request.getEmail());

        if (user == null) {
            throw new CustomException("존재하지 않는 이메일입니다.");
        }

        if(!passwordEncoder.matches(request.getPassword(), user.getPassword())){
            throw new CustomException("비밀번호가 일치하지 않습니다.");
        }

        return LoginResponse.builder()
                .email(user.getEmail())
                .userId(user.getUserId())
                .nickName(user.getNickName())
                .name(user.getName())
                .jwtToken(jwtProvider.createToken(user.getEmail(), user.getRoles()))
                .urlPledgeRequest(user.getUrlPledgeRequest())
                .urlPledgeResponse(user.getUrlPledgeResponse())
                .build();
    }


    public boolean register(RegisterRequest request) throws CustomException{
        if(!emailCheck(request.getEmail())){
            throw new CustomException("이미 존재하는 이메일입니다.");
        }
        if(!nicknameCheck(request.getNickName())){
            throw new CustomException("이미 존재하는 닉네임입니다.");
        }
        if(!request.getPassword().equals(request.getConfirmPw())){
            throw new CustomException("비밀번호가 일치하지 않습니다.");
        }

        try{
            User user = User.builder()
                    .email(request.getEmail())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .name(request.getName())
                    .nickName(request.getNickName())
                    .build();

            user.setRoles(Collections.singletonList(Authority.builder().name("ROLE_USER").build()));
            userRepository.save(user);

        } catch (Exception e){
            System.out.println(e.getMessage());
            throw new CustomException("회원가입 실패");
        }
        return true;
    }


    public String uploadImageToS3(MultipartFile imageFile) throws IOException {
        // Logic to upload image to S3 and get URL
        String imageUrl = s3Service.saveFile(imageFile); // Implement this method in S3Service

        return imageUrl;
    }

    public void saveUrlPledgeRequestToUser(String userEmail, String imageUrl) throws CustomException {
        User user = userRepository.findByEmail(userEmail);

        if(user == null){
            throw new CustomException("존재하지 않는 이메일입니다.");
        }
        else{
            user.setUrlPledgeRequest(imageUrl);
            userRepository.save(user);
        }
    }


    public void saveUrlPledgeResponseToUser(String userEmail, String imageUrl) throws CustomException {
        User user = userRepository.findByEmail(userEmail);

        if(user == null){
            throw new CustomException("존재하지 않는 이메일입니다.");
        }
        else{
            user.setUrlPledgeResponse(imageUrl);
            userRepository.save(user);
        }
    }

    public LoginResponse getUser(String email) throws CustomException{
        User user = userRepository.findByEmail(email);

        if(user == null){
            throw new CustomException("존재하지 않는 이메일입니다.");
        }

        return LoginResponse.builder()
                .email(user.getEmail())
                .userId(user.getUserId())
                .nickName(user.getNickName())
                .name(user.getName())
                .jwtToken(jwtProvider.createToken(user.getEmail(), user.getRoles()))
                .urlPledgeRequest(user.getUrlPledgeRequest())
                .urlPledgeResponse(user.getUrlPledgeResponse())
                .build();
    }

    public boolean emailCheck(String email){
        User findUser = userRepository.findByEmail(email);

        if(findUser != null){ // 이미존재하는 email
            return false;
        }
        return true;
    }

    public boolean nicknameCheck(String nickname) {

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
//                .image(user.getImage())
                .build();
    }

    public UserProfileResponse update(String email,
                                      UserProfileRequest userProfileRequest) {
        User user = userRepository.findByEmail(email);

        user.setNickName(userProfileRequest.getNickName())
                .setName(userProfileRequest.getName());
//                .setImage(userProfileRequest.getImage());

        userRepository.save(user);

        return UserProfileResponse.builder()
                .email(email)
                .nickName(user.getNickName())
//                .image(user.getImage())
                .build();

    }
}
