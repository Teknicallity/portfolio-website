async function loadResume() {
    const response = await fetch('/resume.json');
    const data = await response.json();

    // Education
    const edu = data.education.map(e =>
        `<div class="flex justify-between flex-col sm:flex-row mb-3">
      <div>
        <h3 class="text-lg font-semibold">${e.degree}</h3>
        <p class="subtitle">${e.school}</p>
      </div>
      <div class="text-left sm:text-right">
        <p class="text-md subtitle">${e.date}</p>
        <p class="text-md subtitle">${e.location}</p>
      </div>
    </div>`).join('');
    document.getElementById('education-content').innerHTML = edu;

    // Certifications
    const certs = data.certifications.map(c =>
        `<li class="flex justify-between flex-col sm:flex-row mb-2">
      <span>
        <a href="${c.url}" target="_blank" class="hover:underline inline-flex items-center gap-1">
          ${c.title} <i class="fas fa-external-link-alt text-sm"></i>
        </a>
      </span>
      <span class="subtitle">${c.year}</span>
    </li>`).join('');
    document.getElementById('certifications-content').innerHTML += `<ul>${certs}</ul>`;

    // Experience
    const exp = data.experience.map(job =>
        `<div class="card mb-4">
      <h3 class="text-lg font-semibold">${job.title}</h3>
      <p class="subtitle">${job.company} | ${job.dates}</p>
      <ul class="list-disc list-inside mt-2">
        ${job.bullets.map(b => `<li>${b}</li>`).join('')}
      </ul>
    </div>`).join('');
    document.getElementById('experience-content').innerHTML += exp;

    // Projects
    const proj = data.projects.map(p =>
        `<div class="card mb-4">
      <h3 class="text-lg font-semibold">${p.title}</h3>
      <p class="subtitle mb-2">${p.description}</p>
      <div class="space-x-4">
        <a href="${p.github}" target="_blank" class="link-default">
          <i class="fab fa-github font-black"></i> GitHub
        </a>
        ${p.demo ? `<a href="${p.demo}" target="_blank" class="link-default"><i class="fas fa-external-link-alt font-black"></i> Demo</a>` : ''}
      </div>
    </div>`).join('');
    document.getElementById('projects-content').innerHTML += proj;

    // Skills
    const skills = data.skills.map(skill => `<span class="skill-badge">${skill}</span>`).join('');
    document.getElementById('skills-content').innerHTML += `${skills}`;
}

document.addEventListener('DOMContentLoaded', loadResume);