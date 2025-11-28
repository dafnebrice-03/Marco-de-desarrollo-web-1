package com.sobreruedas.app.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

@Configuration
public class RateLimitConfig {
    
    @Bean
    public Bucket authenticationBucket() {
        long capacity = 5; // máximo número de intentos
        Refill refill = Refill.intervally(capacity, Duration.ofMinutes(15));
        Bandwidth limit = Bandwidth.classic(capacity, refill);
        return Bucket.builder().addLimit(limit).build();
    }
}