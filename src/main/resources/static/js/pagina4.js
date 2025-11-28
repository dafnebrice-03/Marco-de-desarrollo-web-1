document.addEventListener('DOMContentLoaded', function() {
  ScrollReveal().reveal('.contactanos .contenido', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'top',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.formulario-contacto', {
    delay: 500,
    duration: 1000,
    distance: '50px',
    origin: 'left',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.info-contacto', {
    delay: 700,
    duration: 1000,
    distance: '50px',
    origin: 'right',
    easing: 'ease-in-out'
  });
});