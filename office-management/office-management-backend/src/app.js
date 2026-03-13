const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const swaggerUi = require("swagger-ui-express");
require("dotenv").config();

const routes = require("./routes");
const buildOpenApiSpec = require("./docs/openapi");
const { notFoundHandler, errorHandler } = require("./middleware/error.middleware");

const app = express();
const openApiSpec = buildOpenApiSpec();

app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

app.get("/api/openapi.json", (_req, res) => {
  res.json(openApiSpec);
});
app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(openApiSpec));
app.use("/api", routes);
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
