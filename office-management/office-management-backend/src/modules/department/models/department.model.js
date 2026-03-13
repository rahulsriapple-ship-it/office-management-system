const mongoose = require("mongoose")

const departmentSchema = new mongoose.Schema({
 name:{
  type:String,
  required:true,
  trim:true
 },

 description:{
  type:String,
  trim:true
 },

 company:{
  type:mongoose.Schema.Types.ObjectId,
  ref:"Company",
  required:true
 },

 createdBy:{
  type:mongoose.Schema.Types.ObjectId,
  ref:"User",
  required:true
 },

 isActive:{
  type:Boolean,
  default:true
 }
},{timestamps:true})

departmentSchema.index({company:1,name:1},{unique:true})

module.exports = mongoose.model("Department",departmentSchema)
