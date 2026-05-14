const express = require('express');
const router = express.Router();
const userController = require('../controllers/UserController');
const {authMiddleware} = require('../middleware/auth');

router.get('/', authMiddleware, userController.profile);
router.post('/update', authMiddleware, userController.updateProfile);
router.post('/change-password', authMiddleware, userController.changePassword);

module.exports = router;