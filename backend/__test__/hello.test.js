const { handler } = require("../src/hello");

describe('handler', () => {
    it('returns a response with "Hello, World!" when called without any parameters', async () => {
        const event = {};
        const response = await handler(event);
        expect(response.statusCode).toEqual(200);
        expect(response.body).toEqual(JSON.stringify({ message: 'V70Hello, World!' }));
    });

    it('returns a response with "Hello, <name>!" when called with a "Name" query parameter', async () => {
        const name = 'Alice';
        const event = {
            queryStringParameters: {
                Name: name,
            },
        };
        const response = await handler(event);
        expect(response.statusCode).toEqual(200);
        expect(response.body).toEqual(JSON.stringify({ message: `V70Hello, ${name}!` }));
    });
});