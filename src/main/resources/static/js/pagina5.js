
document.addEventListener('DOMContentLoaded', function() {
  ScrollReveal().reveal('.reservas .contenido', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'top',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.formulario-reserva', {
    delay: 500,
    duration: 1000,
    distance: '50px',
    origin: 'bottom',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.grupo-input', {
    delay: 300,
    duration: 1000,
    distance: '30px',
    origin: 'bottom',
    interval: 100,
    easing: 'ease-in-out'
  });
});