package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.ChatMessage;
import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.ChatMessageRequest;
import cau.capstone.helpclosing.model.Response.ChatMessageResponse;
import cau.capstone.helpclosing.model.repository.ChatMessageRepository;
import cau.capstone.helpclosing.model.repository.ChatRoomRepository;
import cau.capstone.helpclosing.model.repository.UserRepository;
import cau.capstone.helpclosing.service.ChatService;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RequiredArgsConstructor
@RestController
public class ChatController {

    private final SimpMessageSendingOperations messagingTemplate;

    @Autowired
    ChatService chatService;
    @Autowired
    UserRepository userRepository;
    @Autowired
    ChatRoomRepository chatRoomRepository;
    @Autowired
    ChatMessageRepository chatMessageRepository;

    @MessageMapping("/chat/enter")
    @ApiOperation(value = "채팅방 입장", notes = "채팅방 입장시 채팅방에 입장 메시지를 보내고, DB에 저장한다.")
    public void enter(ChatMessageRequest message){
        message.setTime(LocalDateTime.now());
        User user = userRepository.findByEmail(message.getEmail());
        message.setMessage(message.getNickName() + "님이 채팅방에 참여하였습니다.");

        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(message.getChatRoomId());

        message.setNickName(user.getNickName());
        message.setName(user.getName());

        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getChatRoomId(), message);

        ChatMessage chatMessage = ChatMessage.builder()
                .message(message.getMessage())
                .chatDate(message.getTime())
                .user(user)
                .chatRoom(chatRoom)
                .build();

        chatMessageRepository.save(chatMessage);
    }

    @MessageMapping("/chat/message")
    @ApiOperation(value = "채팅 메시지", notes = "채팅방에 메시지를 보내고, DB에 저장한다.")
    public void message(ChatMessageRequest message){
        //message,chatRoom, email
        message.setTime(LocalDateTime.now());
        User user = userRepository.findByEmail(message.getEmail());

        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(message.getChatRoomId());

        message.setNickName(user.getNickName());
        message.setName(user.getName());

        messagingTemplate.convertAndSend("/pub/chat/room/" + message.getChatRoomId(), message);

        ChatMessage chatMessage = ChatMessage.builder()
                .message(message.getMessage())
                .chatDate(message.getTime())
                .user(user)
                .chatRoom(chatRoom)
                .build();

        chatMessageRepository.save(chatMessage);

    }

    @GetMapping("/chat/chatList")
    @ApiOperation(value = "채팅 목록", notes = "채팅방 목록을 조회한다.") //SWagger
    public Header<List<ChatMessageResponse>> chatList(Long chatRoomId){
        try{
            return Header.OK(chatService.chatList(chatRoomId), "chatlist for chatRoomId " + chatRoomId);
        }
        catch(Exception e){
            return Header.ERROR("chatlist Error: " + e);
        }
    }
//
//
//    @PostMapping
//    public ChatRoom createChatRoom(@RequestBody String senderId, @RequestBody String receiverId){
//        return chatService.createChatRoom(senderId + receiverId);
//    }
//
//    @PostMapping
//    public ChatRoom createChatRoom(@RequestBody ChatRoom chatRoom){
//        return chatService.createChatRoom(chatRoom);
//    }
//
//    @GetMapping("/{chatRoomId}")
//    public ChatRoom roomDetail(@PathVariable String chatRoomId, Model model){
//        ChatRoom chatRoom = chatService.findChatRoomById(chatRoomId);
//        model.addAttribute("chatRoom", chatRoom);
//        return chatRoom;
//    }
//
//    @GetMapping
//    public List<ChatRoom> findAllRoom(){
//        return chatService.findAllChatRoom();
//    }
}
