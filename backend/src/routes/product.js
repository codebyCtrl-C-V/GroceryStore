const express = require("express");
const router = express.Router();
const productController = require("../controllers/ProductController");

router.get("/search", productController.searchProducts);
router.get("/new", productController.getNewProducts);
router.get("/for_home", productController.getProductsForHome);
router.get("/:slug", productController.getProduct);

module.exports = router;
