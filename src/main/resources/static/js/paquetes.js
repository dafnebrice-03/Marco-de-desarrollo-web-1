document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("form-reserva");
  const estado = document.getElementById("estado-formulario");

  // Recuperar datos guardados si existen
  const datosGuardados = localStorage.getItem("reserva");
  if (datosGuardados) {
    const datos = JSON.parse(datosGuardados);
    document.getElementById("nombre").value = datos.nombre || "";
    document.getElementById("correo").value = datos.correo || "";
    document.getElementById("telefono").value = datos.telefono || "";
    document.getElementById("personas").value = datos.personas || "";
    document.getElementById("mensaje").value = datos.mensaje || "";
  }

  if (form && estado) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();

      // Obtener datos
      const nombre = document.getElementById("nombre").value.trim();
      const correo = document.getElementById("correo").value.trim();
      const telefono = document.getElementById("telefono").value.trim();
      const personas = document.getElementById("personas").value;
      const mensaje = document.getElementById("mensaje").value.trim();

      // Validar campos
      if (!nombre || !correo || !telefono || !personas || !mensaje) {
        estado.textContent = "Por favor, completa todos los campos.";
        estado.style.color = "red";
        return;
      }

      // Confirmación antes de enviar
      if (!confirm("¿Deseas enviar la reserva?")) {
        estado.textContent = "Reserva cancelada.";
        estado.style.color = "red";
        setTimeout(() => estado.textContent = "", 3000);
        return;
      }

      // Guardar en localStorage
      const datosReserva = {
        nombre,
        correo,
        telefono,
        personas,
        mensaje
      };
      localStorage.setItem("reserva", JSON.stringify(datosReserva));

      // BORRAR datos guardados después del envío
      localStorage.removeItem("reserva");

      // Mostrar estado
      estado.textContent = "¡Reserva enviada correctamente!";
      estado.style.color = "blue";

      // Limpiar formulario y mensaje
      setTimeout(() => {
        estado.textContent = "";
        form.reset();
      }, 4000);
    });
  }
});
