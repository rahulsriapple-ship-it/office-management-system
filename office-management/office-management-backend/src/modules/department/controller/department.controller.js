const asyncHandler = require("../../../extensions/asyncHandler")
const ResponseFormatter = require("../../../utils/responseFormatter")
const departmentService = require("../services/department.service")

exports.createDepartment = asyncHandler(async(req,res)=>{
 const department = await departmentService.createDepartment(req.body,req.user)

 res.status(201).json(
  ResponseFormatter.success("Department created successfully",{
   department
  })
 )
})

exports.listDepartments = asyncHandler(async(req,res)=>{
 const departments = await departmentService.listDepartments(req.user)

 res.status(200).json(
  ResponseFormatter.success("Departments fetched successfully",{
   departments
  })
 )
})

exports.updateDepartment = asyncHandler(async(req,res)=>{
 const department = await departmentService.updateDepartment(
  req.params.id,
  req.body,
  req.user
 )

 res.status(200).json(
  ResponseFormatter.success("Department updated successfully",{
   department
  })
 )
})

exports.deleteDepartment = asyncHandler(async(req,res)=>{
 await departmentService.deleteDepartment(req.params.id,req.user)

 res.status(200).json(
  ResponseFormatter.success("Department deleted successfully")
 )
})
