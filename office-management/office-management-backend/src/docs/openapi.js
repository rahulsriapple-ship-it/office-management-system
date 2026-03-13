const swaggerJSDoc = require("swagger-jsdoc");

const buildOpenApiSpec = () =>
  swaggerJSDoc({
    definition: {
      openapi: "3.0.3",
      info: {
        title: "Office Management API",
        version: "1.0.0",
        description: "API documentation for the Office Management backend.",
      },
      servers: [
        {
          url: process.env.API_BASE_URL || "http://localhost:5050",
          description: "Local development server",
        },
      ],
      tags: [
        {
          name: "Auth",
          description: "Authentication endpoints",
        },
        {
          name: "Department",
          description: "Department management endpoints",
        },
        {
          name: "Employee",
          description: "Employee management endpoints",
        },
        {
          name: "Company",
          description: "Company management endpoints",
        },
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: "http",
            scheme: "bearer",
            bearerFormat: "JWT",
          },
        },
        schemas: {
          ApiSuccessResponse: {
            type: "object",
            properties: {
              success: {
                type: "boolean",
                example: true,
              },
              message: {
                type: "string",
                example: "Request completed successfully",
              },
              data: {
                type: "object",
                additionalProperties: true,
              },
            },
          },
          ApiErrorResponse: {
            type: "object",
            properties: {
              success: {
                type: "boolean",
                example: false,
              },
              message: {
                type: "string",
                example: "Validation failed",
              },
              statusCode: {
                type: "number",
                example: 422,
              },
              errors: {
                type: "object",
                additionalProperties: true,
              },
            },
          },
        },
      },
    },
    apis: ["./src/routes/**/*.js", "./src/modules/**/*.js"],
  });

module.exports = buildOpenApiSpec;
