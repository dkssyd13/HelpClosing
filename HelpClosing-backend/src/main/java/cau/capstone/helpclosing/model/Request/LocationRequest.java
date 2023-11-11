package cau.capstone.helpclosing.model.Request;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LocationRequest {

    private String userEmail;

    private double latitude;
    private double longitude;
}
