package cau.capstone.helpclosing.model.Entity;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain=true)
@ToString
public class HelpLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long id;

    //시간은 도움 요청이 받아들여진 시간이 해당
    private LocalDateTime time;

    //Relationship
    @ManyToOne
    @JoinColumn(name = "requester")
    private User requester;

    @ManyToOne
    @JoinColumn(name = "recipient")
    private User recipient;


    @ManyToOne
    @JoinColumn(name = "location")
    private Location location;

}
