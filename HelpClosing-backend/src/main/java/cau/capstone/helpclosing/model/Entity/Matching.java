package cau.capstone.helpclosing.model.Entity;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain = true)
@ToString(exclude = {"user", "chatRoomId"})
public class Matching {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long mathcingId;

    @ManyToOne
    private User user;

    @ManyToOne
    private ChatRoom chatRoomId;
}
