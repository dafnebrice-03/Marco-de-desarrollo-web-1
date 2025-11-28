package com.sobreruedas.app.service;

import com.sobreruedas.app.model.Usuario;
import com.sobreruedas.app.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(@NonNull String email) throws UsernameNotFoundException {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(email);
        if (usuarioOpt.isEmpty()) {
            throw new UsernameNotFoundException("Usuario no encontrado con email: " + email);
        }
        Usuario usuario = usuarioOpt.get();
        return User.builder()
                .username(usuario.getEmail())
                .password(usuario.getPassword())
                .roles("USER") // Puedes ajustar los roles según tu modelo
                .build();
    }

    @Transactional
    public boolean registrarUsuario(@NonNull Usuario usuario) {
        // Verificar si el email ya existe
        if (usuarioRepository.findByEmail(usuario.getEmail()).isPresent()) {
            return false;
        }
        
        // Encriptar la contraseña antes de guardar
        usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        usuarioRepository.save(usuario);
        return true;
    }

    @Transactional(readOnly = true)
    public boolean validarLogin(@NonNull String email, @NonNull String password) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(email);
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            return passwordEncoder.matches(password, usuario.getPassword());
        }
        return false;
    }

    @Transactional(readOnly = true)
    public Optional<Usuario> findByEmail(@NonNull String email) {
        return usuarioRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public List<Usuario> findAllUsers() {
        return usuarioRepository.findAll();
    }

    @Transactional
    public void deleteUser(@NonNull Long id) {
        usuarioRepository.deleteById(id);
    }
}
