const express = require("express");
const path = require("path");
const app = express();
const cors = require("cors");

// config cors
app.use(
  cors({
    origin: "http://localhost:5173",
    credentials: true,
  }),
);

//Kết nối cơ sở dữ liệu
const db = require("./config/database");
db.Sequelize;

// Middleware xử lý file tĩnh
app.use(express.static(path.join(__dirname, "public")));

// Middleware xử lý dữ liệu từ form
const cookieParser = require("cookie-parser");
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());

//Load danh mục sản phẩm
const getCategories = require("./middleware/getCategories");
app.use(getCategories);

//import session
const session = require("express-session");
const dotenv = require("dotenv");
dotenv.config();
app.use(
  session({
    secret: process.env.SECRET_KEY,
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 3600000 }, // 1 giờ
  }),
);

// Import routes
const indexRoutes = require("./routes/index");
const adminRoutes = require("./routes/admin");
const productRoutes = require("./routes/product");
const loginRoutes = require("./routes/login");
const registerRoutes = require("./routes/register");
const logoutRoutes = require("./routes/logout");
const profileRoutes = require("./routes/profile");
const categoryRoutes = require("./routes/category");
const newsRoutes = require("./routes/news");
const cartRoutes = require("./routes/cart");
const checkoutRoutes = require("./routes/checkout");
const orderRoutes = require("./routes/order");
const paymentRoutes = require("./routes/payment.routes");
const chatbotRoutes = require("./routes/chatbot");

app.use("/api/v1/", indexRoutes);
app.use("/api/v1/admin", adminRoutes);
app.use("/api/v1/product", productRoutes);
app.use("/api/v1/login", loginRoutes);
app.use("/api/v1/register", registerRoutes);
app.use("/api/v1/logout", logoutRoutes);
app.use("/api/v1/profile", profileRoutes);
app.use("/api/v1/category", categoryRoutes);
app.use("/api/v1/news", newsRoutes);
app.use("/api/v1/cart", cartRoutes);
app.use("/api/v1/checkout", checkoutRoutes);
app.use("/api/v1/orders", orderRoutes);
app.use("/api/v1/payment", paymentRoutes);
app.use("/api/v1/chatbot", chatbotRoutes);

// Khởi động server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});
