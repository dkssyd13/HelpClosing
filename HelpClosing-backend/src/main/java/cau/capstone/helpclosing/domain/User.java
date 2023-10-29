package cau.capstone.helpclosing.domain;

import javax.persistence.*;
import java.util.List;

@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long id;
    private String name;
    private String email;
    private String nickname;
    private String profile;

    //Relationship
    @OneToMany(mappedBy = "author")
    private List<Pledge> pledges;

    @OneToMany(mappedBy = "requester")
    private List<HelpLog> helpRequests;

    @OneToMany(mappedBy = "recipient")
    private List<HelpLog> helpResponses;

    //Constructor
    public User() {
    }
    public User(String name, String email, String nickname, String profile) {
        this.name = name;
        this.email = email;
        this.nickname = nickname;
        this.profile = profile;
    }



    //Getter and Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getProfile() {
        return profile;
    }

    public void setProfile(String profile) {
        this.profile = profile;
    }
}
