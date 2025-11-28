// Validación del formulario
  const form = document.getElementById("form-suscripcion");
  const correo = document.getElementById("correo");
  const mensaje = document.getElementById("mensaje-formulario");

  if (form && correo && mensaje) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();

     if (correo.value.includes("@") && correo.value.includes(".")) {
      mensaje.textContent = "¡Gracias por suscribirte!";
      mensaje.style.color = "#1a73e8";  
      mensaje.classList.add("mostrar");

      setTimeout(() => {
        mensaje.classList.remove("mostrar");
        mensaje.textContent = "";
      }, 4000);

      correo.value = "";


      } else {
        mensaje.textContent = "Correo inválido";
        mensaje.style.color = "red";
        mensaje.classList.add("mostrar");

        setTimeout(() => {
          mensaje.classList.remove("mostrar");
          mensaje.textContent = "";
        }, 3000);
      }
    });
  }