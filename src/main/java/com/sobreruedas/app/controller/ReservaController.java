package com.sobreruedas.app.controller;

import com.sobreruedas.app.model.Reserva;
import com.sobreruedas.app.service.ReservaService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
public class ReservaController {

    private final ReservaService reservaService;

    public ReservaController(ReservaService reservaService) {
        this.reservaService = reservaService;
    }

    @GetMapping("/reservas")
    public String mostrarFormulario(Model model) {
        model.addAttribute("reserva", new Reserva());
        return "reservas";
    }

    @PostMapping("/reservas")
    public String guardarReserva(@Valid @ModelAttribute("reserva") Reserva reserva, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Por favor corrige los errores en el formulario de reserva.");
            return "reservas";
        }

        reservaService.addReserva(reserva);
        model.addAttribute("mensaje", "¡Reserva enviada con éxito!");
        model.addAttribute("reserva", new Reserva());
        return "reservas";
    }

    @GetMapping("/reserva/1")
    public String reservaPaquete1() { return "pagina5"; }

    @GetMapping("/reserva/2")
    public String reservaPaquete2() { return "pagina6"; }

    @GetMapping("/reserva/3")
    public String reservaPaquete3() { return "pagina7"; }

    @GetMapping("/reserva/4")
    public String reservaPaquete4() { return "pagina8"; }
}
