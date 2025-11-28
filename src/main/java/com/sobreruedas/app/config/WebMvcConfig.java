package com.sobreruedas.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @NonNull
    private final AuthInterceptor authInterceptor;

    public WebMvcConfig(@NonNull AuthInterceptor authInterceptor) {
        this.authInterceptor = authInterceptor;
    }

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
               .addPathPatterns("/**")
               .excludePathPatterns("/js/**", "/css/**", "/images/**", "/login", "/register", "/", "/pagina1");
    }
}