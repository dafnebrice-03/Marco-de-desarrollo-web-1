document.addEventListener('DOMContentLoaded', function() {
  ScrollReveal().reveal('.contenido h2', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'top',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.paquete', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'bottom',
    interval: 200,
    easing: 'ease-in-out'
  });
});