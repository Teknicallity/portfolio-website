
async function getViewCount() {
    const url = window.AppConfig.apiUrl;
    const viewDiv = document.getElementById('view-counter');

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const json = await response.json();
        const data = JSON.parse(json.body);

        viewDiv.textContent = `Views: ${data.newViewCount}`;

    } catch (error) {
        console.error('Fetch error:', error);
        viewDiv.textContent = 'Views: unavailable';
    }
}

document.addEventListener('DOMContentLoaded', getViewCount);