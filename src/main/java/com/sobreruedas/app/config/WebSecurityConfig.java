package com.sobreruedas.app.config;

import com.sobreruedas.app.model.Usuario;
import com.sobreruedas.app.service.UsuarioService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import java.io.IOException;

@Configuration
public class WebSecurityConfig {

    private final UsuarioService usuarioService;
    private final PasswordEncoder passwordEncoder;

    public WebSecurityConfig(UsuarioService usuarioService, PasswordEncoder passwordEncoder) {
        this.usuarioService = usuarioService;
        this.passwordEncoder = passwordEncoder;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // 🔒 Permisos por ruta
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/pagina1", "/login", "/register", "/css/**", "/js/**", "/img/**", "/images/**").permitAll()
                .requestMatchers("/reservas/**", "/paquetes/**").authenticated()
                .anyRequest().permitAll()
            )

            // 🧭 Configuración de login
            .formLogin(form -> form
                .loginPage("/login")
                .usernameParameter("username")
                .passwordParameter("password")
                .successHandler(miManejadorDeExito())
                .failureUrl("/login?error=true")
                .permitAll()
            )

            // 🚪 Configuración de logout
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .permitAll()
            )

            .userDetailsService(userDetailsServiceBean())
            .csrf(csrf -> csrf.disable());

        return http.build();
    }

    /**
     * Manejador personalizado: guarda datos en sesión y redirige correctamente
     */
    @Bean
    public AuthenticationSuccessHandler miManejadorDeExito() {
        return new SavedRequestAwareAuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws ServletException, IOException {
                
                // 1. Guardar datos en sesión
                String email = authentication.getName();
                Usuario usuario = usuarioService.findByEmail(email).orElse(null);
                
                if (usuario != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioId", usuario.getId());
                    session.setAttribute("usuarioNombre", usuario.getNombre());
                }

                // 2. Redirigir a la página anterior o a pagina1
                this.setDefaultTargetUrl("/pagina1");
                this.setAlwaysUseDefaultTargetUrl(false);
                super.onAuthenticationSuccess(request, response, authentication);
            }
        };
    }

    @Bean
    @Primary
    public UserDetailsService userDetailsServiceBean() {
        UserDetails admin = User.builder()
            .username("root")
            .password(passwordEncoder.encode("Sebastian2004jul"))
            .roles("ADMIN")
            .build();
        InMemoryUserDetailsManager inMemoryManager = new InMemoryUserDetailsManager(admin);
        return username -> {
            try {
                return inMemoryManager.loadUserByUsername(username);
            } catch (org.springframework.security.core.userdetails.UsernameNotFoundException e) {
                return usuarioService.loadUserByUsername(username);
            }
        };
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
}
