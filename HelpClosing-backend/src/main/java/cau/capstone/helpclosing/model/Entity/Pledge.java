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
    @Column(name = "pledge_id")
    private Long pledgeId;
    private Date time;
    @Lob // Large Object
    private String content;

    //Relationship
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;


}
