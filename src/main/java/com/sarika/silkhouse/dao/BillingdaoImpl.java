package com.sarika.silkhouse.dao;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import com.sarika.silkhouse.model.Billing;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class BillingdaoImpl implements Billingdao {
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

    public void addtobill(Billing bill) {
        // TODO Auto-generated method stub
        String sql = "insert into billing set customer_id=?,billing_date=?,modeofpayment=?";
        Object[] obj = { bill.getCustomer_id(), bill.getBilling_date(), bill.getModeofpayment() };
        jdbcTemplate.update(sql, obj);
    }

    public void addtobill_details(Billing bill, Long price) {
        // TODO Auto-generated method stub
        String sql = "insert into billing_details set billing_id=?,product_id=?,quantity=?,price=?";
        String sql2 = " select max(billing_id) from billing";
        Long mx = jdbcTemplate.queryForObject(sql2, Long.class);
        price = price * bill.getQuantity();
        Object[] obj = { mx, bill.getProduct_id(), bill.getQuantity(), price };
        jdbcTemplate.update(sql, obj);
        String sql4 = "update products set stock=stock-" + bill.getQuantity() + " where product_id="
                + bill.getProduct_id() + "";
        jdbcTemplate.update(sql4);
    }

    public List<Billing> billing_details(Long bid) {
        // TODO Auto-generated method stub
        List<Billing> list;
        String sql = "select * from billing_details  where billing_id= " + bid + "";
        list = (List<Billing>) jdbcTemplate.query(sql, new BeanPropertyRowMapper<Billing>(Billing.class));
        return list;
    }

    public Long billid() {
        // TODO Auto-generated method stub
        String sql2 = " select max(billing_id) from billing";
        Long mx = jdbcTemplate.queryForObject(sql2, Long.class);
        return mx;
    }

    public Long customerid() {
        // TODO Auto-generated method stub
        String sql2 = " select max(customer_id) from billing where billing_id=(select max(billing_id) from billing)";
        Long mx = jdbcTemplate.queryForObject(sql2, Long.class);
        return mx;
    }

    public Long getprice(int pid) {
        // TODO Auto-generated method stub
        String sql2 = " select max(price) from products where product_id=" + pid + "";
        Long mx = jdbcTemplate.queryForObject(sql2, Long.class);
        return mx;
    }

    public Long gettotalprice(Long bid) {
        // TODO Auto-generated method stub
        String sql2 = " select sum(price) from billing_details where billing_id=" + bid + "";
        Long mx = jdbcTemplate.queryForObject(sql2, Long.class);
        return mx;
    }

}
