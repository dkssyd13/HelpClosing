package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Entity.Matching;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Request.ChatRoomRequest;
import cau.capstone.helpclosing.model.Response.ChatRoomListResponse;
import cau.capstone.helpclosing.model.Response.UserMailandName;
import cau.capstone.helpclosing.model.repository.ChatRoomRepository;
import cau.capstone.helpclosing.model.repository.MatchingRepository;
import cau.capstone.helpclosing.model.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ChatRoomService {

    @Autowired
    ChatRoomRepository chatRoomRepository;

    @Autowired
    MatchingRepository matchingRepository;

    @Autowired
    UserRepository userRepository;

    //사용자의 채팅 방 목록 가져오기
    public List<ChatRoomListResponse> roomList(String email){
        User user = userRepository.findByEmail(email);
        List<Matching> matchingList = matchingRepository.findByUser(user);
        List<ChatRoomListResponse> roomList = new ArrayList<>();

        if(!matchingList.isEmpty()){
            System.out.println("matchingList is not empty");
            for (Matching m : matchingList){
                ChatRoom r = m.getChatRoom();
                List<Matching> sameChatRoom = matchingRepository.findByChatRoom(r);

                List<UserMailandName> userList = new ArrayList<>();
                if(!sameChatRoom.isEmpty()){
                    for (Matching s : sameChatRoom){
                        userList.add(UserMailandName.builder()
                                .email(s.getUser().getEmail())
                                .name(s.getUser().getName())
                                .build());
                    }
                    roomList.add(ChatRoomListResponse.builder()
                            .chatRoomId(r.getChatRoomId())
                            .userList(userList)
                            .build());
                }
            }
        }
        else{
            System.out.println("matchingList is empty");
        }
        return roomList;
    }

    public String update(ChatRoomRequest chatRoomRequest){
        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomRequest.getChatRoomId());

        chatRoomRepository.save(chatRoom);

        return "success";
    }
}
