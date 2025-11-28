package com.sobreruedas.app.service;

import com.sobreruedas.app.model.Usuario;
import com.sobreruedas.app.repository.UsuarioRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class UsuarioServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UsuarioService usuarioService;

    private Usuario usuario;

    @BeforeEach
    void setUp() {
        usuario = new Usuario("Test User", "test@test.com", "password123");
    }

    @Test
    void registrarUsuarioExitoso() {
        when(usuarioRepository.findByEmail(usuario.getEmail())).thenReturn(Optional.empty());
        when(passwordEncoder.encode(any())).thenReturn("encodedPassword");
        when(usuarioRepository.save(any())).thenReturn(usuario);

        boolean resultado = usuarioService.registrarUsuario(usuario);

        assertTrue(resultado);
        verify(usuarioRepository).save(any());
    }

    @Test
    void registrarUsuarioEmailDuplicado() {
        when(usuarioRepository.findByEmail(usuario.getEmail())).thenReturn(Optional.of(usuario));

        boolean resultado = usuarioService.registrarUsuario(usuario);

        assertFalse(resultado);
        verify(usuarioRepository, never()).save(any());
    }

    @Test
    void validarLoginExitoso() {
        when(usuarioRepository.findByEmail(usuario.getEmail())).thenReturn(Optional.of(usuario));
        when(passwordEncoder.matches(any(), any())).thenReturn(true);

        boolean resultado = usuarioService.validarLogin(usuario.getEmail(), "password123");

        assertTrue(resultado);
    }

    @Test
    void validarLoginFallido() {
        when(usuarioRepository.findByEmail(usuario.getEmail())).thenReturn(Optional.of(usuario));
        when(passwordEncoder.matches(any(), any())).thenReturn(false);

        boolean resultado = usuarioService.validarLogin(usuario.getEmail(), "wrongpassword");

        assertFalse(resultado);
    }
}