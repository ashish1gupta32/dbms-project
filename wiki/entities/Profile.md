---
title: "Entity: Profile"
category: entity
tags: [profile, customer, employee, dealer, db-table]
last_updated: "2026-05-17"
source_count: 2
---

# Entity: Profile

## Summary
`Profile` is a **supertype entity** in the DB schema. It stores shared personal information (name, phone, email) for customers, employees, and dealers. The `customer`, `employee`, and `dealer` tables all have a FK to `profile.profile_id`. The `profile_type` field encodes which kind of person this profile belongs to.

This is **separate from `User`** — a Profile does not necessarily have a login account.

---

## Source Files
- `model/Profile.java` — POJO
- `dao/Customerdao.java` + `dao/CustomerdaoImpl.java` — reads profile for customer views
- `dao/EmployeedaoImpl.java` — reads/writes profile when saving employees
- `schema.sql` → `profile` table DDL

---

## Fields

| Field | Java Type | DB Column | Constraint | Notes |
|---|---|---|---|---|
| `profile_id` | `long` | `profile_id` BIGINT | PK, AUTO_INCREMENT | — |
| `fname` | `String` | `fname` VARCHAR(10) | — | First name |
| `lname` | `String` | `lname` VARCHAR(10) | — | Last name |
| `profile_type` | `int` | `profile_type` INT | — | `0` = customer, `1` = employee, `2` = dealer |
| `phone1` | `String` | `phone1` VARCHAR(10) | UNIQUE | Primary phone |
| `phone2` | `String` | `phone2` VARCHAR(10) | UNIQUE | Secondary phone (nullable) |
| `email` | `String` | `email` VARCHAR(20) | — | — |

---

## DB Table: `profile`

```sql
CREATE TABLE `profile` (
  `profile_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fname` varchar(10) DEFAULT NULL,
  `lname` varchar(10) DEFAULT NULL,
  `profile_type` int(11) DEFAULT NULL,
  `phone1` varchar(10) DEFAULT NULL,
  `phone2` varchar(10) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `idx_profile_phone1` (`phone1`),
  UNIQUE KEY `idx_profile_phone2` (`phone2`)
);
```

---

## Inheritance Pattern (DB-level)

```
profile (supertype)
  ├── customer (profile_id FK → customer_id)
  ├── employee (profile_id FK → employee_id)
  └── dealer   (profile_id FK → dealer_id)
```

When adding a new employee, the admin saves a `Profile` object via `EmployeedaoImpl.save(Profile)` — this inserts into both `profile` and `employee` tables.

---

## Related Pages
- [Customer entity](Customer.md)
- [Employee entity](Employee.md)
- [User entity](User.md) — separate login system
- [Data Access Layer](../concepts/data-access-layer.md)
