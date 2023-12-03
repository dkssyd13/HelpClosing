package cau.capstone.helpclosing.model.Response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LocationResponse {

    private String userEmail;
    private double latitude;
    private double longitude;
    private int closenessRank;

}
