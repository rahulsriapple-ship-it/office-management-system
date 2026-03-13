const express = require("express")
const router = express.Router()
const controller = require("../controller/company.controller")
const validateRequest = require("../../../middleware/validate.middleware")
const { registerCompanySchema } = require("../validation/company.validation")

/**
 * @openapi
 * /api/company/register:
 *   post:
 *     tags:
 *       - Company
 *     summary: Register a company and its admin user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - companyName
 *               - adminName
 *               - email
 *               - password
 *             properties:
 *               companyName:
 *                 type: string
 *                 example: Acme Inc
 *               adminName:
 *                 type: string
 *                 example: Rahul Sharma
 *               email:
 *                 type: string
 *                 format: email
 *                 example: admin@acme.com
 *               phone:
 *                 type: string
 *                 example: 9876543210
 *               password:
 *                 type: string
 *                 format: password
 *                 example: StrongPassword123
 *     responses:
 *       201:
 *         description: Company registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiSuccessResponse'
 *       422:
 *         description: Validation failed
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiErrorResponse'
 *       400:
 *         description: Company already exists
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiErrorResponse'
 */
router.post("/register", validateRequest(registerCompanySchema), controller.registerCompany)

module.exports = router
