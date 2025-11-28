package com.sobreruedas.app.service;

import com.sobreruedas.app.model.Reserva;
import com.sobreruedas.app.repository.ReservaRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import java.util.Optional;
import java.util.List;
import java.util.Arrays;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class ReservaServiceTest {

    @Mock
    private ReservaRepository reservaRepository;

    @InjectMocks
    private ReservaService reservaService;

    private Reserva reserva;

    @BeforeEach
    void setUp() {
        reserva = new Reserva("Cliente Test", "Paquete Test", 2);
    }

    @Test
    void addReservaExitoso() {
        when(reservaRepository.save(any())).thenReturn(reserva);

        Reserva resultado = reservaService.addReserva(reserva);

        assertNotNull(resultado);
        assertEquals(reserva.getNombreCliente(), resultado.getNombreCliente());
        verify(reservaRepository).save(any());
    }

    @Test
    void getReservasRetornaLista() {
        List<Reserva> reservas = Arrays.asList(reserva);
        when(reservaRepository.findAll()).thenReturn(reservas);

        List<Reserva> resultado = reservaService.getReservas();

        assertFalse(resultado.isEmpty());
        assertEquals(1, resultado.size());
    }

    @Test
    void cancelarReservaExistente() {
        when(reservaRepository.findById(1L)).thenReturn(Optional.of(reserva));
        when(reservaRepository.save(any())).thenReturn(reserva);

        reservaService.cancelarReserva(1L);

        assertEquals(Reserva.EstadoReserva.CANCELADA, reserva.getEstado());
        verify(reservaRepository).save(any());
    }

    @Test
    void confirmarReservaExistente() {
        when(reservaRepository.findById(1L)).thenReturn(Optional.of(reserva));
        when(reservaRepository.save(any())).thenReturn(reserva);

        reservaService.confirmarReserva(1L);

        assertEquals(Reserva.EstadoReserva.CONFIRMADA, reserva.getEstado());
        verify(reservaRepository).save(any());
    }
}