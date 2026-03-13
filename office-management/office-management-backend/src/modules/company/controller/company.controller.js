const asyncHandler = require("../../../extensions/asyncHandler")
const ResponseFormatter = require("../../../utils/responseFormatter")
const companyService = require("../services/company.service")
const tokenService = require("../../../services/token.service")

exports.registerCompany = asyncHandler(async(req,res)=>{
 const result = await companyService.registerCompany(req.body)
 const token = tokenService.generateToken(result.adminUser)

 res.status(201).json(
  ResponseFormatter.success("Company registered successfully", {
   company: result.company,
   admin: result.adminUser,
   token
  })
 )
})
