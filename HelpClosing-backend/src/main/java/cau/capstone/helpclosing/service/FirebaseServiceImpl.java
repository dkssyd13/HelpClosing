//package cau.capstone.helpclosing.service;
//
//import cau.capstone.helpclosing.model.Entity.ChatRoom;
//import com.google.api.core.ApiFuture;
//import com.google.cloud.firestore.DocumentReference;
//import com.google.cloud.firestore.DocumentSnapshot;
//import com.google.cloud.firestore.Firestore;
//import com.google.cloud.firestore.WriteResult;
//import com.google.firebase.cloud.FirestoreClient;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Service;
//
//@Service
//@RequiredArgsConstructor
//public class FirebaseServiceImpl implements FirebaseService {
//    public static final String CHATROOM = "chatRoom";
//    public static final String CHATMESSAGE = "chatMessage";
//
//    @Override
//    public String insertChatRoom(ChatRoom chatRoom) throws Exception{
//        Firestore firestore = FirestoreClient.getFirestore();
//        ApiFuture<WriteResult> apiFuture = firestore.collection(CHATROOM).document(chatRoom.getChatRoomId()).set(chatRoom);
//        return apiFuture.get().getUpdateTime().toString();
//    }
//
//    @Override
//    public ChatRoom getChatRoom(String chatRoomId) throws Exception{
//        Firestore firestore = FirestoreClient.getFirestore();
//        DocumentReference documentReference = firestore.collection(CHATROOM).document(chatRoomId);
//        ApiFuture<DocumentSnapshot> apiFuture = documentReference.get();
//        DocumentSnapshot documentSnapshot = apiFuture.get();
//        ChatRoom chatRoom = null;
//        if(documentSnapshot.exists()){
//            chatRoom = documentSnapshot.toObject(ChatRoom.class);
//            return chatRoom;
//        }
//        else{
//            return null;
//        }
//    }
//
////    @Override
////    public String updateChatRoom(ChatRoom chatRoom) throws Exception{
////        Firestore firestore = FirestoreClient.getFirestore();
////        ApiFuture<WriteResult> apiFuture = firestore.collection(CHATROOM).document(chatRoom.getChatRoomId()).set(chatRoom);
////        return apiFuture.get().getUpdateTime().toString();
////    }
////
////    @Override
////    public String deleteChatRoom(String chatRoomId) throws Exception{
////        Firestore firestore = FirestoreClient.getFirestore();
////        ApiFuture<WriteResult> apiFuture = firestore.collection(CHATROOM).document(chatRoomId).delete();
////        return "Document with ChatRoom ID "+chatRoomId+" has been deleted";
////    }
//
//    @Override
//    public String insertChatMessage(String chatRoomId, String message) {
//        return null;
//    }
//
//    @Override
//    public String getChatMessage(String chatRoomId) {
//        return null;
//    }
//
//    @Override
//    public String updateChatMessage(String chatRoomId, String message) {
//        return null;
//    }
//
//    @Override
//    public String deleteChatMessage(String chatRoomId) {
//        return null;
//    }
//}
