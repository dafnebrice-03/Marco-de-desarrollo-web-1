package com.sobreruedas.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DestinoController {

    @GetMapping("/destinos/arequipa")
    public String arequipa() { return "pagina10"; }

    @GetMapping("/destinos/cusco")
    public String cusco() { return "pagina11"; }

    @GetMapping("/destinos/huaraz")
    public String huaraz() { return "pagina12"; }

    @GetMapping("/destinos/oxapampa")
    public String oxapampa() { return "pagina13"; }

    @GetMapping("/destinos/puno")
    public String puno() { return "pagina14"; }

    @GetMapping("/destinos/paracas")
    public String paracas() { return "pagina15"; }
}
