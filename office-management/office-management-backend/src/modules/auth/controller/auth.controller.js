const asyncHandler = require("../../../extensions/asyncHandler")
const ResponseFormatter = require("../../../utils/responseFormatter")
const authService = require("../services/auth.service")
const tokenService = require("../../../services/token.service")

exports.login = asyncHandler(async(req,res)=>{
 const user = await authService.login(req.body)
 const token = tokenService.generateToken(user)
 res.status(200).json(
  ResponseFormatter.success("Login successful",{
   user,
   token
  })
 )
})

exports.forgotPassword = asyncHandler(async(req,res)=>{
 const result = await authService.forgotPassword(req.body)

 res.status(200).json(
  ResponseFormatter.success(result.message,{
   resetToken: result.resetToken
  })
 )
})

exports.resetPassword = asyncHandler(async(req,res)=>{
 await authService.resetPassword(req.body)

 res.status(200).json(
  ResponseFormatter.success("Password reset successfully")
 )
})

exports.me = asyncHandler(async(req,res)=>{
 const user = await authService.getCurrentUser(req.user.id)

 res.status(200).json(
  ResponseFormatter.success("Session restored successfully",{
   user
  })
 )
})
