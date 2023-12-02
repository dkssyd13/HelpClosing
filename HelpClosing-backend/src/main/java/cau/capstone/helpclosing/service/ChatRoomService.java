package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Entity.Matching;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Request.ChatRoomRequest;
import cau.capstone.helpclosing.model.Response.ChatRoomListResponse;
import cau.capstone.helpclosing.model.Response.UserMailandName;
import cau.capstone.helpclosing.model.repository.ChatMessageRepository;
import cau.capstone.helpclosing.model.repository.ChatRoomRepository;
import cau.capstone.helpclosing.model.repository.MatchingRepository;
import cau.capstone.helpclosing.model.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Autowired
    ChatMessageRepository chatMessageRepository;

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

                List<User> userList = new ArrayList<>();

//                List<UserMailandName> userList = new ArrayList<>();
                if(!sameChatRoom.isEmpty()){
                    for (Matching s : sameChatRoom){
                        userList.add(userRepository.findByUserId(s.getUser().getUserId()));
                    }
                    roomList.add(ChatRoomListResponse.builder()
                            .chatRoomId(r.getChatRoomId())
                            .users(userList)
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

    @Transactional
    public String exitChatRoom(String userEmail, Long chatRoomId){

        try{
            ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomId);
            User user = userRepository.findByEmail(userEmail);
            Matching matching = matchingRepository.findByChatRoomAndUser(chatRoom, user);

            if (matching != null){
                chatMessageRepository.deleteAllByChatRoom(chatRoom);
                matchingRepository.deleteByChatRoom(chatRoom);
                chatRoomRepository.deleteByChatRoomId(chatRoomId);
            }
            else{
                return "there are not matching and chat room";
            }


        } catch (Exception e){
            System.out.println(e);
            return "eixting "+ chatRoomId.toString() + " is failed";
        }

        return "success to exit chat room" + chatRoomId.toString();
    }
}
