package cau.capstone.helpclosing.model.Entity;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain = true)
<<<<<<< HEAD
@ToString(exclude = {"user", "userEmail"})
=======
@ToString(exclude = {"password", "matchingList"})
>>>>>>> 3ca3b45e503cd48976cbada1f1fa5d1ecf4ae4e8
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userId")
    private Long userId;

    private String email;

    private String password;

    private String name;

    private String nickName;

    private String image;

    private int reporter_count;

    private int reported_count;

    private int matchingCount;


    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    List<Matching> matchingList = new ArrayList<>();

//    @OneToMany(fetch = FetchType.LAZY, mappedBy = "userEmail")
//    List<ChatMessage> chatList = new ArrayList<>();

//    @Override
//    public Collection<? extends GrantedAuthority> getAuthorities() {
//        return null;
//    }
//
//    @Override
//    public String getUsername() {
//        return email;
//    }
//
//    @Override
//    public boolean isAccountNonExpired() {
//        return false;
//    }
//
//    @Override
//    public boolean isAccountNonLocked() {
//        return false;
//    }
//
//    @Override
//    public boolean isCredentialsNonExpired() {
//        return false;
//    }
//
//    @Override
//    public boolean isEnabled() {
//        return false;
//    }
}