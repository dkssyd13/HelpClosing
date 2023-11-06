package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.ChatRoom;

public interface FirebaseService {

    public String insertChatRoom(ChatRoom chatRoom);
    public ChatRoom getChatRoom(String chatRoomId);
    public String updateChatRoom(ChatRoom chatRoom);
    public String deleteChatRoom(String chatRoomId);

    public String insertChatMessage(String chatRoomId, String message);
    public String getChatMessage(String chatRoomId);
    public String updateChatMessage(String chatRoomId, String message);
    public String deleteChatMessage(String chatRoomId);


}
