package com.sobreruedas.app.repository;

import com.sobreruedas.app.model.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Long> {
    // Métodos personalizados si son necesarios
}