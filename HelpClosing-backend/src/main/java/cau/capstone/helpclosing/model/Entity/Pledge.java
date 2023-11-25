package cau.capstone.helpclosing.model.Entity;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain=true)
public class Pledge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long pledgeId;
    private Date time;
    private String image;

    //Relationship
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;


}
