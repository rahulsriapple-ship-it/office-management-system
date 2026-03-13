const ApiError = require("../utils/apiError");
const RequestValidator = require("../utils/requestValidator");

const validateRequest = (schema = {}) => (req, _res, next) => {
  const validationTargets = ["body", "query", "params"];
  const collectedErrors = {};

  for (const target of validationTargets) {
    if (!schema[target]) {
      continue;
    }

    const result = RequestValidator.validate(schema[target], req[target]);

    if (!result.isValid) {
      collectedErrors[target] = result.errors;
      continue;
    }

    req[target] = {
      ...req[target],
      ...result.values,
    };
  }

  if (Object.keys(collectedErrors).length > 0) {
    return next(new ApiError(422, "Validation failed", collectedErrors));
  }

  return next();
};

module.exports = validateRequest;
