package com.sobreruedas.app.dto;

import jakarta.validation.constraints.*;

public class ContactoDTO {

    @NotBlank(message = "El nombre es obligatorio")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    @Pattern(regexp = "^[A-Za-zÀ-ÿ\\s]+$", message = "El nombre solo debe contener letras y espacios")
    private String nombre;

    @NotBlank(message = "El celular es obligatorio")
    @Pattern(regexp = "^[0-9]{9}$", message = "El celular debe tener 9 dígitos numéricos")
    private String celular;

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email debe ser válido")
    private String email;

    @NotBlank(message = "El mensaje no puede estar vacío")
    @Size(min = 10, max = 2000, message = "El mensaje debe tener al menos 10 caracteres")
    private String mensaje;

    public ContactoDTO() {}

    // getters y setters
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCelular() { return celular; }
    public void setCelular(String celular) { this.celular = celular; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMensaje() { return mensaje; }
    public void setMensaje(String mensaje) { this.mensaje = mensaje; }
}
