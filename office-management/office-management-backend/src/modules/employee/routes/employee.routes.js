const express = require("express")
const multer = require("multer")
const router = express.Router()
const controller = require("../controller/employee.controller")
const validateRequest = require("../../../middleware/validate.middleware")
const auth = require("../../../middleware/auth.middleware")
const authorizeRoles = require("../../../middleware/role.middleware")
const {
 registerEmployeeSchema,
 updateEmployeeSchema
} = require("../validation/employee.validation")

const upload = multer({
 storage:multer.memoryStorage(),
 limits:{
  fileSize:5 * 1024 * 1024
 }
})

/**
 * @openapi
 * /api/employees:
 *   post:
 *     tags:
 *       - Employee
 *     summary: Create an employee under a department
 *     security:
 *       - bearerAuth: []
 *   get:
 *     tags:
 *       - Employee
 *     summary: List employees for the logged-in admin company
 *     security:
 *       - bearerAuth: []
 */
router.post(
 "/",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 validateRequest(registerEmployeeSchema),
 controller.registerEmployee
)

router.put(
 "/:id",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 validateRequest(updateEmployeeSchema),
 controller.updateEmployee
)

router.delete(
 "/:id",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 controller.deleteEmployee
)

router.get(
 "/",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 controller.listEmployees
)

/**
 * @openapi
 * /api/employees/import:
 *   post:
 *     tags:
 *       - Employee
 *     summary: Import employees from an Excel file
 *     security:
 *       - bearerAuth: []
 */
router.post(
 "/import",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 upload.single("file"),
 controller.importEmployees
)

module.exports = router
