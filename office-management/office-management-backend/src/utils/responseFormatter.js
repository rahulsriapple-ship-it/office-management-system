class ResponseFormatter {
  static success(message, data = null, meta = null) {
    const response = {
      success: true,
      message,
      data,
    };

    if (meta) {
      response.meta = meta;
    }

    return response;
  }

  static error(message, errors = null, statusCode = 500) {
    const response = {
      success: false,
      message,
      statusCode,
    };

    if (errors) {
      response.errors = errors;
    }

    return response;
  }
}

module.exports = ResponseFormatter;
