//package cau.capstone.helpclosing.util;
//
//import cau.capstone.helpclosing.model.Entity.ChatMessage;
//import cau.capstone.helpclosing.model.Entity.ChatRoom;
//import cau.capstone.helpclosing.dto.FChatRoomDTO;
//import cau.capstone.helpclosing.dto.FirestoreDTO;
//import cau.capstone.helpclosing.service.ChatServiceImpl;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.google.api.core.ApiFuture;
//import com.google.cloud.firestore.DocumentReference;
//import com.google.cloud.firestore.Firestore;
//import com.google.firebase.cloud.FirestoreClient;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.stereotype.Component;
//import org.springframework.web.socket.CloseStatus;
//import org.springframework.web.socket.TextMessage;
//import org.springframework.web.socket.WebSocketSession;
//import org.springframework.web.socket.handler.TextWebSocketHandler;
//
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.Map;
//
//@Slf4j
//@RequiredArgsConstructor
//@Component
//public class WebSocketHandler extends TextWebSocketHandler {
//
//
//    private final ObjectMapper objectMapper;
//    private final ChatServiceImpl chatService;
//
//    //firestore에서 chat collection을 사용
//    private static final String CHAT_COLLECTION = "chat";
//
//    //채팅방목록
//    private Map<String, ArrayList<WebSocketSession>> chatRoomList = new HashMap<>();
//    //session, 방 번호
//    private Map<WebSocketSession, String> sessionList = new HashMap<>();
//
//    private static int i;
//
//    /**
//     * 웹소켓 연결 성공 시
//     */
//    @Override
//    public void afterConnectionEstablished(WebSocketSession session) throws Exception{
//        i++;
//        System.out.println(session.getId() + " 연결 성공 => 총 접속 인원 : " + i);
//    }
//
//    /**
//     * 웹소켓 연결 해제 시
//     */
//    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
//        i--;
//        System.out.println(session.getId() + " 연결 종료 => 총 접속 인원 : " + i);
//        //SeesionList에 session이 있다면
//        if(sessionList.get(session) != null){
//            // 해당 session의 방 번호를 가져와서, 방을 찾고, 그 방의 ArrayList<session>에서 해당 session을 지운다.
//            chatRoomList.get(sessionList.get(session)).remove(session);
//            sessionList.remove(session);
//        }
//    }
//
//    @Override
//    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception{
//        String payload = message.getPayload();
//        log.info("{}", payload);
//        // Json객체 → Java객체
//        // 출력값 :
//        ChatMessage chatMessage = objectMapper.readValue(payload, ChatMessage.class);
//        //메세지의 roomid로 방을 찾음
//        ChatRoom chatRoom = chatService.findChatRoomById(chatMessage.getChatRoomId());
//
//        //채팅 세션 목록에 채팅방이 존재하지 않고, 처음 들어왔고, DB에서의 채팅방이 있을 때
//        //채팅방 생성
//        if(chatRoomList.get(chatRoom.getChatRoomId()) == null && chatMessage.getMessage().equals("ENTER_CHAT") && chatRoom != null){
//            //채팅방에 들어간 세션들
//            ArrayList<WebSocketSession> sessionTwo = new ArrayList<>();
//            sessionTwo.add(session);
//            sessionList.put(session, chatRoom.getChatRoomId());
//            chatRoomList.put(chatRoom.getChatRoomId(), sessionTwo);
//            //정상적으로 생성
//            System.out.println("채팅방 생성");
//
//            //파이어베이스에 채팅방을 저장
//            FChatRoomDTO firebaseDTO = new FChatRoomDTO(chatRoom);
//            Firestore firestore = FirestoreClient.getFirestore();
//            ApiFuture<DocumentReference> add = firestore.collection(CHAT_COLLECTION).add(firebaseDTO);
//            System.out.println(add.get().toString());
//        }
//        //채팅방이 존재할 때
//        else if(chatRoomList.get(chatRoom.getChatRoomId()) != null && !chatMessage.getMessage().equals("ENTER_CHAT") && chatRoom != null){
//            chatRoomList.get(chatRoom.getChatRoomId()).add(session);
//            sessionList.put(session, chatRoom.getChatRoomId());
//            System.out.println("채팅방 입장");
//        }
//        //채팅 메시지 입력시
//        else if (chatRoomList.get(chatRoom.getChatRoomId()) != null && !chatMessage.getMessage().equals("ENTER_CHAT") && chatRoom != null){
//            TextMessage textMessage = new TextMessage(chatMessage.getName() + "," + chatMessage.getEmail() + "," + chatMessage.getMessage());
//
//            int sessionCount = 0;
//
//            //채팅방의 session들에게 메시지 줌
//            for(WebSocketSession sess : chatRoomList.get(chatRoom.getChatRoomId())){
//                sess.sendMessage(textMessage);
////                sessionCount++;
//            }
//
////            // 동적쿼리에서 사용할 sessionCount 저장
////            // sessionCount == 2 일 때는 unReadCount = 0,
////            // sessionCount == 1 일 때는 unReadCount = 1
////            chatMessage.setSessionCount(sessionCount);
////
////            // DB에 저장한다.
////            int a = cService.insertMessage(chatMessage);
////
////            if(a == 1) {
////                System.out.println("메세지 전송 및 DB 저장 성공");
////            }else {
////                System.out.println("메세지 전송 실패!!! & DB 저장 실패!!");
////            }
//            //firestore에 저장
//            FirestoreDTO firebaseDTO = new FirestoreDTO(chatMessage.getChatRoomId(), chatMessage.getMembers(), chatMessage.getMessage());
//            Firestore firestore = FirestoreClient.getFirestore();
//            ApiFuture<DocumentReference> add = firestore.collection(CHAT_COLLECTION).add(firebaseDTO);
//            System.out.println(add.get().toString());
//        }
//    }
//
//
//}
