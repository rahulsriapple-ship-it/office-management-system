const bcrypt = require("bcrypt")
const crypto = require("crypto")
const User = require("../models/user.model")
const ApiError = require("../../../utils/apiError")

exports.login = async(data)=>{
 const user = await User.findOne({email:data.email}).populate("company")

 if(!user){
  throw new ApiError(401,"Invalid email or password")
 }

 if(!user.isActive){
  throw new ApiError(403,"User account is inactive")
 }

 const isPasswordValid = await bcrypt.compare(data.password,user.password)

 if(!isPasswordValid){
  throw new ApiError(401,"Invalid email or password")
 }

 return user
}

exports.forgotPassword = async(data)=>{
 const user = await User.findOne({email:data.email})

 if(!user){
  return {
   message:"If the account exists, a password reset link has been generated.",
   resetToken:null
  }
 }

 const resetToken = crypto.randomBytes(32).toString("hex")
 const hashedToken = crypto.createHash("sha256").update(resetToken).digest("hex")

 user.resetPasswordToken = hashedToken
 user.resetPasswordExpiresAt = new Date(Date.now() + 1000 * 60 * 15)
 await user.save()

 return {
  message:"Password reset token generated successfully.",
  resetToken
 }
}

exports.resetPassword = async(data)=>{
 const hashedToken = crypto.createHash("sha256").update(data.token).digest("hex")

 const user = await User.findOne({
  resetPasswordToken:hashedToken,
  resetPasswordExpiresAt:{$gt:new Date()}
 })

 if(!user){
  throw new ApiError(400,"Reset token is invalid or expired")
 }

 user.password = await bcrypt.hash(data.password,10)
 user.resetPasswordToken = null
 user.resetPasswordExpiresAt = null
 await user.save()

 return user
}

exports.getCurrentUser = async(userId)=>{
 const user = await User.findById(userId)
  .populate("company")
  .populate("department")

 if(!user){
  throw new ApiError(401,"Invalid or expired token")
 }

 if(!user.isActive){
  throw new ApiError(403,"User account is inactive")
 }

 return user
}
