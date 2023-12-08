package cau.capstone.helpclosing.model.Request;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LocationRegisterRequest {

    private String description;
    private double latitude;
    private double longitude;
    private String address;
    private String email;
}
