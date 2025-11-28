package com.sobreruedas.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaqueteController {

    @GetMapping("/paquetes/1")
    public String paquete1() { return "pagina16"; }

    @GetMapping("/paquetes/2")
    public String paquete2() { return "pagina17"; }

    @GetMapping("/paquetes/3")
    public String paquete3() { return "pagina18"; }

    @GetMapping("/paquetes/4")
    public String paquete4() { return "pagina19"; }
}
