document.addEventListener("DOMContentLoaded", function () {
  const formulario = document.getElementById("form-contacto");
  const estado = document.getElementById("estado-formulario");

  formulario.addEventListener("submit", function (event) {
    event.preventDefault();

    const nombre = document.getElementById("nombre").value.trim();
    const celular = document.getElementById("celular").value.trim();
    const email = document.getElementById("email").value.trim();
    const mensaje = document.getElementById("mensaje").value.trim();

    if (!nombre || !celular || !email || !mensaje) {
      estado.textContent = "Por favor, completa todos los campos.";
      estado.className = "mensaje-error mostrar";
    } else {
      
      //  Confirmar antes de enviar
      const confirmar = confirm("¿Deseas enviar el mensaje?");
      if (confirmar) {
        estado.textContent = "Mensaje enviado correctamente.";
        estado.className = "mensaje-exito mostrar";
        formulario.reset();
      } else {
        estado.textContent = "Mensaje cancelado.";
        estado.className = "mensaje-error mostrar";
      }
    }

    setTimeout(() => {
      estado.textContent = "";
      estado.classList.remove("mostrar", "mensaje-exito", "mensaje-error");
    }, 5000);
  });
});

