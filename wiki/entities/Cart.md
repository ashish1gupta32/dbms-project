---
title: "Entity: Cart"
category: entity
tags: [cart, shopping, db-table, cart_details]
last_updated: "2026-05-17"
source_count: 3
---

# Entity: Cart

## Summary
`Cart` represents a single line in a user's shopping cart. It maps to the `cart_details` table. The cart is **user-scoped by username** (`cart_id` = the logged-in user's username string — not a numeric FK to `user`). The cart persists in the database (it is not session-based).

---

## Source Files
- `model/Cart.java` — POJO
- `dao/Cartdao.java` + `dao/CartdaoImpl.java` — data access
- `CartController.java` — HTTP handlers for cart operations
- `schema.sql` → `cart_details` table DDL

---

## Fields

| Field | Java Type | DB Column | Notes |
|---|---|---|---|
| `product_id` | `int` | `product_id` INT | FK → `products.product_id` (CASCADE DELETE) |
| `cart_id` | `String` | `cart_id` VARCHAR(20) | The username of the owner (e.g., `"ashishadmin"`) |
| `quantity` | `int` | `quantity` BIGINT | Default 1 |
| `total_price` | `int` | `total_price` BIGINT | `price × quantity`, recalculated on update |
| `name` | `String` | *(from JOIN)* | Product name — populated via JOIN query, not a cart_details column |
| `price` | `int` | *(from JOIN)* | Unit price — populated via JOIN query |
| `discount` | `int` | *(from JOIN)* | Discount — populated via JOIN query |

---

## DB Table: `cart_details`

```sql
CREATE TABLE `cart_details` (
  `cart_id` varchar(20) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` bigint(20) DEFAULT '1',
  `total_price` bigint(20) DEFAULT '0',
  PRIMARY KEY (`cart_id`, `product_id`),
  CONSTRAINT `cart_details_ibfk_2`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
);
```
**Note:** There is **no FK from `cart_id` to `user.username`** — the cart is linked to the user only by string matching.

---

## DAO Methods (CartdaoImpl)

| Method | Description | Notes |
|---|---|---|
| `addtocart(int iid, String uid, Cart cart)` | Insert new cart row if item not already in cart | Does nothing if `(cart_id, product_id)` already exists |
| `getcart(String uid)` | `SELECT ... FROM products INNER JOIN cart_details WHERE cart_id=uid` | Returns enriched `Cart` list with product name/price |
| `addquantity(int qty, int iid, String uid, Cart cart)` | UPDATE quantity and recalculate `total_price` | `total_price = unit_price × quantity` |
| `deleteItem(int itemId, String uid)` | DELETE a single cart row | — |
| `gettotal(String uid)` | `SELECT SUM(total_price) WHERE cart_id=uid` | Returns 0 if cart empty |

---

## ⚠️ Known Issues

1. **SQL Injection** — `CartdaoImpl` builds SQL via string concatenation (e.g., `"... where cart_id='" + uid + "'"`) instead of prepared statements. This is a security vulnerability.
2. **No `user` FK** — Deleting a `user` record does **not** cascade-delete their cart rows.
3. **`total_price` is not recalculated if product price changes** — only recalculated on quantity update.

---

## Related Pages
- [Item entity](Item.md) — product joined into cart queries
- [Cart Routes](../endpoints/cart-routes.md)
- [CartController source](../sources/CartController.md)
- [Data Access Layer](../concepts/data-access-layer.md)
- [Security Model](../synthesis/security-model.md) — SQL injection risk noted
