package cau.capstone.helpclosing.model.Response;



import cau.capstone.helpclosing.model.Entity.User;
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
    private User requester;
    private User recipient;
}
