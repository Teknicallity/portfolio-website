// Apply theme before page renders
const userPreference = localStorage.getItem('theme');
const systemPreference = window.matchMedia('(prefers-color-scheme: dark)').matches;

if (userPreference === 'dark' || (!userPreference && systemPreference)) {
    document.documentElement.classList.add('dark');
} else {
    document.documentElement.classList.remove('dark');
}