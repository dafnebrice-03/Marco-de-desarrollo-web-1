document.addEventListener('DOMContentLoaded', function() {
  ScrollReveal().reveal('.titulo-animado', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'top',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.clip-texto', {
    delay: 500,
    duration: 1000,
    distance: '50px',
    origin: 'bottom',
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.quienes-texto, .quienes-img', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'left',
    interval: 200,
    easing: 'ease-in-out'
  });
  
  ScrollReveal().reveal('.mision-texto, .mision-img', {
    delay: 300,
    duration: 1000,
    distance: '50px',
    origin: 'right',
    interval: 200,
    easing: 'ease-in-out'
  });
});