document.addEventListener("DOMContentLoaded", () => {
  // Cargar encabezado
  fetch("componentes/encabezado.html")
    .then(response => response.text())
    .then(data => {
      const headerContainer = document.getElementById("encabezado");
      headerContainer.innerHTML = data;
      initHeader(headerContainer); // 🔑 activar menú móvil
    })
    .catch(err => console.error("Error cargando encabezado:", err));

  // Cargar footer
  fetch("componentes/footer.html")
    .then(response => response.text())
    .then(data => {
      document.getElementById("footer").innerHTML = data;
    })
    .catch(err => console.error("Error cargando footer:", err));

  // Inicializar ScrollReveal
  ScrollReveal().reveal(".reveal", {
    duration: 1000,
    origin: "bottom",
    distance: "50px",
    easing: "ease-out",
    reset: false,
  });
});

// Función para inicializar el header y el menú móvil
function initHeader(root = document) {
  const menuBtn = root.querySelector("#menu-btn");
  const mobileMenu = root.querySelector("#mobile-menu");
  if (!menuBtn || !mobileMenu) return;

  const iconOpen = menuBtn.querySelector('[data-icon="open"]');
  const iconClose = menuBtn.querySelector('[data-icon="close"]');

  // Estado inicial
  menuBtn.setAttribute("aria-expanded", "false");
  iconOpen?.classList.remove("hidden");
  iconClose?.classList.add("hidden");
  mobileMenu.classList.add("hidden");

  function toggleMenu() {
    const isHidden = mobileMenu.classList.toggle("hidden");
    menuBtn.setAttribute("aria-expanded", String(!isHidden));
    iconOpen?.classList.toggle("hidden");
    iconClose?.classList.toggle("hidden");
  }

  menuBtn.addEventListener("click", toggleMenu);

  // Cerrar menú al pasar a escritorio
  const mql = window.matchMedia("(min-width: 768px)");
  function handleResize(e) {
    if (e.matches) {
      mobileMenu.classList.add("hidden");
      menuBtn.setAttribute("aria-expanded", "false");
      iconOpen?.classList.remove("hidden");
      iconClose?.classList.add("hidden");
    }
  }
  mql.addEventListener("change", handleResize);
}

// Hacer disponible para otros scripts
window.initHeader = initHeader;
