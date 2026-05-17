---
title: "Entity: User"
category: entity
tags: [user, authentication, security, db-table]
last_updated: "2026-05-17"
source_count: 3
---

# Entity: User

## Summary
The `User` class represents a registered application user. It maps to the `user` DB table and is the **primary authentication entity** — Spring Security loads users from this table via `UserDetailsServiceImpl`. It is separate from `Profile` (which stores HR/personal data for employees and customers).

---

## Source Files
- `model/User.java` — POJO definition
- `dao/Userdao.java` + `dao/UserdaoImpl.java` — data access
- `schema.sql` → `user` table DDL
- `LoginController.java` — registration flow using this model

---

## Fields

| Field | Java Type | DB Column | Constraint | Notes |
|---|---|---|---|---|
| `username` | `String` | `username` VARCHAR(20) | PK, NOT NULL | Login credential |
| `password` | `String` | `password` VARCHAR(250) | — | BCrypt-encoded at rest |
| `mpassword` | `String` | *(not stored)* | — | Confirm-password field; validated client-side only |
| `fname` | `String` | `fname` VARCHAR(10) | — | First name |
| `lname` | `String` | `lname` VARCHAR(10) | — | Last name |
| `phone` | `String` | `phone` VARCHAR(10) | UNIQUE | Unique phone constraint |
| `email` | `String` | `email` VARCHAR(30) | — | Max 100 chars enforced in `LoginController` |
| `user_type` | `int` | `user_type` INT | — | `0` = regular user, `1` = admin |

---

## DB Table: `user`

```sql
CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(250) DEFAULT NULL,
  `user_type` int(11) DEFAULT NULL,
  `fname` varchar(10) DEFAULT NULL,
  `lname` varchar(10) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `idx_user_phone` (`phone`)
);
```

---

## DAO Methods (UserdaoImpl)

| Method | SQL Operation | Notes |
|---|---|---|
| `saveOrUpdate(User)` | INSERT into `user` | Called during registration |
| `getUser(String username)` | SELECT by PK | Used to check username uniqueness |
| `getNumber(String phone)` | SELECT by phone | Used to check phone uniqueness |

---

## Registration Validation (LoginController)

The controller performs these checks before calling `userdao.saveOrUpdate()`:
1. Bean validation passes (`@NotEmpty` on all fields)
2. `password` equals `mpassword`
3. `getUser(username)` returns null (username not taken)
4. `getNumber(phone)` returns null (phone not taken)
5. `email.length() <= 100`

---

## Spring Security Integration
Spring Security loads users from this table via `UserDetailsServiceImpl`. The `user_type` field maps to authorities:
- `user_type = 0` → `ROLE_USER`
- `user_type = 1` → `ROLE_ADMIN` (mapped to authority `ADMIN`)

→ See [Authentication](../concepts/authentication.md) for the full security model.

---

## Related Pages
- [Profile entity](Profile.md) — separate personal info store used by employees/customers
- [Authentication concept](../concepts/authentication.md)
- [Data Access Layer](../concepts/data-access-layer.md) — DAO pattern for user queries
- [User & Auth Routes](../endpoints/user-routes.md)
- [LoginController source](../sources/LoginController.md)
