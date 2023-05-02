const { PrismaClient } = require('@prisma/client')

const prisma = new PrismaClient()

module.exports.handler = async (event, context, callback) => {
    try {
        const posts = await prisma.post.findMany()
        return {
            statusCode: 200,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(posts)
        }
    } catch (error) {
        console.error(error)
        return {
            statusCode: 500,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(error)
        }
    }
}