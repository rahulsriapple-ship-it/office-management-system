const app = require("./app");
const connectDB = require("./config/database");
const logger = require("./utils/logger");

const PORT = process.env.PORT || 5050;
const HOST = process.env.HOST || "0.0.0.0";
const PUBLIC_HOST = HOST === "0.0.0.0" ? "localhost" : HOST;
const BASE_URL = process.env.API_BASE_URL || `http://${PUBLIC_HOST}:${PORT}`;

const startServer = async () => {
  try {
    await connectDB();

    const server = app.listen(PORT, HOST, () => {
      logger.info("HTTP server started", {
        service: "office-management-backend",
        host: HOST,
        port: PORT,
        environment: process.env.NODE_ENV || "development",
        webLink: BASE_URL,
        apiLink: `${BASE_URL}/api`,
        swaggerLink: `${BASE_URL}/api/docs`,
        openApiLink: `${BASE_URL}/api/openapi.json`,
      });
    });

    server.on("error", (error) => {
      logger.error("HTTP server error", {
        error: error.message,
        code: error.code,
      });
      process.exit(1);
    });
  } catch (error) {
    logger.error("Application startup failed", {
      error: error.message,
    });
    process.exit(1);
  }
};

process.on("unhandledRejection", (reason) => {
  logger.error("Unhandled promise rejection", {
    error: reason instanceof Error ? reason.message : String(reason),
  });
});

process.on("uncaughtException", (error) => {
  logger.error("Uncaught exception", {
    error: error.message,
  });
  process.exit(1);
});

startServer();
