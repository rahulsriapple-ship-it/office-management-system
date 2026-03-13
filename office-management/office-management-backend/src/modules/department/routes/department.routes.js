const express = require("express")
const router = express.Router()
const controller = require("../controller/department.controller")
const validateRequest = require("../../../middleware/validate.middleware")
const auth = require("../../../middleware/auth.middleware")
const authorizeRoles = require("../../../middleware/role.middleware")
const {
 createDepartmentSchema,
 updateDepartmentSchema
} = require("../validation/department.validation")

/**
 * @openapi
 * /api/departments:
 *   post:
 *     tags:
 *       - Department
 *     summary: Create a department
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       201:
 *         description: Department created successfully
 *   get:
 *     tags:
 *       - Department
 *     summary: List departments for the logged-in admin company
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Departments fetched successfully
 */
router.post(
 "/",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN"),
 validateRequest(createDepartmentSchema),
 controller.createDepartment
)

router.get(
 "/",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN","MANAGER"),
 controller.listDepartments
)

router.put(
 "/:id",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN"),
 validateRequest(updateDepartmentSchema),
 controller.updateDepartment
)

router.delete(
 "/:id",
 auth,
 authorizeRoles("ADMIN","SUPER_ADMIN"),
 controller.deleteDepartment
)

module.exports = router
