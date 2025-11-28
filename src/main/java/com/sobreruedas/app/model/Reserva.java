package com.sobreruedas.app.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservas")
public class Reserva {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "El nombre del cliente es obligatorio")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    @Column(name = "nombre_cliente")
    private String nombreCliente;

    @NotBlank(message = "El paquete es obligatorio")
    private String paquete;

    @Min(value = 1, message = "Debe haber al menos 1 persona")
    @Max(value = 50, message = "No puede exceder 50 personas")
    private int personas;

    @NotBlank(message = "El email es obligatorio")
    @Email(message = "El email debe ser válido")
    private String email;

    @NotBlank(message = "El teléfono es obligatorio")
    @Pattern(regexp = "^[0-9]{7,15}$", message = "El teléfono debe contener solo números y tener entre 7 y 15 dígitos")
    private String telefono;

    @Size(max = 2000, message = "El mensaje no puede exceder 2000 caracteres")
    private String mensaje;

    @Column(name = "fecha_reserva")
    private LocalDateTime fechaReserva;

    @Column(name = "estado")
    @Enumerated(EnumType.STRING)
    private EstadoReserva estado = EstadoReserva.PENDIENTE;

    @PrePersist
    protected void onCreate() {
        fechaReserva = LocalDateTime.now();
    }

    public enum EstadoReserva {
        PENDIENTE,
        CONFIRMADA,
        CANCELADA
    }

    // Constructores
    public Reserva() {}

    public Reserva(String nombreCliente, String paquete, int personas) {
        this.nombreCliente = nombreCliente;
        this.paquete = paquete;
        this.personas = personas;
    }

    public Reserva(String nombreCliente, String paquete, int personas, String email, String telefono, String mensaje) {
        this.nombreCliente = nombreCliente;
        this.paquete = paquete;
        this.personas = personas;
        this.email = email;
        this.telefono = telefono;
        this.mensaje = mensaje;
    }

    // Getters y setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getPaquete() {
        return paquete;
    }

    public void setPaquete(String paquete) {
        this.paquete = paquete;
    }

    public int getPersonas() {
        return personas;
    }

    public void setPersonas(int personas) {
        this.personas = personas;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public LocalDateTime getFechaReserva() {
        return fechaReserva;
    }

    public void setFechaReserva(LocalDateTime fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public EstadoReserva getEstado() {
        return estado;
    }

    public void setEstado(EstadoReserva estado) {
        this.estado = estado;
    }
}
