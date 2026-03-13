const formatLog = (level, message, meta = {}) =>
  JSON.stringify({
    timestamp: new Date().toISOString(),
    level,
    message,
    ...meta,
  });

const logger = {
  info(message, meta) {
    console.log(formatLog("info", message, meta));
  },

  warn(message, meta) {
    console.warn(formatLog("warn", message, meta));
  },

  error(message, meta) {
    console.error(formatLog("error", message, meta));
  },
};

module.exports = logger;
