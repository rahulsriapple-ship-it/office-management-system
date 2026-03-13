const ResponseFormatter = require("./responseFormatter");

class ApiResponse {

 constructor(success,message,data,meta = null){
  return success
   ? ResponseFormatter.success(message,data,meta)
   : ResponseFormatter.error(message,data)
 }

}

module.exports = ApiResponse
