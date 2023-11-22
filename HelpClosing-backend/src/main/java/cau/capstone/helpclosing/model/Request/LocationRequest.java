package cau.capstone.helpclosing.model.Request;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LocationRequest {

    private double latitude;

    private double longitude;

    private double distance;
}
