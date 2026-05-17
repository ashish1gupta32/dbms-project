---
title: "Source: schema.sql"
category: source
tags: [database, schema, sql, tables, ddl, h2]
last_updated: "2026-05-17"
source_count: 1
---

# Source: schema.sql

**Path:** `src/main/resources/schema.sql`
**Lines:** 198
**Loaded by:** Spring Boot on startup via `spring.datasource.schema=classpath:schema.sql`

---

## Purpose
Defines the full database schema for the application: table DDL, primary/foreign keys, constraints, and seed data. Run fresh on every startup in H2 dev mode (all tables are dropped and recreated).

---

## Table Summary

| Table | Rows of seed data | Purpose |
|---|---|---|
| `profile` | 12 rows | Shared personal info (name, phone, email) |
| `customer` | 1 row | Customer address data, FK → profile |
| `employee` | 4 rows | Employee HR data, FK → profile |
| `dealer` | 0 rows | Dealer info, FK → profile (empty) |
| `user` | 11 rows | Login credentials, `user_type` |
| `products` | 10 rows | Product catalog |
| `cart_details` | 4 rows | Cart entries (user `ashishadmin` + `cs`) |
| `billing` | 6 rows | Billing headers |
| `billing_details` | 6 rows | Billing line items |

---

## Entity Relationship Summary

```
profile (supertype)
  ├── customer (customer_id FK)
  ├── employee (employee_id FK)
  └── dealer   (dealer_id FK)

user  (independent — no FK to profile)

products
  ├── cart_details (product_id FK, ON DELETE CASCADE)
  └── billing_details (product_id FK, ON DELETE CASCADE)

billing
  ├── billing_details (billing_id FK, ON DELETE CASCADE)
  └── customer (customer_id FK, ON DELETE CASCADE)
```

---

## Drop Order (startup)

Tables are dropped in reverse dependency order:
```sql
DROP TABLE IF EXISTS `billing_details`;
DROP TABLE IF EXISTS `billing`;
DROP TABLE IF EXISTS `cart_details`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `dealer`;
DROP TABLE IF EXISTS `employee`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `profile`;
DROP TABLE IF EXISTS `user`;
```

---

## Key Constraints

| Table | Constraint | Detail |
|---|---|---|
| `profile` | UNIQUE on `phone1`, `phone2` | Prevents duplicate phone numbers |
| `user` | UNIQUE on `phone` | Prevents duplicate phone at user level |
| `cart_details` | PK = `(cart_id, product_id)` | One row per user per product |
| `billing_details` | PK = `(billing_id, product_id)` | One line item per product per bill |
| `billing` → `customer` | ON DELETE CASCADE | Deleting a customer removes their bills |
| `cart_details` → `products` | ON DELETE CASCADE | Deleting a product removes it from all carts |

---

## Seed Data Notes

- Admin user: username `ashishadmin`, password is BCrypt hash, `user_type=1`
- Most `user` rows have `user_type=0` (regular)
- `billing_price` in `billing` table is `0` for most seed rows — totals are not pre-calculated
- `cart_details` has entries for users `ashishadmin` and `cs`

---

## Related Pages
- [User entity](../entities/User.md)
- [Profile entity](../entities/Profile.md)
- [Cart entity](../entities/Cart.md)
- [Billing entity](../entities/Billing.md)
- [Employee entity](../entities/Employee.md)
- [Customer entity](../entities/Customer.md)
- [Data Access Layer](../concepts/data-access-layer.md)
