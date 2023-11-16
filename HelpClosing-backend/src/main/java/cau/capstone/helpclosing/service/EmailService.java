package cau.capstone.helpclosing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Random;

@Service
public class EmailService {

    //MailConfig 필요 - 안함
    @Autowired
    private JavaMailSender mailSender;

    /**
     * 인증코드를 리턴
     */
    public String sendVerificationEmail(String email)
        throws MessagingException, UnsupportedEncodingException {

        StringBuffer fullEmail = new StringBuffer(email);

        String fromAddress = "helpclosing@gmail.com";   // 발신자 이메일
        String senderName = "HelpClosing"; // 발신자 이름
        String subject = "Please verify your registration"; // 메일 제목
        String content = "Dear [[name]],<br>"
                + "Please input the Code below to verify your registration:<br>"
                + "<h3>Code = [[code]]</h3>"
                + "Thank you,<br>"
                + "HelpClosing";

        // 메일 보내기 위해 필요한 객체
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, "utf-8");

        // 메일 발신자 정보(주소, 이름)와 수신자메일주소, 메일제목 담기
        helper.setFrom(fromAddress, senderName);
        helper.setTo(fullEmail.toString());
        helper.setSubject(subject);

        //랜덤코드
        Random random = new Random();
        StringBuffer buffer = new StringBuffer();
        int num = 0;

        while (buffer.length() < 6) {
            num = random.nextInt(10);
            buffer.append(num);
        }
        String randomCode = buffer.toString();

        // html 내용 replace
        content = content.replace("[[name]]", fullEmail.toString());
        content = content.replace("[[code]]", randomCode);

        // 본문 담기, true는 html 형식으로 보내겠다는 의미
        helper.setText(content, true);

        // 메일 발송
        mailSender.send(message);

        System.out.println("Email has been sent");

        return randomCode;

    }

}
