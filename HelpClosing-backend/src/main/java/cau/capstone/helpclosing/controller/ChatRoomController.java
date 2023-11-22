package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.ChatRoomRequest;
import cau.capstone.helpclosing.service.ChatRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
public class ChatRoomController {

    @Autowired
    private ChatRoomService chatRoomService;

    //@ApiOperation(value = "사용자의 채팅룸 목록 조회")
    @GetMapping("/chatRoom/chatRoomList")
    @CrossOrigin(origins="*", maxAge=3600)
    public Header chatRoomList(){
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getEmail();

            return Header.OK(chatRoomService.roomList(email), "매칭룸목록(roomid");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for seeing chat room list");
        }
    }

    //@ApiOperation(value="매칭룸 정보 수정")
    @PostMapping("/chatRoom/updateRoom")
    public Header updateChatRoom(@RequestBody ChatRoomRequest chatRoomRequest){
        try{
            return Header.OK(chatRoomService.update(chatRoomRequest),"");
        }
        catch(Exception e){
            return Header.ERROR("update chat room error: "+e);
        }
    }
}
