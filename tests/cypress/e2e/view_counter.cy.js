describe('View Counter API Integration', () => {
    let initialCount = 0;

    it('increments the view count correctly', () => {
        // Step 1: Get initial count from the API
        cy.request('GET', 'https://85o0jrs2z0.execute-api.us-east-1.amazonaws.com/prod/getViews')
            .then((res) => {
                expect(res.status).to.eq(200);

                const parsed = JSON.parse(res.body.body);
                expect(parsed).to.have.property('viewCount');
                initialCount = parsed.viewCount;
            });

        // Step 2: Visit the page (triggers POST to increment)
        cy.intercept('POST', 'https://85o0jrs2z0.execute-api.us-east-1.amazonaws.com/prod/incrementViews')
            .as('incrementView');
        cy.visit('https://josh.cacaw.group/');

        cy.wait('@incrementView').its('response.statusCode').should('eq', 200);

        // Step 3: Get updated count and validate it increased
        cy.request('GET', 'https://85o0jrs2z0.execute-api.us-east-1.amazonaws.com/prod/getViews')
            .then((res) => {
                expect(res.status).to.eq(200);

                const parsed = JSON.parse(res.body.body);
                expect(parsed.viewCount).to.eq(initialCount + 1);

                cy.get('#view-counter').should('contain', `Views: ${parsed.viewCount}`);
            });
    });
});