package cau.capstone.helpclosing.model.Response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HelpLogResponse {

    private LocalDateTime time;
    private Long requesterId;
    private Long recipientId;
    private Long pledgeRequestId;
    private Long pledgeRecipientId;
    private Long locationId;

}
