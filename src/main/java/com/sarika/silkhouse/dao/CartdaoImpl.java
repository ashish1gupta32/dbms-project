package com.sarika.silkhouse.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;

import com.sarika.silkhouse.dao.Cartdao;
import com.sarika.silkhouse.model.Cart;
import com.sarika.silkhouse.model.Category;
import com.sarika.silkhouse.model.Items;
import com.sarika.silkhouse.model.User;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class CartdaoImpl implements Cartdao {
	@Autowired
	DataSource datasource;
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	public void addtocart(int iid, String uid, Cart cart) {

		String s = "select * from cart_details where cart_id='" + uid + "'and product_id='" + iid + "'";
		if (jdbcTemplate.query(s, new ResultSetExtractor<Cart>() {
			public Cart extractData(ResultSet rs) throws SQLException {
				if (rs.next()) {
					Cart cart = new Cart();
					return cart;
				}
				return null;
			}
		}) == null) {
			String priceSql = "select price from products where product_id=?";
			Long price = jdbcTemplate.queryForObject(priceSql, new Object[] { iid }, Long.class);

			String sql = "insert into cart_details(cart_id, product_id, quantity, total_price) values(?, ?, 1, ?)";
			Object object[] = { uid, iid, price };
			jdbcTemplate.update(sql, object);
		}
	}

	public List<Cart> getcart(String uid) {

		List<Cart> list;
		// String sql2="select * from items,cart where items.iid=cart.iid and
		// cart.uid='"+uid+"'";
		String sql = "select products.product_id,cart_details.quantity,cart_details.total_price,products.name,products.price,products.discount from products inner join cart_details on products.product_id=cart_details.product_id where cart_details.cart_id='"
				+ uid + "'";
		list = (List<Cart>) jdbcTemplate.query(sql, new BeanPropertyRowMapper<Cart>(Cart.class));
		return list;
	}

	public void addquantity(int quantity, int iid, String uid, Cart cart) {

		String p = "select price from products where product_id=" + iid;
		// float p= Float.parseFloat(s);
		float price = jdbcTemplate.query(p, new ResultSetExtractor<Items>() {
			public Items extractData(ResultSet rs) throws SQLException {
				if (rs.next()) {
					Items it = new Items();
					it.setPrice(rs.getInt("price"));
					return it;
				}
				return null;
			}
		}).getPrice();
		price = price * quantity;
		String sql = "update cart_details set quantity=" + quantity + ",total_price=" + price + "where product_id="
				+ iid + " and cart_id='" + uid + "'";
		jdbcTemplate.execute(sql);
	}

	public void deleteItem(int itemId, String uid) {
		// TODO Auto-generated method stub
		String sql = "delete from cart_details where product_id=" + itemId + " and cart_id='" + uid + "'";
		jdbcTemplate.update(sql);
	}

	public int gettotal(String uid) {
		// TODO Auto-generated method stub
		String sql = "select sum(total_price) from cart_details where cart_id='" + uid + "'";
		Cart total = jdbcTemplate.query(sql, new ResultSetExtractor<Cart>() {
			public Cart extractData(ResultSet rs) throws SQLException {
				if (rs.next()) {
					Cart cart = new Cart();
					cart.setTotal_price(rs.getInt("sum(total_price)"));
					return cart;
				}
				return null;
			}
		});
		if (total != null)
			return total.getTotal_price();

		return 0;
	}

}
