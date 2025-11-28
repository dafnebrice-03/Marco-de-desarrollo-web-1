package com.sobreruedas.app.service;

import com.sobreruedas.app.model.Reserva;
import com.sobreruedas.app.repository.ReservaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class ReservaService {

    @Autowired
    private ReservaRepository reservaRepository;

    @Transactional(readOnly = true)
    public List<Reserva> getReservas() {
        return reservaRepository.findAll();
    }

    @Transactional
    public Reserva addReserva(@NonNull Reserva reserva) {
        return reservaRepository.save(reserva);
    }

    @Transactional(readOnly = true)
    public Optional<Reserva> getReservaById(@NonNull Long id) {
        return reservaRepository.findById(id);
    }

    @Transactional
    public void cancelarReserva(@NonNull Long id) {
        Optional<Reserva> reservaOpt = reservaRepository.findById(id);
        if (reservaOpt.isPresent()) {
            Reserva reserva = reservaOpt.get();
            reserva.setEstado(Reserva.EstadoReserva.CANCELADA);
            reservaRepository.save(reserva);
        }
    }

    @Transactional
    public void confirmarReserva(@NonNull Long id) {
        Optional<Reserva> reservaOpt = reservaRepository.findById(id);
        if (reservaOpt.isPresent()) {
            Reserva reserva = reservaOpt.get();
            reserva.setEstado(Reserva.EstadoReserva.CONFIRMADA);
            reservaRepository.save(reserva);
        }
    }
}
