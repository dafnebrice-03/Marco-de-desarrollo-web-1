document.addEventListener("DOMContentLoaded", () => {
  const botones = document.querySelectorAll(".boton");

  botones.forEach(boton => {
    boton.addEventListener("mouseenter", () => {
      boton.style.backgroundColor = "#34a853";
    });

    boton.addEventListener("mouseleave", () => {
      boton.style.backgroundColor = "#1a73e8";
    });
  });
});
