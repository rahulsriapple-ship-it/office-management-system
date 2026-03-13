class RequestValidator {
  static validate(schema = {}, payload = {}) {
    const errors = {};
    const values = {};

    for (const [field, rules] of Object.entries(schema)) {
      const rawValue = payload[field];
      const preparedValue = this.prepareValue(rawValue, rules);
      const fieldErrors = this.validateField(field, preparedValue, rules);

      if (fieldErrors.length > 0) {
        errors[field] = fieldErrors;
        continue;
      }

      if (preparedValue !== undefined) {
        values[field] = preparedValue;
      }
    }

    return {
      isValid: Object.keys(errors).length === 0,
      errors,
      values,
    };
  }

  static prepareValue(value, rules = {}) {
    if (value === undefined || value === null) {
      return value;
    }

    if (rules.trim && typeof value === "string") {
      return value.trim();
    }

    return value;
  }

  static validateField(field, value, rules = {}) {
    const errors = [];
    const isEmptyString = typeof value === "string" && value.trim() === "";
    const isMissing = value === undefined || value === null || isEmptyString;

    if (rules.required && isMissing) {
      errors.push(`${field} is required`);
      return errors;
    }

    if (isMissing) {
      return errors;
    }

    if (rules.type && !this.isExpectedType(value, rules.type)) {
      errors.push(`${field} must be a ${rules.type}`);
      return errors;
    }

    if (rules.type === "string") {
      if (rules.minLength && value.length < rules.minLength) {
        errors.push(`${field} must be at least ${rules.minLength} characters long`);
      }

      if (rules.maxLength && value.length > rules.maxLength) {
        errors.push(`${field} must be at most ${rules.maxLength} characters long`);
      }
    }

    if (rules.pattern && !rules.pattern.test(value)) {
      errors.push(rules.patternMessage || `${field} format is invalid`);
    }

    if (rules.enum && !rules.enum.includes(value)) {
      errors.push(`${field} must be one of: ${rules.enum.join(", ")}`);
    }

    if (typeof rules.custom === "function") {
      const customResult = rules.custom(value, field);

      if (typeof customResult === "string" && customResult) {
        errors.push(customResult);
      }
    }

    return errors;
  }

  static isExpectedType(value, type) {
    if (type === "array") {
      return Array.isArray(value);
    }

    return typeof value === type;
  }
}

module.exports = RequestValidator;
