// Validación en tiempo real del formulario
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const password = document.getElementById('password');
    const passwordStrength = document.createElement('div');
    passwordStrength.classList.add('text-sm', 'mt-1');
    password.parentNode.appendChild(passwordStrength);

    // Función para validar fortaleza de contraseña
    function validatePassword(value) {
        const hasLetter = /[A-Za-z]/.test(value);
        const hasNumber = /\d/.test(value);
        const hasSpecial = /[^A-Za-z0-9\s]/.test(value);
        const hasNoSpaces = !/\s/.test(value);
        const isLongEnough = value.length >= 8;

        let strength = 0;
        let message = '';
        let color = '';

        if (hasLetter) strength++;
        if (hasNumber) strength++;
        if (hasSpecial) strength++;
        if (hasNoSpaces) strength++;
        if (isLongEnough) strength++;

        switch(strength) {
            case 0:
            case 1:
                message = 'Muy débil';
                color = 'text-red-600';
                break;
            case 2:
            case 3:
                message = 'Regular';
                color = 'text-yellow-600';
                break;
            case 4:
                message = 'Buena';
                color = 'text-blue-600';
                break;
            case 5:
                message = '¡Excelente!';
                color = 'text-green-600';
                break;
        }

        return { message, color };
    }

    // Evento para validación en tiempo real
    password.addEventListener('input', function(e) {
        const result = validatePassword(e.target.value);
        passwordStrength.textContent = 'Fortaleza: ' + result.message;
        passwordStrength.className = 'text-sm mt-1 ' + result.color;
    });

    // Validación del formulario antes de enviar
    form.addEventListener('submit', function(e) {
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        let isValid = true;

        // Validar email
        if (!emailInput.value.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
            showError(emailInput, 'Por favor ingresa un email válido');
            isValid = false;
        } else {
            clearError(emailInput);
        }

        // Validar contraseña
        const passwordResult = validatePassword(passwordInput.value);
        if (passwordResult.message !== '¡Excelente!') {
            showError(passwordInput, 'La contraseña no cumple con los requisitos mínimos');
            isValid = false;
        } else {
            clearError(passwordInput);
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    // Funciones auxiliares
    function showError(input, message) {
        const errorDiv = input.nextElementSibling || document.createElement('div');
        errorDiv.textContent = message;
        errorDiv.className = 'text-red-600 text-sm mt-1';
        if (!input.nextElementSibling) {
            input.parentNode.appendChild(errorDiv);
        }
        input.classList.add('border-red-500');
    }

    function clearError(input) {
        const errorDiv = input.nextElementSibling;
        if (errorDiv && errorDiv.classList.contains('text-red-600')) {
            errorDiv.remove();
        }
        input.classList.remove('border-red-500');
    }
});