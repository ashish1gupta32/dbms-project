package com.sarika.silkhouse.model;

@SuppressWarnings("deprecation")
public class Billing {
    Long billing_id;
    int product_id;
    int quantity;
    long customer_id;
    String billing_date;
    Long billing_price;
    String modeofpayment;
    Long price;

    public Billing() {
    }

    public Billing(int product_id, int quantity) {
        this.product_id = product_id;
        this.quantity = quantity;
    }

    public Billing(Long customer_id, String billing_date, String modeofpayment) {
        this.customer_id = customer_id;
        this.billing_date = billing_date;
        this.modeofpayment = modeofpayment;
    }

    public Long getBilling_id() {
        return billing_id;
    }

    public void setBilling_id(Long billing_id) {
        this.billing_id = billing_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(long customer_id) {
        this.customer_id = customer_id;
    }

    public String getBilling_date() {
        return billing_date;
    }

    public void setBilling_date(String billing_date) {
        this.billing_date = billing_date;
    }

    public Long getBilling_price() {
        return billing_price;
    }

    public void setBilling_price(Long billing_price) {
        this.billing_price = billing_price;
    }

    public String getModeofpayment() {
        return modeofpayment;
    }

    public void setModeofpayment(String modeofpayment) {
        this.modeofpayment = modeofpayment;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }

}