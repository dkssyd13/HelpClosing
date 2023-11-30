package cau.capstone.helpclosing.model.Request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InviteRequest {

    private String inviteEmail;
    private String invitedEmail;
    private int closenessRank;


//    private Long chatRoomId;

}