function toggleMenu() {
    const menu = document.getElementById('mobile-nav');
    menu.classList.toggle('hidden');
}

// Close mobile nav when a link is clicked
document.addEventListener('DOMContentLoaded', () => {
    const mobileLinks = document.querySelectorAll('#mobile-nav .nav-link');
    const menu = document.getElementById('mobile-nav');
    mobileLinks.forEach(link => {
        link.addEventListener('click', () => {
            menu.classList.add('hidden');
        });
    });
});