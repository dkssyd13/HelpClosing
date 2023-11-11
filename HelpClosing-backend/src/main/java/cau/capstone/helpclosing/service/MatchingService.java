package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.ChatRoom;
import cau.capstone.helpclosing.model.Entity.Invitation;
import cau.capstone.helpclosing.model.Entity.Matching;
import cau.capstone.helpclosing.model.Entity.User;

import cau.capstone.helpclosing.model.Request.*;
import cau.capstone.helpclosing.model.Response.InvitationListResponse;
import cau.capstone.helpclosing.model.Response.PossibleInvitationList;
import cau.capstone.helpclosing.model.Response.UserProfileResponse;
import cau.capstone.helpclosing.model.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MatchingService {


    @Autowired
    private LocationRepository locationRepository;

    @Autowired
    private InvitationRepository invitationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private MatchingRepository matchingRepository;

    @Autowired
    private ChatRoomRepository chatRoomRepository;

    //수정!!
    public String invite(String email, InviteRequest inviteRequest){
        User sender = userRepository.findByEmail(email);

        //자신 제외, 매칭할 사람 찾기
        User user = userRepository.findTop1ByDepartmentAndMajorAndLanguageAndEmailNotOrderByMatchingCountAsc(
                inviteRequest.getCollege(),
                inviteRequest.getMajor(),
                inviteRequest.getLanguage(),
                sender.getEmail());
        if (user==null) {
            return "There is no user who meets condition.";
        }

        //이미 매칭된 사람 &  초대된사람 제외
        String tmp = "";
        while (alreadyMatching(sender, user)) {
            // 기존 유저와 현재 찾은 유저 둘다 제외 할 필요있음. -> clear tmp변수에 user들 추가하면서 NotIn으로 거른다.
            tmp += user.getEmail() + " ";
            user = userRepository.findTop1ByDepartmentAndMajorAndLanguageAndEmailNotAndEmailNotInOrderByMatchingCountAsc(
                    inviteRequest.getCollege(),
                    inviteRequest.getMajor(),
                    inviteRequest.getLanguage(),
                    sender.getEmail(),
                    tmp.split(" ")
            );

        }

        if (user==null) {
            return "There is no user who meets condition.";
        }
        else {
            Invitation invitation = Invitation.builder()
                    .InvitePerson(sender.getEmail())
                    .InvitedPerson(user.getEmail())
                    .build();
            invitationRepository.save(invitation);
            return  "send inviting message to "+user.getNickName();
        }
    }

    //초대목록 return
    public InvitationListResponse inviteList(String email){
        List<Invitation> list = invitationRepository.findByInvitedPerson(email);
        List<InvitationList> invitationList = list.stream().map(invitation -> response(invitation))
                .collect(Collectors.toList());

        return InvitationListResponse.builder()
                .invitationList(invitationList)
                .build();
    }

    private InvitationList response(Invitation invitation){
        User user = userRepository.findByEmail(invitation.getInvitePerson());

        return InvitationList.builder()
                .invitePerson(invitation.getInvitePerson())
                .invitePersonImage(user.getImage())
                .invitePersonName(user.getName())
                .chatRoomId(invitation.getChatRoomId())
                .build();

    }

    //초대 수락
    public String accept(MatchingAcceptRequest matchingAcceptRequest, String receiverEmail){
        User sender = userRepository.findByEmail(matchingAcceptRequest.getSenderEmail());
        User receiver = userRepository.findByEmail(receiverEmail);

        //채팅 룸 생성
        Invitation invitation = invitationRepository.findByInvitedPersonAndInvitePerson(receiverEmail, matchingAcceptRequest.getSenderEmail());

        //새로 매칭일 경우
        if(matchingAcceptRequest.getChatRoomId() == 0L){
            ChatRoom chatRoom = ChatRoom.builder().build();
            chatRoomRepository.save(chatRoom);

            Matching senderMatching = Matching.builder()
                    .chatRoomId(chatRoom)
                    .user(sender)
                    .build();

            Matching receiverMatching = Matching.builder()
                    .chatRoomId(chatRoom)
                    .user(receiver)
                    .build();

            matchingRepository.save(senderMatching);
            matchingRepository.save(receiverMatching);
//
//            sender.setMatchingCount(sender.getMatchingCount()+1);
//            receiver.setMatchingCount(receiver.getMatchingCount()+1);

            userRepository.save(sender);
            userRepository.save(receiver);
        }
//        else{//기존 그룹 매칭일 경우 reciever만 매칭
//            ChatRoom chatRoom = chatRoomRepository.findBychatRoomId(matchingAcceptRequest.getChatRoomId());
//            Matching receiverMatching = Matching.builder()
//                    .chatRoomId(chatRoom)
//                    .user(receiver)
//                    .build();
//
//            matchingRepository.save(receiverMatching);
//
//        }

        //매칭 완료 후 초대 삭제
        invitationRepository.delete(invitation);
        return "accept invitation from "+matchingAcceptRequest.getSenderEmail();
    }

    //초대 거절
    public String reject(MatchingRejectRequest matchingRejectRequest, String receiver){
        Invitation invitation;

        //첫 매칭
        if(matchingRejectRequest.getChatRoomId()==0L){
            invitation = invitationRepository.findByInvitedPersonAndInvitePerson(receiver, matchingRejectRequest.getSender());
        }
        else{
            invitation = invitationRepository.findByInvitedPersonAndAndMachingRoomId(matchingRejectRequest.getSender(), matchingRejectRequest.getChatRoomId());
        }

        invitationRepository.delete(invitation);
        return "Reject matching";
    }

    //이미 매칭인지 확인
    public Boolean alreadyMatching(User sender, User receiver){
        if(receiver == null){
            return false;
        }
        else{
            List<Matching> list = matchingRepository.findByUser(sender);//sender가 이미 매칭된 사람들

            //이미 매칭 된 사람들 중에 receiver가 있는지 확인
            for (Matching m: list){
                if(matchingRepository.findByChatRoomIdAndUserEmail(m.getChatRoomId(), receiver.getEmail())!=null){
                    return true;
                }
            }
            //이미 초대된 사람이면 true
            Invitation invitation = invitationRepository.alreadyMatching(sender.getEmail(), receiver.getEmail());
            if(invitation != null && invitation.getChatRoomId() == null){
                return true;
            }
            return false;
        }
    }

    public PossibleInvitationList possibleInvite(Long chatRoomId){
        ChatRoom chatRoom = chatRoomRepository.findByChatRoomId(chatRoomId);//채팅방 찾기

        List<Matching> matchingList = matchingRepository.findByChatRoomId(chatRoom);//채팅방에 있는 매칭들
        List<String> existedList = new ArrayList<>();

        for(Matching m: matchingList){
            existedList.add(m.getUser().getEmail());
        }

        //속하지 않은 유저 찾기
        List<User> possibleUserList = userRepository.findUsersByEmailNotIn(existedList);

        System.out.println(possibleUserList);

        //이미 초대된 경우 제외
        //초대 가능한 user list return
        List<UserProfileResponse> profile = new ArrayList<>();
        for(User u: possibleUserList){
            if(u.getMatchingCount()<3&&(invitationRepository.findByInvitedPersonAndAndMatchingRoomId(u.getEmail(),chatRoomId)==null)) {
                profile.add(UserProfileResponse.builder().image(u.getImage())
                        .name(u.getName())
                        .email(u.getEmail()).build()
                );
            }
        }
        return PossibleInvitationList.builder().possibleProfileList(profile).build();
    }

//    public String inviteToExist(String email, InviteToExistRequest inviteToExistRequest){
//        //초대할 사람 찾기
//        User receiver = userRepository.findByEmail(inviteToExistRequest.getReciever());
//
//        //기존의 그룹에 초대
//        Invitation invitation = Invitation.builder()
//                .invitedPerson(receiver.getEmail())
//                .chatRoomId(inviteToExistRequest.getInviteRoomId())
//                .build();
//
//        invitationRepository.save(invitation);
//
//        return "Successfully send inviting message to "+ receiver.getName();
//    }
//}
