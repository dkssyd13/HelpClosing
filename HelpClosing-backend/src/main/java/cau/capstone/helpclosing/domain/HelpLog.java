package cau.capstone.helpclosing.domain;


import javax.persistence.*;
import java.util.Date;

@Entity
public class HelpLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Auto Increment
    private Long id;
    private Date time;

    //Relationship
    @ManyToOne
    @JoinColumn(name = "requester_id")
    private User requester;

    @ManyToOne
    @JoinColumn(name = "recipient_id")
    private User recipient;

    @ManyToOne
    @JoinColumn(name = "pledge_id")
    private Pledge pledge;

    @ManyToOne
    @JoinColumn(name = "location_id")
    private Location location;

    //Constructor
    public HelpLog() {
    }
    public HelpLog(Date time) {
        this.time = time;
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
}
