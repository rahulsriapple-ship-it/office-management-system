const Department = require("../models/department.model")
const ApiError = require("../../../utils/apiError")

exports.createDepartment = async(data,user)=>{
 const existingDepartment = await Department.findOne({
  company:user.company,
  name:data.name
 })

 if(existingDepartment){
  throw new ApiError(400,"Department already exists")
 }

 return Department.create({
  name:data.name,
  description:data.description,
  company:user.company,
  createdBy:user.id
 })
}

exports.listDepartments = async(user)=>{
 return Department.find({
  company:user.company
 }).sort({createdAt:-1})
}

exports.updateDepartment = async(id,data,user)=>{
 const department = await Department.findOne({
  _id:id,
  company:user.company
 })

 if(!department){
  throw new ApiError(404,"Department not found")
 }

 const duplicateDepartment = await Department.findOne({
  _id:{$ne:id},
  company:user.company,
  name:data.name
 })

 if(duplicateDepartment){
  throw new ApiError(400,"Department already exists")
 }

 department.name = data.name
 department.description = data.description
 await department.save()

 return department
}

exports.deleteDepartment = async(id,user)=>{
 const department = await Department.findOne({
  _id:id,
  company:user.company
 })

 if(!department){
  throw new ApiError(404,"Department not found")
 }

 await Department.deleteOne({_id:department._id})
}
