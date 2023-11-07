package cau.capstone.helpclosing.model.Response;

import cau.capstone.helpclosing.model.Request.InvitationList;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvitationListResponse {
    private List<InvitationList> invitationList;
}