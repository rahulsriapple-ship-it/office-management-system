const bcrypt = require("bcrypt")
const xlsx = require("xlsx")
const User = require("../../auth/models/user.model")
const Department = require("../../department/models/department.model")
const ApiError = require("../../../utils/apiError")

exports.registerEmployee = async(data,user)=>{
 const existingUser = await User.findOne({email:data.email})

 if(existingUser){
  throw new ApiError(400,"Employee email already exists")
 }

 const department = await Department.findOne({
  _id:data.departmentId,
  company:user.company
 })

 if(!department){
  throw new ApiError(404,"Department not found for this company")
 }

 const hashedPassword = await bcrypt.hash(data.password,10)

 const employee = await User.create({
  name:data.name,
  email:data.email,
  password:hashedPassword,
  role:data.role || "EMPLOYEE",
  company:user.company,
  phone:data.phone,
  department:department._id,
  designation:data.designation,
  employeeCode:data.employeeCode,
  joiningDate:data.joiningDate
 })

 return employee
}

exports.listEmployees = async(user)=>{
 return User.find({
  company:user.company,
  role:{$in:["EMPLOYEE","MANAGER"]}
 }).populate("department").sort({createdAt:-1})
}

exports.updateEmployee = async(id,data,user)=>{
 const employee = await User.findOne({
  _id:id,
  company:user.company,
  role:{$in:["EMPLOYEE","MANAGER"]}
 })

 if(!employee){
  throw new ApiError(404,"Employee not found")
 }

 const duplicateEmployee = await User.findOne({
  _id:{$ne:id},
  company:user.company,
  email:data.email
 })

 if(duplicateEmployee){
  throw new ApiError(400,"Employee email already exists")
 }

 const department = await Department.findOne({
  _id:data.departmentId,
  company:user.company
 })

 if(!department){
  throw new ApiError(404,"Department not found for this company")
 }

 employee.name = data.name
 employee.email = data.email
 employee.phone = data.phone
 employee.designation = data.designation
 employee.employeeCode = data.employeeCode
 employee.role = data.role || "EMPLOYEE"
 employee.department = department._id
 employee.joiningDate = data.joiningDate || employee.joiningDate

 if(data.password){
  employee.password = await bcrypt.hash(data.password,10)
 }

 await employee.save()
 return employee
}

exports.deleteEmployee = async(id,user)=>{
 const employee = await User.findOne({
  _id:id,
  company:user.company,
  role:{$in:["EMPLOYEE","MANAGER"]}
 })

 if(!employee){
  throw new ApiError(404,"Employee not found")
 }

 await User.deleteOne({_id:employee._id})
}

exports.importEmployees = async(file,user)=>{
 if(!file){
  throw new ApiError(400,"Excel file is required")
 }

 const workbook = xlsx.read(file.buffer,{type:"buffer"})
 const firstSheetName = workbook.SheetNames[0]
 const worksheet = workbook.Sheets[firstSheetName]
 const rows = xlsx.utils.sheet_to_json(worksheet,{defval:""})

 if(rows.length === 0){
  throw new ApiError(400,"Uploaded file does not contain employee rows")
 }

 const summary = {
  total:rows.length,
  created:0,
  updated:0,
  skipped:0,
  errors:[]
 }

 for(const [index,row] of rows.entries()){
  const name = String(row.name || row.Name || "").trim()
  const email = String(row.email || row.Email || "").trim().toLowerCase()
  const departmentName = String(row.department || row.Department || "").trim()
  const designation = String(row.designation || row.Designation || "").trim()
  const phone = String(row.phone || row.Phone || "").trim()
  const employeeCode = String(row.employeeCode || row.EmployeeCode || "").trim()
  const joiningDateValue = row.joiningDate || row.JoiningDate || null
  const password = String(row.password || row.Password || "ChangeMe123").trim()

  if(!name || !email){
   summary.skipped += 1
   summary.errors.push(`Row ${index + 2}: name and email are required`)
   continue
  }

  let department = null

  if(departmentName){
   department = await Department.findOneAndUpdate(
    {
     company:user.company,
     name:departmentName
    },
    {
     $setOnInsert:{
      company:user.company,
      createdBy:user.id
     }
    },
    {
     new:true,
     upsert:true
    }
   )
  }

  const hashedPassword = await bcrypt.hash(password,10)
  const joiningDate = joiningDateValue ? new Date(joiningDateValue) : null

  const existingEmployee = await User.findOne({
   email,
   company:user.company
  })

  if(existingEmployee){
   existingEmployee.name = name
   existingEmployee.phone = phone || existingEmployee.phone
   existingEmployee.designation = designation || existingEmployee.designation
   existingEmployee.department = department?._id || existingEmployee.department
   existingEmployee.employeeCode = employeeCode || existingEmployee.employeeCode
   existingEmployee.joiningDate = joiningDate || existingEmployee.joiningDate
   existingEmployee.role = existingEmployee.role === "ADMIN" ? "ADMIN" : "EMPLOYEE"
   await existingEmployee.save()
   summary.updated += 1
   continue
  }

  await User.create({
   name,
   email,
   password:hashedPassword,
   role:"EMPLOYEE",
   company:user.company,
   phone,
   designation,
   department:department?._id,
   employeeCode,
   joiningDate
  })

  summary.created += 1
 }

 return summary
}
