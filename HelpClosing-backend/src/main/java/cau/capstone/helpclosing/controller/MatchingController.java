package cau.capstone.helpclosing.controller;

import cau.capstone.helpclosing.model.Entity.User;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.InviteRequest;
import cau.capstone.helpclosing.model.Request.InviteToExistRequest;
import cau.capstone.helpclosing.model.Request.MatchingAcceptRequest;
import cau.capstone.helpclosing.model.Request.MatchingRejectRequest;
import cau.capstone.helpclosing.model.Response.InvitationListResponse;
import cau.capstone.helpclosing.model.Response.PossibleInvitationList;
import cau.capstone.helpclosing.service.MatchingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

@RestController
public class MatchingController {
    @Autowired
    private MatchingService matchingService;

    @PostMapping("/matching")
    //@ApiOperation(value= "Add friends", notes = "")
    public Header invite(@RequestBody InviteRequest inviteRequest){
        try{
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.invite(email, inviteRequest), "");
        } catch (Exception e){
            return Header.ERROR("Need to login for matching");
        }
    }

    @PostMapping("/invite")
    //@ApiOperation(value="그룹 안에서 초대", notes = "receiver(email), chatRoomId 필요")
    public Header InviteToExistMatching(@RequestBody InviteToExistRequest inviteToExistRequest){
        try{
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.inviteToExist(email, inviteToExistRequest));
        }
        catch (Exception e){
            return Header.ERROR("Need to login for inviting");
        }
    }

    @GetMapping("/possibleinvite")
    //@ApiOperation(value="그룹에 초대 가능한 user목록 출력", notes = "초대 그룹 id 필요")
    public Header<PossibleInvitationList> possibleInvite(Long chatRoomId){
        try{
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.possibleInvite(chatRoomId),"");
        }
        catch (Exception e){
            return Header.ERROR("Need to login for seeing possible user for invitation" + e);
        }
    }

    @GetMapping("/invitedList")
    //@ApiOperation(value="초대 받은 목록(invitation) 보기", notes = "")
    public Header<InvitationListResponse> inviteList(){
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String email = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.inviteList(email), "");
        }
        catch (Exception e){
            return Header.ERROR("Need to login for seeing invitedList");
        }
    }

    @PostMapping("/accept")
    //@ApiOperation(value="초대 수락", notes ="sender email, chatRoomId: null일 경우 0으로 줘야함.")
    public Header accept(@RequestBody MatchingAcceptRequest matchingAcceptRequest){
        try{
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String receiver = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.accept(matchingAcceptRequest, receiver), "");
        }
        catch(Exception e){
            return Header.ERROR(("Need to login for accepting matching" + e));
        }
    }

    @DeleteMapping("/reject")
    // @ApiOperation(value = "초대 거절", notes = "sender email, roomid: null일 경우 0으로 줘야함. ")
    public Header reject(@RequestBody MatchingRejectRequest matchingRejectRequest){
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String receiver = ((User) auth.getPrincipal()).getUsername();

            return Header.OK(matchingService.reject(matchingRejectRequest, receiver), "");
        }
        catch (Exception e){
            return Header.ERROR("Need to login for rejecting matching");
        }
    }
}
