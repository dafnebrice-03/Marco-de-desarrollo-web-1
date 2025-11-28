package com.sobreruedas.app.controller;

import com.sobreruedas.app.dto.LoginDTO;
import com.sobreruedas.app.model.Usuario;
import com.sobreruedas.app.service.UsuarioService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    // --- Registro ---
    @GetMapping("/register")
    public String mostrarRegistro(Model model) {
        if (!model.containsAttribute("usuario")) {
            model.addAttribute("usuario", new Usuario());
        }
        return "register";
    }

    @PostMapping("/register")
    public String procesarRegistro(
            @Valid @ModelAttribute("usuario") Usuario usuario,
            BindingResult bindingResult,
            @RequestParam String confirmPassword,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Por favor corrige los errores del formulario");
            return "register";
        }

        if (!usuario.getPassword().equals(confirmPassword)) {
            model.addAttribute("error", "Las contraseñas no coinciden");
            return "register";
        }

        boolean exito = usuarioService.registrarUsuario(usuario);
        if (!exito) {
            model.addAttribute("error", "El email ya está registrado");
            return "register";
        }

        model.addAttribute("success", "Registro exitoso. Por favor inicia sesión.");
        return "redirect:/login";
    }

    // --- Login ---
    @GetMapping("/login")
    public String mostrarLogin(Model model) {
        if (!model.containsAttribute("loginForm")) {
            model.addAttribute("loginForm", new LoginDTO());
        }
        return "login";
    }

    //@PostMapping("/login")
    //public String procesarLogin(
 ////           @Valid @ModelAttribute("loginForm") LoginDTO loginForm,
      //      BindingResult bindingResult,
     //       Model model,
     //       HttpSession session,
       //     //cambie esto @RequestParam(required = false) String continue_url) por:
         //   @RequestParam(name = "continue", required = false) String continueUrl)
 //{

       // if (bindingResult.hasErrors()) {
         //   model.addAttribute("error", "Por favor corrige los datos del formulario");
           // return "login";
//        }
//
  //      if (usuarioService.validarLogin(loginForm.getEmail(), loginForm.getPassword())) {
    //        Usuario usuario = usuarioService.findByEmail(loginForm.getEmail()).orElseThrow();
      //      session.setAttribute("usuarioId", usuario.getId());
        //    session.setAttribute("usuarioNombre", usuario.getNombre());
//cambie el if anterior por: 
          //  if (continueUrl != null && !continueUrl.isEmpty()) {
   // return "redirect:" + continueUrl;
//}


      //      return "redirect:/pagina1";
        //} else {
          //  model.addAttribute("error", "Usuario o contraseña incorrecta");
            //return "login";
    //    }
    //}
}
