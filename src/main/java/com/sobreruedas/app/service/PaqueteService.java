package com.sobreruedas.app.service;

import com.sobreruedas.app.model.Paquete;
import com.sobreruedas.app.repository.PaqueteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import jakarta.annotation.PostConstruct;

@Service
public class PaqueteService {

    @Autowired
    private PaqueteRepository paqueteRepository;

    @PostConstruct
    @Transactional
    public void inicializarPaquetes() {
        if (paqueteRepository.count() == 0) {

            // Paquete 1
            Paquete p1 = new Paquete("Ruta Pacífico Sur", "Disfruta de playas y gastronomía", 500.0);
            p1.setDuracionDias(3);
            p1.setCupoMaximo(10);
            p1.setFechaInicio(LocalDate.now().plusDays(7));
            p1.setFechaFin(p1.getFechaInicio().plusDays(p1.getDuracionDias()));
            p1.setImagenUrl("/images/pacifico.jpg");

            // Paquete 2
            Paquete p2 = new Paquete("Ruta Aventura Amazónica", "Explora la selva y su biodiversidad", 700.0);
            p2.setDuracionDias(5);
            p2.setCupoMaximo(8);
            p2.setFechaInicio(LocalDate.now().plusDays(10));
            p2.setFechaFin(p2.getFechaInicio().plusDays(p2.getDuracionDias()));
            p2.setImagenUrl("/images/amazonia.jpg");

            paqueteRepository.save(p1);
            paqueteRepository.save(p2);
        }
    }

    @Transactional(readOnly = true)
    public List<Paquete> getAllPaquetes() {
        return paqueteRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Paquete> getPaquete(@NonNull String nombre) {
        return paqueteRepository.findByNombre(nombre);
    }

    @Transactional
    public Paquete savePaquete(@NonNull Paquete paquete) {
        return paqueteRepository.save(paquete);
    }

    @Transactional
    public void deletePaquete(@NonNull Long id) {
        paqueteRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public boolean existePaquete(String nombre) {
        return paqueteRepository.findByNombre(nombre).isPresent();
    }
}
