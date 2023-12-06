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

import javax.persistence.EntityNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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

    public String update(Long chatRoomId){
        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomId);

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

    public boolean getChatRoomStatus(Long chatRoomId){
        Optional<ChatRoom> optionalChatRoom = chatRoomRepository.findById(chatRoomId);
        if (optionalChatRoom.isPresent()) {
            ChatRoom chatRoom = optionalChatRoom.get();
            return chatRoom.isDone();
        } else {
            throw new EntityNotFoundException("ChatRoom not found with id: " + chatRoomId);
        }
    }

    public String doneChatRoom(Long chatRoomId){
        try{
            ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomId);
            chatRoom.setDone(true);
            chatRoomRepository.save(chatRoom);
        } catch (Exception e){
            System.out.println(e);
            return "done "+ chatRoomId.toString() + " is failed";
        }
        return "success to done chat room" + chatRoomId.toString();
    }
}
