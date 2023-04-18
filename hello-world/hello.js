/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'V2Hello, World!';
  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'V2Hello, ' + event.queryStringParameters['Name'] + '!';
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
