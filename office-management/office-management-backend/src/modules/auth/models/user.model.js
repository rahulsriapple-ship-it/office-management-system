const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({

 name:{
  type:String,
  required:true
 },

 email:{
  type:String,
  required:true,
  unique:true
 },

 password:{
  type:String,
  required:true
 },

 role:{
  type:String,
  enum:["SUPER_ADMIN","ADMIN","MANAGER","EMPLOYEE"],
  default:"EMPLOYEE"
 },

 company:{
  type:mongoose.Schema.Types.ObjectId,
  ref:"Company"
 },

 department:{
  type:mongoose.Schema.Types.ObjectId,
  ref:"Department"
 },

 phone:String,

 designation:String,

 employeeCode:String,

 joiningDate:Date,

 profileImage:String,

 resetPasswordToken:{
  type:String,
  default:null
 },

 resetPasswordExpiresAt:{
  type:Date,
  default:null
 },

 isActive:{
  type:Boolean,
  default:true
 }

},{timestamps:true})

module.exports = mongoose.model("User",userSchema)
