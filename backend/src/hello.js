/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  console.log(process.env.NODE_PATH);
  let responseMessage = 'V74Hello, World!';
  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'V74Hello, ' + event.queryStringParameters['Name'] + '!';
  }
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
