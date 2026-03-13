const ApiError = require("../utils/apiError")

module.exports = (...roles)=>(req,_res,next)=>{
 if(!req.user){
  return next(new ApiError(401,"User context is required"))
 }

 if(!roles.includes(req.user.role)){
  return next(new ApiError(403,"You do not have access to this resource"))
 }

 return next()
}
