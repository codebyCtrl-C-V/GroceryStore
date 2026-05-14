const express = require("express");
const router = express.Router();
const productController = require("../controllers/ProductController");
const newsController = require("../controllers/NewsController");

// //Hệ thống cửa hàng
// router.get("/store-system", (req, res) => res.render("pages/storeSystem"));
// //Giới thiệu
// router.get("/introduce", (req, res) => res.render("pages/introduce"));
// //tuyển dụng
// router.get("/recruitment", (req, res) => res.render("pages/recruitment"));
// //chính sách
// router.get("/policy", (req, res) => res.render("pages/policy"));

module.exports = router;
