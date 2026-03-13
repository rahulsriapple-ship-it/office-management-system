const express = require("express");
const router = express.Router();
const companyRoutes = require("../modules/company/routes/company.routes")
const authRoutes = require("../modules/auth/routes/auth.routes")
const departmentRoutes = require("../modules/department/routes/department.routes")
const employeeRoutes = require("../modules/employee/routes/employee.routes")

router.use("/company",companyRoutes)
router.use("/auth",authRoutes)
router.use("/departments",departmentRoutes)
router.use("/employees",employeeRoutes)

module.exports = router;
