const ApiError = require("../utils/apiError");
const ResponseFormatter = require("../utils/responseFormatter");

const notFoundHandler = (req, _res, next) => {
  next(new ApiError(404, `Route not found: ${req.method} ${req.originalUrl}`));
};

const errorHandler = (err, _req, res, _next) => {
  const statusCode = err.status || 500;

  res.status(statusCode).json(
    ResponseFormatter.error(
      err.message || "Internal server error",
      err.errors || null,
      statusCode
    )
  );
};

module.exports = {
  notFoundHandler,
  errorHandler,
};
