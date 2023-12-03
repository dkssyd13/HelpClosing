package cau.capstone.helpclosing.config;

import cau.capstone.helpclosing.security.entity.JwtProvider;
import io.netty.channel.ChannelHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Objects;

@RequiredArgsConstructor
@Component
public class StompHandler implements ChannelInterceptor {
    private final JwtProvider jwtProvider;

    @Override
    public Message<?> preSend(Message<?> message , MessageChannel channel) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        System.out.println("message:" + message);
        System.out.println("헤더 : " + message.getHeaders());
        System.out.println("토큰" + accessor.getNativeHeader("Authorization"));

        if (StompCommand.CONNECT.equals(accessor.getCommand())) {
            jwtProvider.validateToken(Objects.requireNonNull(accessor.getFirstNativeHeader("Authorization")).substring(7));
        }

        return message;
    }

}
