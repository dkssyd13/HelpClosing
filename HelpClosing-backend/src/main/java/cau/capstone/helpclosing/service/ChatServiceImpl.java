//package cau.capstone.helpclosing.service;
//
//import cau.capstone.helpclosing.Entity.ChatMessage;
//import cau.capstone.helpclosing.Entity.ChatRoom;
//import cau.capstone.helpclosing.dto.FChatRoomDTO;
//import cau.capstone.helpclosing.repository.ChatMessageRepository;
//import cau.capstone.helpclosing.repository.ChatRoomRepository;
//import cau.capstone.helpclosing.repository.UserRepository;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.google.gson.Gson;
//import com.google.gson.GsonBuilder;
//import com.google.gson.JsonIOException;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Service;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//import org.springframework.web.socket.TextMessage;
//import org.springframework.web.socket.WebSocketSession;
//
//import javax.annotation.PostConstruct;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.util.*;
//
//@Slf4j
//@RequiredArgsConstructor
//@Service
//public class ChatServiceImpl {
//    private final ObjectMapper objectMapper;
//    private Map<String, ChatRoom> chatRooms;
//
//    private final UserRepository userRepository;
//    private final ChatMessageRepository chatMessageRepository;
//    private final ChatRoomRepository chatRoomRepository;
//
//    @PostConstruct
//    private void init(){
//        chatRooms = new LinkedHashMap<>();
//    }
//
//    public List<ChatRoom> findAllChatRoom(){
//        return new ArrayList<>(chatRooms.values());
//    }
//
//    public ChatRoom findChatRoomById(String chatRoomId){
//        return chatRooms.get(chatRoomId);
//    }
//
//
//
//    public ChatRoom createChatRoom(ChatRoom chatRoom){
//        String randomId = UUID.randomUUID().toString();
//
//        ChatRoom chatRoom2 = ChatRoom.builder()
//            .chatRoomId(randomId)
//            .build();
//
//
//        chatRoomRepository.save(chatRoom);
//        FChatRoomDTO fChatRoomDTO = new FChatRoomDTO(chatRoom);
//
//        return chatRoom;
//    }
//
//
//    public ChatRoom createChatRoom(String name){
//        String randomId = UUID.randomUUID().toString();
//
//        ChatRoom chatRoom = ChatRoom.builder()
//                .chatRoomId(randomId)
//                .name(name)
//                .build();
//        chatRooms.put(randomId, chatRoom);
//
//        chatRoomRepository.save(chatRoom);
//
//        return chatRoom;
//    }
//
//    public ChatRoom createChatRoom(String senderId, String receiverId){
//        String randomId = UUID.randomUUID().toString();
//
//        User sender = userRepository.findByUserId(senderId).orElseThrow();
//        User recipient = userRepository.findByUserId(receiverId).orElseThrow();
//
//        ChatRoom chatRoom = ChatRoom.builder()
//                .chatRoomId(randomId)
//                .build();
//
//        chatRooms.put(randomId, chatRoom);
//
//        chatRoomRepository.save(chatRoom);
//
//        return chatRoom;
//    }
//
//    public <T> void sendMessage(WebSocketSession session, T message){
//        try{
//            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
//        }catch(IOException e){
//            log.error(e.getMessage(), e);
//        }
//    }
//
//
//    /**
//     * 채팅방의 채팅 메세지 불러오기
//     * @param senderId
//     * @param receiverId
//     * @return
//     */
//    @RequestMapping(value="{roomId}.do")
//    public void messageList(@PathVariable String romId, String userEmail, Model model, HttpServletResponse response) throws JsonIOException, IOException{
//        List<ChatMessage> mList = chatService.messageList(roomId);
//        response.setContentType("application/json; charset=utf-8");
//
//        //안 읽은 메세지의 숫자 0으로 바꾸기
//        ChatMessage message = new ChatMessage();
//        message.setEmail(userEmail);
//        message.setChatRoomId(roomId);
//        chatService.updateCount(message);
//
//        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
//        gson.toJson(mList, response.getWriter());
//
//    }
//
//    /**채팅방 생성
//     * @param senderId
//     * @param receiverId
//     * @return
//     */
//    @ResponseBody
//    @RequestMapping("createChatRoom.do")
//    public String createChatRoom(ChatRoom room, String userName, String userEmail, String masterNickname){
//
//        //
//        room.setUserEmail(userEmail);
//        room.setUserName(userName);
//
//        ChatRoom exist = chatService.searchChatRoom(room);
//
//        //DB에 방이 없는 경우
//        if(exist == null){
//            //방 생성
//            System.out.println("방 없음");
//            int result = chatService.createChatRoom(room);
//            if (result == 1){
//                System.out.println("방 생성 성공");
//                return "new";
//            }else{
//                return "fail";
//            }
//        }
//        else{
//            System.out.println("방 있음");
//            return "exist";
//        }
//    }
//
//    /**채팅방 목록 불러오기
//     */
//    @RequestMapping("chatRoomList.do")
//    public void createChat(ChatRoom room, ChatMessage message, String userEmail, HttpServletResponse response ) throws JsonIOException, IOException{
//        List<ChatRoom> chatRoomList = chatService.chatRoomList(userEmail);
//
//        for(int i=0; i<chatRoomList.size(); i++){
//            message.setChatRoomId(chatRoomList.get(i).getChatRoomId());
//            message.setEmail(userEmail);
//            int count = chatService.selectUnReadCount(message);
//            chatRoomList.get(i).setUnReadCount(count);
//
//            response.setContentType("application/json; charset=utf-8");
//
//            Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
//            gson.toJson(chatRoomList, response.getWriter());
//        }
//    }
//
//    @RequestMapping("chatSession.do")
//    public void chatSession(HttpServletResponse response) throws JsonIOException, IOException{
//        ArrayList<String> chatSessionList = chatSession.getLoginUserList();
//        response.setContentType("application/json; charset=utf-8");
//
//        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
//        gson.toJson(chatSessionList, response.getWriter());
//    }
//
//}
