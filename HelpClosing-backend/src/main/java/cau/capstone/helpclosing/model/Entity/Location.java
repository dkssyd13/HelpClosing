package cau.capstone.helpclosing.model.Entity;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Type;
import org.locationtech.jts.geom.Point;

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
//    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long id;

    private String description;

    @Type(type = "org.hibernate.spatial.JTSGeometryType")
    private Point coordinates;

//    private double latitude;
//    private double longitude;
    private String address;

    //Relationship
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;


}
