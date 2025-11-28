package com.sobreruedas.app.controller;

import com.sobreruedas.app.dto.ContactoDTO;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
public class ContactoController {

    @GetMapping("/contacto")
    public String mostrarFormulario(Model model) {
        if (!model.containsAttribute("contacto")) {
            model.addAttribute("contacto", new ContactoDTO());
        }
        return "pagina4";
    }

    @PostMapping("/contacto")
    public String procesarFormulario(
            @Valid @ModelAttribute("contacto") ContactoDTO contacto,
            BindingResult bindingResult,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Por favor corrige los errores en el formulario.");
            return "pagina4";
        }

        // Simulación de envío o guardado
        System.out.println("=== Datos de contacto válidos ===");
        System.out.println("Nombre: " + contacto.getNombre());
        System.out.println("Celular: " + contacto.getCelular());
        System.out.println("Email: " + contacto.getEmail());
        System.out.println("Mensaje: " + contacto.getMensaje());

        model.addAttribute("success", "El mensaje se envió correctamente (simulación).");
        model.addAttribute("contacto", new ContactoDTO());

        return "pagina4";
    }
}
