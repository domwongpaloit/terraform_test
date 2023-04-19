// jest.config.js

module.exports = {
    testEnvironment: 'node',
    roots: ['<rootDir>'],
    testMatch: ['**/*.test.js'],
    collectCoverageFrom: ['**/*.js', '!**/node_modules/**', '!**/tests/**'],
    coverageReporters: ['text-summary', 'html'],
    coverageDirectory: '<rootDir>/coverage',
};
