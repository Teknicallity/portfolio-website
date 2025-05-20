describe('View Counter API Integration', () => {
    let initialCount = 0;
    let apiBase;
    let siteUrl;

    before(() => {
        console.log('All env vars:', Cypress.env());

        apiBase = Cypress.env('API_BASE_URL');
        siteUrl = Cypress.env('SITE_URL');

        if (!apiBase || !siteUrl) {
            throw new Error('Missing required environment variables');
        }

        console.log('API_BASE_URL:', apiBase);
        console.log('SITE_URL:', siteUrl);
    });

    it('increments the view count correctly', () => {
        // Step 1: Get initial count from the API
        cy.request('GET', `${apiBase}/getViews`)
            .then((res) => {
                expect(res.status).to.eq(200);

                const parsed = JSON.parse(res.body.body);
                expect(parsed).to.have.property('viewCount');
                initialCount = parsed.viewCount;
            });

        // Step 2: Visit the page (triggers POST to increment)
        cy.intercept('POST', `${apiBase}/incrementViews`).as('incrementView');
        cy.visit(siteUrl);

        cy.wait('@incrementView').its('response.statusCode').should('eq', 200);

        // Step 3: Get updated count and validate it increased
        cy.request('GET', `${apiBase}/getViews`)
            .then((res) => {
                expect(res.status).to.eq(200);

                const parsed = JSON.parse(res.body.body);
                expect(parsed.viewCount).to.eq(initialCount + 1);

                cy.get('#view-counter').should('contain', `Views: ${parsed.viewCount}`);
            });
    });
});
