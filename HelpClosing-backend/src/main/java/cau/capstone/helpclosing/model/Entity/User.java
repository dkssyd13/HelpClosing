package cau.capstone.helpclosing.model.Entity;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Accessors(chain = true)
@ToString(exclude = {"user", "userEmail"})
public class User {

    @Id
    private String email;

    private String password;

    private String name;

    private String nickName;

    private String image;

    private int reporter_count;

    private int reported_count;

    private int matchingCount;


    @OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
    List<Matching> matchingList1 = new ArrayList<>();

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "userEmail")
    List<ChatMessage> chatList = new ArrayList<>();

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