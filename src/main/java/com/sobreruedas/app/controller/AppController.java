package com.sobreruedas.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AppController {

    @GetMapping("/")
    public String home() {
        return "pagina1";
    }

    @GetMapping("/pagina1")
    public String pagina1() { return "pagina1"; }

    @GetMapping("/pagina2")
    public String pagina2() { return "pagina2"; }

    @GetMapping("/pagina3")
    public String pagina3() { return "pagina3"; }

    @GetMapping("/pagina4")
    public String pagina4() { return "pagina4"; }

    @GetMapping("/pagina5")
    public String pagina5() { return "pagina5"; }

    @GetMapping("/pagina6")
    public String pagina6() { return "pagina6"; }

    @GetMapping("/pagina7")
    public String pagina7() { return "pagina7"; }

    @GetMapping("/pagina8")
    public String pagina8() { return "pagina8"; }

    @GetMapping("/pagina9")
    public String pagina9() { return "pagina9"; }

    @GetMapping("/pagina10")
    public String pagina10() { return "pagina10"; }

    @GetMapping("/pagina11")
    public String pagina11() { return "pagina11"; }

    @GetMapping("/pagina12")
    public String pagina12() { return "pagina12"; }

    @GetMapping("/pagina13")
    public String pagina13() { return "pagina13"; }

    @GetMapping("/pagina14")
    public String pagina14() { return "pagina14"; }

    @GetMapping("/pagina15")
    public String pagina15() { return "pagina15"; }

    @GetMapping("/pagina16")
    public String pagina16() { return "pagina16"; }

    @GetMapping("/pagina17")
    public String pagina17() { return "pagina17"; }
}
