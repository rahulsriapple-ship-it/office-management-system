const mongoose = require("mongoose");
const logger = require("../utils/logger");

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    logger.info("Database connected", {
      service: "mongodb",
      host: mongoose.connection.host,
      name: mongoose.connection.name,
    });
  } catch (error) {
    logger.error("Database connection failed", {
      service: "mongodb",
      error: error.message,
    });
    process.exit(1);
  }
};

module.exports = connectDB;
