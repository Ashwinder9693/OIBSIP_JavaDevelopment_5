package com.library.service;

import com.library.dao.CategoryDAO;
import com.library.entity.Category;
import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO;
    
    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }
    
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }
    
    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }
    
    public boolean addCategory(Category category) {
        return categoryDAO.addCategory(category);
    }
    
    public boolean updateCategory(Category category) {
        return categoryDAO.updateCategory(category);
    }
    
    public boolean deleteCategory(int categoryId) {
        return categoryDAO.deleteCategory(categoryId);
    }
}

