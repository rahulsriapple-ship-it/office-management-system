const Company = require("../models/company.model")
const User = require("../../auth/models/user.model")
const bcrypt = require("bcrypt")
const ApiError = require("../../../utils/apiError")

exports.registerCompany = async(data)=>{

 const existingCompany = await Company.findOne({email:data.email})

 if(existingCompany){
  throw new ApiError(400,"Company already exists")
 }

 const company = await Company.create({
  name:data.companyName,
  email:data.email,
  phone:data.phone
 })

 const hashedPassword = await bcrypt.hash(data.password,10)
 const adminUser = await User.create({
  name:data.adminName,
  email:data.email,
  password:hashedPassword,
  role:"ADMIN",
  company:company._id
 })

 return {company,adminUser}

}
