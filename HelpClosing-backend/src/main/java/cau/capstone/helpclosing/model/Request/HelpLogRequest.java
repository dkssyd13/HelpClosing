package cau.capstone.helpclosing.model.Request;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HelpLogRequest {

    private Long requesterId;
    private Long recipientId;


}
