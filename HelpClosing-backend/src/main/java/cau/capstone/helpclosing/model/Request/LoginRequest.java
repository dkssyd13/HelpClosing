package cau.capstone.helpclosing.model.Request;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginRequest {

    @ApiModelProperty(example = "test1@cau.ac.kr")
    private String email;

    private String password;
}
