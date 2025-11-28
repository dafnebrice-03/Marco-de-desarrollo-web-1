package com.sobreruedas.app.repository;

import com.sobreruedas.app.model.Paquete;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface PaqueteRepository extends JpaRepository<Paquete, Long> {
    Optional<Paquete> findByNombre(String nombre);
}