const jwt = require("jsonwebtoken")
const User = require("../modules/auth/models/user.model")
const ApiError = require("../utils/apiError")

module.exports = async(req,_res,next)=>{
 try{
  const authorizationHeader = req.headers.authorization

  if(!authorizationHeader || !authorizationHeader.startsWith("Bearer ")){
   return next(new ApiError(401,"Authorization token is required"))
  }

  const token = authorizationHeader.split(" ")[1]
  const decoded = jwt.verify(token,process.env.JWT_SECRET)

  const user = await User.findById(decoded.id)

  if(!user){
   return next(new ApiError(401,"Invalid or expired token"))
  }

  req.user = {
   id:user._id,
   role:user.role,
   company:user.company
  }

  return next()
 }catch(error){
  return next(new ApiError(401,"Invalid or expired token"))
 }
}
