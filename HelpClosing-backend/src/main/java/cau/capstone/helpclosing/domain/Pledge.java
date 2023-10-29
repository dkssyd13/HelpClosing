package cau.capstone.helpclosing.domain;

import javax.persistence.*;
import java.util.Date;

@Entity
public class Pledge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long id;
    private Date time;
    @Lob // Large Object
    private String content;

    //Relationship
    @ManyToOne
    @JoinColumn(name = "author_id")
    private User author;


    //Constructor
    public Pledge() {
    }
    public Pledge(Date time, String content) {
        this.time = time;
        this.content = content;
    }


    //Getter and Setter

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
