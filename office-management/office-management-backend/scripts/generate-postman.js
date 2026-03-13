const fs = require("fs");
const path = require("path");
const postmanConverter = require("openapi-to-postmanv2");
const buildOpenApiSpec = require("../src/docs/openapi");

const outputDir = path.join(__dirname, "..", "postman");
const outputFile = path.join(outputDir, "office-management.postman_collection.json");

const spec = buildOpenApiSpec();

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

postmanConverter.convert(
  {
    type: "json",
    data: JSON.stringify(spec),
  },
  {
    folderStrategy: "tags",
    includeAuthInfoInExample: true,
    requestNameSource: "fallback",
  },
  (error, result) => {
    if (error) {
      console.error("Failed to generate Postman collection:", error);
      process.exit(1);
    }

    if (!result.result) {
      console.error("Postman conversion failed:", result.reason);
      process.exit(1);
    }

    fs.writeFileSync(outputFile, JSON.stringify(result.output[0].data, null, 2));
    console.log(`Postman collection generated at ${outputFile}`);
  }
);
