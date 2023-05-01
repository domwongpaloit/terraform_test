const { format } = require('date-fns');

module.exports.handler = async event => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            // 👇️ use npm package
            today: format(new Date(), "👉️ 'Today is a' eeee"),
        }),
    };
};