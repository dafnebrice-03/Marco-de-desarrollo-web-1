package com.sobreruedas.app.dto;

import jakarta.validation.constraints.*;

public class LoginDTO {

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email debe ser válido")
    private String email;

    @NotBlank(message = "La contraseña es obligatoria")
    @Size(min = 8, message = "La contraseña debe tener al menos 8 caracteres")
    @Pattern(regexp = "^(?=\\S+$)(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}$", message = "La contraseña debe tener al menos 8 caracteres, incluir letras, números, al menos 1 carácter especial y no contener espacios")
    private String password;

    public LoginDTO() {}

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
