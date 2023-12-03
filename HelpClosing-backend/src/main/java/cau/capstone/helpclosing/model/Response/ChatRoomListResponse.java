package cau.capstone.helpclosing.model.Response;

import cau.capstone.helpclosing.model.Entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatRoomListResponse {

    private Long chatRoomId;
    private List<User> users;

//    private List<UserMailandName> userList;


}