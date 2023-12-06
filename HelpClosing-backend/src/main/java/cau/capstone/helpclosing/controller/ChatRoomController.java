package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.ChatRoomRequest;
import cau.capstone.helpclosing.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class ChatRoomController {

    @Autowired
    private ChatRoomService chatRoomService;



    //@ApiOperation(value = "사용자의 채팅룸 목록 조회")
    @GetMapping("/chatRoom/chatRoomList")
    @CrossOrigin(origins="*", maxAge=3600)
    public Header chatRoomList(@RequestParam String email){

            return Header.OK(chatRoomService.roomList(email), "매칭룸목록(roomid)");

    }



    //@ApiOperation(value="매칭룸 정보 수정")
    @PostMapping("/chatRoom/updateRoom")
    public Header updateChatRoom(@RequestParam Long chatRoomId){
        try{
            return Header.OK(chatRoomService.update(chatRoomId),"");
        }
        catch(Exception e){
            return Header.ERROR("update chat room error: "+e);
        }
    }

    @DeleteMapping("/chatRoom/exit")
    public Header exitChatRoom(@RequestParam String userEmail, @RequestParam Long chatRoomId){
        try{
            return Header.OK(chatRoomService.exitChatRoom(userEmail, chatRoomId),"");
        }
        catch(Exception e){
            return Header.ERROR("exit chat room error: "+e);
        }
    }

    @PutMapping("/chatRoom/{chatRoomId}/done")
    public Header doneChatRoom(@PathVariable Long chatRoomId){
        try{
            return Header.OK(chatRoomService.doneChatRoom(chatRoomId),"helping is done");
        }
        catch(Exception e){
            return Header.ERROR("done chat room error: "+e);
        }
    }

    @GetMapping("/chatRoom/{chatRoomId}/status")
    public ResponseEntity<Boolean> getChatRoomStatus(@PathVariable Long chatRoomId){
        boolean status = chatRoomService.getChatRoomStatus(chatRoomId);
        return ResponseEntity.ok(status);
    }
}
