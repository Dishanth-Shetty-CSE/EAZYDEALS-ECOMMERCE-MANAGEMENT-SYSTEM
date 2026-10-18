package com.eazydeals.services;

import com.eazydeals.dao.ProductDao;
import com.eazydeals.dao.CategoryDao;
import com.eazydeals.entities.Product;
import java.util.List;

public class ProductService {

	private ProductDao productDao;
	private CategoryDao categoryDao;

	public ProductService(ProductDao productDao, CategoryDao categoryDao) {
		this.productDao = productDao;
		this.categoryDao = categoryDao;
	}

	public List<Product> getProducts(String searchKey, String catId) {
		List<Product> prodList = null;

		if (searchKey != null && !searchKey.isEmpty()) {
			prodList = productDao.getAllProductsBySearchKey(searchKey);
		} else if (catId != null && !catId.trim().equals("0")) {
			prodList = productDao.getAllProductsByCategoryId(Integer.parseInt(catId.trim()));
		} else {
			prodList = productDao.getAllProducts();
		}

		return prodList;
	}

	public String getCategoryName(String catId) {
		if (catId != null && !catId.trim().equals("0")) {
			return categoryDao.getCategoryName(Integer.parseInt(catId.trim()));
		}
		return "All Products";
	}
}