const express = require('express');
const router = express.Router();
const userController = require('../controllers/UserController');
const { createRateLimiter } = require('../middleware/rateLimit');

const loginLimiter = createRateLimiter({
    windowMs: 15 * 60 * 1000,
    max: 10,
});

router.post('/', loginLimiter, userController.login);
router.post('/refresh-token', userController.refreshToken);

module.exports = router;