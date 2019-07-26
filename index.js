if (process.env.NODE_ENV === "production") {
  module.exports = require("./dist/sunzitong-tools.min.js");
} else {
  module.exports = require("./dist/sunzitong-tools.js");
}