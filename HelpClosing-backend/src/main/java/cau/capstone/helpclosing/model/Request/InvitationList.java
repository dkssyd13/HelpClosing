package cau.capstone.helpclosing.model.Request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvitationList {

    private String invitedEmail;
    private String invitedName;
    private int clossnessRank;

//    private Long chatRoomId ;

}