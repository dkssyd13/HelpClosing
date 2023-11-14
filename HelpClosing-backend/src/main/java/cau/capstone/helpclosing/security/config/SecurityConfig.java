package cau.capstone.helpclosing.security.config;

import cau.capstone.helpclosing.security.entity.JwtUtil;
import cau.capstone.helpclosing.security.filter.JwtFilter;
import cau.capstone.helpclosing.security.service.CustomUserDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.BeanIds;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomUserDetailService customUserDetailService;

    @Autowired
    private JwtFilter jwtFilter;

    @Value("${jwt.secret}")
    private String secret;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserDetailService);
    }

    @Bean(name = BeanIds.AUTHENTICATION_MANAGER)
    @Override
    protected AuthenticationManager authenticationManager() throws Exception {
        return super.authenticationManager();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf().disable()   // 보안에 관한 것
                .authorizeRequests().antMatchers("/authenticate",
                "/v3/api-docs/**",
                "/swagger-ui/**",
                "/v2/api-docs",
                "/swagger-resources",
                "/swagger-resources/**",
                "/configuration/ui",
                "/configuration/security",
                "swagger-ui.html",
                "/login",
                "/email",
                "/verify",
                "/register",
                "/delete/**",
                "/matching",
                "/upload",
                "/accept",
                "/reject",
                "/profile/**"
                ,"/ws-stomp/**"
                ).permitAll()
                .anyRequest().authenticated()
                .and()
                .exceptionHandling()
                .and()
                .sessionManagement()    // 세션에 대해 관리
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        http.addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public JwtUtil jwtUtil() {
        return new JwtUtil(secret);
    }

}
