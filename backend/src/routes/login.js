const express = require('express');
const router = express.Router();
const userController = require('../controllers/UserController');

router.post('/', userController.login);
router.post('/refresh-token', userController.refreshToken);

module.exports = router;