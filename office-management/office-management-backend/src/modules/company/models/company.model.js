const mongoose = require("mongoose")

const companySchema = new mongoose.Schema({

 name:{
  type:String,
  required:true
 },

 email:{
  type:String,
  required:true,
  unique:true
 },

 phone:{
  type:String
 },

 address:{
  type:String
 },

 industry:{
  type:String
 },

 logo:{
  type:String
 },

 plan:{
  type:String,
  default:"free"
 },

 isActive:{
  type:Boolean,
  default:true
 }

},{timestamps:true})

module.exports = mongoose.model("Company",companySchema)