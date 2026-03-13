const asyncHandler = require("../../../extensions/asyncHandler")
const ResponseFormatter = require("../../../utils/responseFormatter")
const employeeService = require("../services/employee.service")

exports.registerEmployee = asyncHandler(async(req,res)=>{
 const employee = await employeeService.registerEmployee(req.body,req.user)

 res.status(201).json(
  ResponseFormatter.success("Employee created successfully",{
   employee
  })
 )
})

exports.listEmployees = asyncHandler(async(req,res)=>{
 const employees = await employeeService.listEmployees(req.user)

 res.status(200).json(
  ResponseFormatter.success("Employees fetched successfully",{
   employees
  })
 )
})

exports.importEmployees = asyncHandler(async(req,res)=>{
 const summary = await employeeService.importEmployees(req.file,req.user)

 res.status(200).json(
  ResponseFormatter.success("Employee import completed",{
   summary
  })
 )
})

exports.updateEmployee = asyncHandler(async(req,res)=>{
 const employee = await employeeService.updateEmployee(
  req.params.id,
  req.body,
  req.user
 )

 res.status(200).json(
  ResponseFormatter.success("Employee updated successfully",{
   employee
  })
 )
})

exports.deleteEmployee = asyncHandler(async(req,res)=>{
 await employeeService.deleteEmployee(req.params.id,req.user)

 res.status(200).json(
  ResponseFormatter.success("Employee deleted successfully")
 )
})
