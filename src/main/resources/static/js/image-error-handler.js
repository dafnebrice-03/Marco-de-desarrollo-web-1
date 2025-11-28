// Este script maneja los errores de carga de imágenes
document.addEventListener('DOMContentLoaded', function() {
    const images = document.getElementsByTagName('img');
    for (let img of images) {
        img.onerror = function() {
            // Si la imagen no se puede cargar, mostrar una imagen por defecto o un placeholder
            this.src = '/images/ImageTuristica.jpg';
            this.alt = 'Imagen no disponible';
            // También podemos registrar el error para debugging
            console.error('Error cargando imagen:', this.src);
        };
    }
});