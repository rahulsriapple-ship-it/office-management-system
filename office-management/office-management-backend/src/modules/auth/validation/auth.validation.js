const loginSchema = {
  body: {
    email: {
      required: true,
      type: "string",
      trim: true,
      pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      patternMessage: "email must be a valid email address",
    },
    password: {
      required: true,
      type: "string",
      minLength: 8,
      maxLength: 64,
    },
  },
};

const forgotPasswordSchema = {
  body: {
    email: {
      required: true,
      type: "string",
      trim: true,
      pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      patternMessage: "email must be a valid email address",
    },
  },
};

const resetPasswordSchema = {
  body: {
    token: {
      required: true,
      type: "string",
      trim: true,
      minLength: 20,
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
  loginSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
};
