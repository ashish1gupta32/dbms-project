package com.sarika.silkhouse.dao;

import java.util.List;

import com.sarika.silkhouse.model.Category;
import com.sarika.silkhouse.model.User;

public interface Categorydao {
	public List<Category> getallcat();

	public void addCat(Category category);

	public List<User> getallusers();

}
