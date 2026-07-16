const { rateLimit, ipKeyGenerator } = require("express-rate-limit");

const createRateLimiter = ({
    windowMs = 15 * 60 * 1000,
    max = 100,
    keyGenerator = (req) =>
        `${ipKeyGenerator(req)}:${(req.body.email || "").toLowerCase()}`,
    message = "Quá nhiều yêu cầu, vui lòng thử lại sau."
} = {}) =>
    rateLimit({
        windowMs,
        max,
        keyGenerator,
        standardHeaders: true,
        legacyHeaders: false,
        message: { status: "error", message },
    });

module.exports = { createRateLimiter };