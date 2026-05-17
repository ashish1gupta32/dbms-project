---
title: "Entity: Item"
category: entity
tags: [item, product, catalog, db-table]
last_updated: "2026-05-17"
source_count: 3
---

# Entity: Item

## Summary
`Item` is the **admin-facing product form model**. It represents a product that an admin can add to the catalog. It maps to the `products` DB table. The user-facing equivalent (returned from DB queries for display) is `Items` — a lighter POJO used in lists and cart calculations.

---

## Source Files
- `model/Item.java` — admin form POJO (with `@NotEmpty` / `@NotNull` validation)
- `model/Items.java` — read-only display POJO (subset of fields)
- `dao/productdao.java` + `dao/productdaoimplementation.java` — data access
- `schema.sql` → `products` table DDL
- `AdminController.java` — uses `Item` for add-item form

---

## Fields (Item — admin form model)

| Field | Java Type | DB Column | Validation | Notes |
|---|---|---|---|---|
| `product_id` | `int` | `product_id` INT | — | Auto-assigned by DB |
| `product_category` | `String` | `product_category` VARCHAR(20) | `@NotEmpty` | e.g., `Saree`, `Suit`, `Shirt`, `pant` |
| `material` | `String` | `material` VARCHAR(20) | `@NotEmpty` | e.g., `cotton`, `Cotton`, `silk` |
| `name` | `String` | `name` VARCHAR(20) | `@NotEmpty` | Product name |
| `product_type` | `String` | `product_type` VARCHAR(20) | `@NotEmpty` | e.g., `ethnic`, `casual`, `formal` |
| `stock` | `int` | `stock` BIGINT | `@NotNull` | Units in stock |
| `discount` | `int` | `discount` DECIMAL(6,2) | `@NotNull` | Discount percentage |
| `price` | `Long` | `price` BIGINT | `@NotNull` | Price in INR |

---

## DB Table: `products`

```sql
CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `product_type` varchar(20) DEFAULT NULL,
  `product_category` varchar(20) DEFAULT NULL,
  `stock` bigint(20) DEFAULT NULL,
  `discount` decimal(6,2) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `material` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
);
```

---

## DAO Methods (productdaoimplementation)

| Method | SQL | Notes |
|---|---|---|
| `getAllItems()` | `SELECT * FROM products` | Returns all products |
| `getfilterItems(String cat)` | `SELECT * FROM products WHERE product_category=?` | Filter by category |
| `getfilterItems(String cat, String type)` | `SELECT * WHERE category=? AND type=?` | Two-level filter |
| `save(Item)` | `INSERT INTO products(...)` | Admin add-product form |
| `getprice(int productId)` | `SELECT price FROM products WHERE product_id=?` | Used in billing |

---

## Seed Data (from schema.sql)

Categories present: `Saree`, `Suit`, `pant`, `Shirt`
Types present: `ethnic`, `casual`, `formal`
Materials: `cotton`, `Cotton`

---

## Related Pages
- [Cart entity](Cart.md) — references `product_id`
- [Billing entity](Billing.md) — references `product_id` in `billing_details`
- [Product Catalog concept](../concepts/product-catalog.md)
- [Data Access Layer](../concepts/data-access-layer.md) — DAO query patterns for products
- [Admin Routes](../endpoints/admin-routes.md)
