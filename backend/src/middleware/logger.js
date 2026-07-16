const morgan = require("morgan");
const logger = require("../utils/logger");

const stream = {
    write: (message) => {
        logger.info(message.trim());
    },
};

const requestLogger = morgan(
    ":method :url :status :response-time ms - :res[content-length]",
    { stream }
);

const errorHandler = (err, req, res, next) => {
    logger.error(
        `${req.method} ${req.originalUrl}\n${err.stack}`
    );

    res.status(err.status || 500).json({
        status: "error",
        message: err.message || "Internal Server Error",
    });
};

module.exports = {
    requestLogger,
    errorHandler,
};