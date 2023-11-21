package cau.capstone.helpclosing.model.Entity;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Type;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.io.WKTReader;

import javax.persistence.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain = true)
@ToString(exclude = {"user", "userEmail"})
public class Location {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long locationId;

    private String description;
    private Point coordinates;

    private double latitude;
    private double longitude;

    private String address;

    //Relationship
    @OneToOne
    @JoinColumn(name = "user")
    private User user;

    public Location(double degree, double degree1) {
        this.latitude = degree;
        this.longitude = degree1;
    }
}
