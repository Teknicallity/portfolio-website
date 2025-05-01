const button = document.getElementById('toggle-theme');
const icon = document.getElementById('toggle-icon');
const html = document.documentElement;

button.addEventListener('click', () => {
    const isDark = html.classList.toggle('dark');
    localStorage.setItem('theme', isDark ? 'dark' : 'light');

    icon.classList.remove(isDark ? 'fa-moon' : 'fa-sun');
    icon.classList.add(isDark ? 'fa-sun' : 'fa-moon');
});

window.addEventListener('DOMContentLoaded', () => {
    const savedTheme = localStorage.getItem('theme');
    const isDark = savedTheme === 'dark';

    if (isDark) html.classList.add('dark');
    else html.classList.remove('dark');

    icon.classList.remove(isDark ? 'fa-moon' : 'fa-sun');
    icon.classList.add(isDark ? 'fa-sun' : 'fa-moon');
});