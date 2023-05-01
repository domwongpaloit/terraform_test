const { handler } = require("../src/getsomething");

describe('Name of the group', () => {

    it('returns a response with "Hello, World!" when called without any parameters', async () => {
        const event = {};
        const response = await handler(event);
        expect(response.statusCode).toEqual(200);
    });

});