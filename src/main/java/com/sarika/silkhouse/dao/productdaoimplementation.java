package com.sarika.silkhouse.dao;

import java.util.List;

import javax.sql.DataSource;

import com.sarika.silkhouse.model.Item;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class productdaoimplementation implements productdao {
  @Autowired
  DataSource datasource;
  @Autowired
  private JdbcTemplate jdbcTemplate;

  public productdaoimplementation() {

  }

  public productdaoimplementation(DataSource datasource) {
    this.jdbcTemplate = new JdbcTemplate(datasource);
  }

  public List<Item> getAllItems() {
    List<Item> list;
    String sql = "select product_id,name,material,product_type,product_category, price,discount,stock from products";
    list = (List<Item>) jdbcTemplate.query(sql, new BeanPropertyRowMapper<Item>(Item.class));
    return list;
  }

  public List<Item> getfilterItems(String ftr1, String ftr2) {
    List<Item> list;
    String sql = "select product_id,name,material,product_type,product_category,price, discount,stock from products where product_category= '"
        + ftr1 + "' and product_type= '" + ftr2 + "'";
    list = (List<Item>) jdbcTemplate.query(sql, new BeanPropertyRowMapper<Item>(Item.class));
    return list;
  }

  public List<Item> getfilterItems(String ftr1) {
    List<Item> list;
    String sql = "select product_id,name,material,product_type,product_category, price, discount,stock from products where product_category= '"
        + ftr1 + "'";
    list = (List<Item>) jdbcTemplate.query(sql, new BeanPropertyRowMapper<Item>(Item.class));
    return list;
  }

  public void save(Item items) {
    String sql = " insert into products set name=?,product_type=?,product_category=?,stock=?,discount=?,price=?,material=?";
    Object[] obj1 = { items.getName(), items.getProduct_type(), items.getProduct_category(), items.getStock(),
        items.getDiscount(), items.getPrice(), items.getMaterial() };
    jdbcTemplate.update(sql, obj1);
  }

}