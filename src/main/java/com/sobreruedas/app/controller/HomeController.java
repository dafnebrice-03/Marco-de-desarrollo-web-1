package com.sobreruedas.app.controller;

import com.sobreruedas.app.model.Paquete;
import com.sobreruedas.app.service.PaqueteService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final PaqueteService paqueteService;

    public HomeController(PaqueteService paqueteService) {
        this.paqueteService = paqueteService;
    }

    @GetMapping("/pagina18")
    public String rutaPacifico(Model model) {
        java.util.Optional<Paquete> paqueteOpt = paqueteService.getPaquete("Ruta Pacífico Sur");
        Paquete paquete = paqueteOpt.orElse(null);
        model.addAttribute("paquete", paquete);
        return "pagina18";
    }

    @GetMapping("/pagina19")
    public String rutaAmazonia(Model model) {
        java.util.Optional<Paquete> paqueteOpt = paqueteService.getPaquete("Ruta Aventura Amazónica");
        Paquete paquete = paqueteOpt.orElse(null);
        model.addAttribute("paquete", paquete);
        return "pagina19";
    }
}
