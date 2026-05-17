---
title: "Entity: Billing"
category: entity
tags: [billing, payment, db-table, billing_details]
last_updated: "2026-05-17"
source_count: 2
---

# Entity: Billing

## Summary
`Billing` covers two DB tables: `billing` (the header/invoice) and `billing_details` (the line items). Both are managed through the admin interface. This is a **store-side billing system** — not a customer self-checkout flow. An admin creates a billing record, adds products to it, and processes payment.

---

## Source Files
- `model/Billing.java` — combined POJO for header + line item fields
- `dao/Billingdao.java` + `dao/BillingdaoImpl.java` — data access
- `AdminController.java` — billing management routes
- `schema.sql` → `billing` + `billing_details` DDL

---

## Fields (Billing POJO — maps to both tables)

| Field | Mapped To | Notes |
|---|---|---|
| `billing_id` | `billing.billing_id` | Auto-incremented PK |
| `customer_id` | `billing.customer_id` | FK → `customer.customer_id` |
| `billing_date` | `billing.billing_date` | Stored as VARCHAR(20) — not a DATE type |
| `billing_price` | `billing.billing_price` | Total; calculated from line items |
| `modeofpayment` | `billing.modeofpayment` | e.g., `"Cash"`, `"Card"` |
| `product_id` | `billing_details.product_id` | Line item product |
| `quantity` | `billing_details.quantity` | Line item quantity |
| `price` | `billing_details.price` | Line item price |

---

## DB Tables

### `billing` (header)
```sql
CREATE TABLE `billing` (
  `billing_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) DEFAULT NULL,
  `billing_date` varchar(20) DEFAULT NULL,
  `billing_price` bigint(20) DEFAULT '0',
  `modeofpayment` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  CONSTRAINT `billing_ibfk_1`
    FOREIGN KEY (`customer_id`) REFERENCES `customer`(`customer_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);
```

### `billing_details` (line items)
```sql
CREATE TABLE `billing_details` (
  `billing_id` bigint(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` bigint(20) DEFAULT '0',
  PRIMARY KEY (`billing_id`, `product_id`),
  CONSTRAINT `billing_details_ibfk_1`
    FOREIGN KEY (`billing_id`) REFERENCES `billing`(`billing_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `billing_details_ibfk_2`
    FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);
```

---

## DAO Methods (BillingdaoImpl)

| Method | Description |
|---|---|
| `addtobill(Billing)` | INSERT into `billing` |
| `addtobill_details(Billing, Long price)` | INSERT into `billing_details` |
| `billid()` | Get latest/current billing_id (for active session billing) |
| `customerid()` | Get customer_id of current bill |
| `billing_details(Long bid)` | Get all line items for a billing_id |
| `getprice(int productId)` | Look up product price from `products` table |
| `gettotalprice(Long bid)` | SUM of prices for a billing_id |

---

## Admin Billing Flow

1. `GET /admin/billing` → blank billing header form
2. `POST /admin/billing` → creates billing record → redirects to `/admin/billing/details`
3. `GET /admin/billing/details` → shows current bill + form to add line items
4. `POST /admin/billing/details` → adds line item (looks up price from `products`)
5. `GET /admin/payment` → shows full bill summary with total price

---

## Related Pages
- [Customer entity](Customer.md) — billing references customer
- [Item entity](Item.md) — billing_details references products
- [Admin Routes](../endpoints/admin-routes.md)
- [Data Access Layer](../concepts/data-access-layer.md)
