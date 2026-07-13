const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/CategoryController');

router.get('/', categoryController.getAllCategories);
router.get('/sale/vegetables-fruits', categoryController.getProductsSale);
router.get('/sale/proceed', categoryController.getProductsSaleProceed);
router.get('/:slug', categoryController.getCategoryProducts);

module.exports = router;
