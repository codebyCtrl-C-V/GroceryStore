const express = require("express");
const router = express.Router();
const { authMiddleware, adminMiddleware } = require("../middleware/auth");
const User = require('../models/User');

router.post('/users/fcm-token', authMiddleware, async (req, res) => {
    const { fcmToken } = req.body;

    if (!fcmToken) {
        return res.status(400).json({ status: 'error', message: 'Thiếu fcmToken' });
    }

    try {
        const user = await User.findByPk(req.user.id);
        user.fcmToken = fcmToken;
        await user.save();

        return res.json({ status: 'success' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ status: 'error', message: 'Lỗi server' });
    }
});

router.post('/users/fcm-token/delete', authMiddleware, async (req, res) => {
    try {
        const user = await User.findByPk(req.user.id);
        user.fcmToken = null;
        await user.save();

        return res.json({ status: 'success' });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ status: 'error', message: 'Lỗi server' });
    }
});

module.exports = router;
