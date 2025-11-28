package com.sobreruedas.app.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler) throws Exception {
        String path = request.getRequestURI();
        
        // Permitir acceso a recursos estáticos y páginas públicas
        if (isPublicResource(path)) {
            return true;
        }

        HttpSession session = request.getSession();
        if (session != null && session.getAttribute("usuarioId") != null) {
            return true;
        }

        // Guardar la URL actual para redireccionar después del login
        String queryString = request.getQueryString();
        String redirectUrl = path + (queryString != null ? "?" + queryString : "");
        response.sendRedirect("/login?continue=" + redirectUrl);
        return false;
    }

    private boolean isPublicResource(String path) {
        return path.startsWith("/js/") ||
               path.startsWith("/css/") ||
               path.startsWith("/images/") ||
               path.equals("/login") ||
               path.equals("/register") ||
               path.equals("/") ||
               path.equals("/pagina1");
    }
}