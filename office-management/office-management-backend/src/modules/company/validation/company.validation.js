const registerCompanySchema = {
  body: {
    companyName: {
      required: true,
      type: "string",
      trim: true,
      minLength: 2,
      maxLength: 120,
    },
    adminName: {
      required: true,
      type: "string",
      trim: true,
      minLength: 2,
      maxLength: 120,
    },
    email: {
      required: true,
      type: "string",
      trim: true,
      pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      patternMessage: "email must be a valid email address",
    },
    phone: {
      type: "string",
      trim: true,
      minLength: 7,
      maxLength: 20,
    },
    password: {
      required: true,
      type: "string",
      minLength: 8,
      maxLength: 64,
    },
  },
};

module.exports = {
  registerCompanySchema,
};
