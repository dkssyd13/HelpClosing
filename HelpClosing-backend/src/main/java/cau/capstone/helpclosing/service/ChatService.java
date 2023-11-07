package cau.capstone.helpclosing.service;


import cau.capstone.helpclosing.model.Entity.ChatMessage;
import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Response.ChatMessageResponse;
import cau.capstone.helpclosing.model.repository.ChatMessageRepository;
import cau.capstone.helpclosing.model.repository.ChatRoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ChatService {

    @Autowired
    ChatRoomRepository chatRoomRepository;

    @Autowired
    ChatMessageRepository chatMessageRepository;

    public List<ChatMessageResponse> chatList(Long chatRoomId){
        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomId);

        List<ChatMessage> list = chatMessageRepository.findAllByChatRoomId(chatRoom);

        List<ChatMessageResponse> responseList = new ArrayList<>();

        for(ChatMessage c : list){
            responseList.add(ChatMessageResponse.builder()
                    .chatDate(c.getChatDate())
                    .email(c.getUser().getEmail())
                    .message(c.getMessage())
                    .nickName(c.getUser().getNickName())
                    .build());
        }
        return responseList;
    }

}
