const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

// Middleware xác thực JWT
const authMiddleware = (req, res, next) => {
    let token = req.cookies.token;
    
    // Also check Authorization header
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
        token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
        return res.status(401).json({ status: "error", message: "Unauthorized" });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
             return res.status(401).json({ status: "error", message: "Token đã hết hạn", code: "TOKEN_EXPIRED" });
        }
        return res.status(403).json({ status: "error", message: "Token không hợp lệ" });
    }
};

// Middleware kiểm tra role admin
const adminMiddleware = (req, res, next) => {
    if (req.user.role !== "admin") return res.status(403).json({ status: "error", message: "Bạn không có quyền!" });
    next();
};

module.exports = { authMiddleware, adminMiddleware };
