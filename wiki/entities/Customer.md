---
title: "Entity: Customer"
category: entity
tags: [customer, address, db-table, profile]
last_updated: "2026-05-17"
source_count: 2
---

# Entity: Customer

## Summary
`Customer` represents a customer with shipping/billing address information. It references `profile.profile_id` for personal info and adds address-specific fields. The `customer` table is used in **admin billing** — a billing record must have a valid `customer_id`.

---

## Source Files
- `model/Customer.java` — POJO
- `dao/Customerdao.java` + `dao/CustomerdaoImpl.java`
- `AdminController.java` — `addcustomer` route
- `schema.sql` → `customer` table DDL

---

## Fields

| Field | Java Type | DB Column | Notes |
|---|---|---|---|
| `customer_id` | `long` | `customer_id` BIGINT | PK, FK → `profile.profile_id` |
| `house_number` | `String` | `house_number` VARCHAR(10) | Street/house number |
| `pincode` | `String` | `pincode` VARCHAR(10) | Indian PIN code |
| `state` | `String` | `state` VARCHAR(10) | State name |

The `Customer` POJO also holds `Profile` fields (name, phone) since admin views JOIN the tables.

---

## DB Table: `customer`

```sql
CREATE TABLE `customer` (
  `customer_id` bigint(20) NOT NULL,
  `house_number` varchar(10) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `customer_ibfk_1`
    FOREIGN KEY (`customer_id`) REFERENCES `profile`(`profile_id`)
);
```

---

## DAO Methods (CustomerdaoImpl)

| Method | Description |
|---|---|
| `getcustomer()` | SELECT all customers (JOIN with profile) |
| `addcustomer(Profile)` | INSERT into `profile` then `customer` |

---

## Relationship to User

`Customer` (in `customer` table) is **not directly linked** to `User` (in `user` table). A customer record is an admin-managed entity for billing purposes. A logged-in user's cart uses their username (`user.username`) as `cart_id` — not a `customer_id`.

---

## Related Pages
- [Profile entity](Profile.md) — personal data supertype
- [Billing entity](Billing.md) — billing references customer_id
- [Admin Routes](../endpoints/admin-routes.md)
- [Data Access Layer](../concepts/data-access-layer.md)
