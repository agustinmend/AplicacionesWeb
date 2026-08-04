/**
 * Clase para manejar la lógica de navegación y el menú móvil
 */
class NavigationController {
    constructor() {
        this.nav = document.querySelector('.header__nav');
        this.toggleBtn = document.querySelector('.header__toggle');
        this.navLinks = document.querySelectorAll('.nav__link');
        
        if (!this.nav || !this.toggleBtn) {
            console.warn('Faltan elementos del DOM para inicializar NavigationController');
            return;
        }

        this.init();
    }

    init() {
        // Evento para abrir/cerrar menú
        this.toggleBtn.addEventListener('click', () => this.toggleMenu());

        // Evento para cerrar el menú al hacer clic en un enlace (útil en móviles)
        this.navLinks.forEach(link => {
            link.addEventListener('click', () => this.closeMenu());
        });
    }

    toggleMenu() {
        const isExpanded = this.toggleBtn.getAttribute('aria-expanded') === 'true';
        this.toggleBtn.setAttribute('aria-expanded', !isExpanded);
        this.nav.classList.toggle('is-active');
    }

    closeMenu() {
        if (this.nav.classList.contains('is-active')) {
            this.toggleBtn.setAttribute('aria-expanded', 'false');
            this.nav.classList.remove('is-active');
        }
    }
}

/**
 * Clase para manejar la validación y envío del formulario de contacto
 */
class FormHandler {
    constructor() {
        this.form = document.querySelector('.contact__form');
        
        if (!this.form) {
            console.warn('Formulario no encontrado en el DOM');
            return;
        }

        this.init();
    }

    init() {
        this.form.addEventListener('submit', (event) => this.handleSubmit(event));
    }

    handleSubmit(event) {
        event.preventDefault(); // Previene la recarga de la página

        // Extracción de datos usando FormData (la forma correcta y limpia)
        const formData = new FormData(this.form);
        const data = Object.fromEntries(formData.entries());

        // Aquí iría tu lógica de validación estricta antes de enviar
        if (!data.name || !data.email || !data.message) {
            alert('Por favor, completa todos los campos.');
            return;
        }

        // Simulador de llamada a una API
        this.submitToAPI(data);
    }

    async submitToAPI(data) {
        const submitBtn = this.form.querySelector('.form__submit');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Enviando...';
        submitBtn.disabled = true;

        try {
            // Simulamos un retraso de red
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            console.log('Datos enviados:', data);
            alert('Mensaje enviado con éxito.');
            this.form.reset();
        } catch (error) {
            console.error('Error al enviar el formulario:', error);
            alert('Hubo un problema al enviar el mensaje.');
        } finally {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        }
    }
}

// Inicialización de la aplicación cuando el DOM está completamente cargado
document.addEventListener('DOMContentLoaded', () => {
    new NavigationController();
    new FormHandler();
});