---
title: "Synthesis: Security Model"
category: synthesis
tags: [security, roles, vulnerabilities, sql-injection, csrf, authorization]
last_updated: "2026-05-17"
source_count: 4
---

# Synthesis: Security Model

## Overview
The application uses Spring Security 5 for authentication and authorization. Passwords are BCrypt-hashed. Role-based access control is configured in `WebSecurityConfig`. However, there are several security issues worth noting for production hardening.

---

## Authentication Chain

```
User submits form (POST /j_spring_security_check)
        ↓
Spring Security extracts username + password
        ↓
UserDetailsServiceImpl.loadUserByUsername(username)
        ↓
SELECT * FROM user WHERE username = ?
        ↓
Builds UserDetails with GrantedAuthority list
        ↓
BCryptPasswordEncoder.matches(raw, encoded)
        ↓
[PASS] Session created → redirect /home
[FAIL] redirect /loginError → /login?error=true
```

---

## Authorization Matrix

| URL Pattern | Anonymous | USER | ADMIN |
|---|---|---|---|
| `/`, `/login`, `/logout` | ✅ | ✅ | ✅ |
| `/register` | ✅ | ✅ | ✅ |
| `/profile` | ❌ | ✅ | ✅ |
| `/user`, `/users`, `/employee/**` | ❌ | ❌ | ✅ |
| `/admin`, `/admin**`, `/admin/**` | ❌ | ❌ | ✅ |
| `/buyitem/**` | Manual check | ✅ | ✅ |
| `/contact`, `/home` | ✅ | ✅ | ✅ |

**Note:** `/buyitem/**` routes are **not protected by Spring Security config** — protection is done via manual `getUserPrincipal()` checks in `CartController`. This means if a new route is added and the developer forgets the manual check, it could be accessible unauthenticated.

---

## Identified Security Issues

### 🔴 Critical: SQL Injection

Multiple DAO implementations concatenate user input directly into SQL strings:

```java
// CartdaoImpl.java — UNSAFE
String s = "select * from cart_details where cart_id='" + uid + "' and product_id='" + iid + "'";

// CartdaoImpl.addquantity — UNSAFE via jdbcTemplate.execute()
String sql = "update cart_details set quantity=" + quantity + ",total_price=" + price
             + "where product_id=" + iid + " and cart_id='" + uid + "'";
```

**Fix:** Use `?` parameterized queries throughout:
```java
jdbcTemplate.query("select * from cart_details where cart_id=? and product_id=?",
    new Object[]{uid, iid}, ...)
```

Affected files to audit: `CartdaoImpl`, `BillingdaoImpl`, `EmployeedaoImpl`, `CustomerdaoImpl`.

---

### 🟡 Medium: CSRF Disabled

```java
http.csrf().disable();
```
CSRF tokens are not validated on form submissions. In production, an attacker could craft a page that submits forms on behalf of authenticated users.

**Fix:** Enable CSRF and add `th:action="@{...}"` with hidden `_csrf` fields in Thymeleaf forms.

---

### 🟡 Medium: Hardcoded Admin Username

```java
// LoginController.java
String str1 = "ashishadmin";
if (str1.equals(str)) { return "admin"; }
```
Admin routing after login is based on a hardcoded username. This is separate from the Spring Security role check. If a new admin account is created, they won't be routed to the admin dashboard.

**Fix:** Use `principal.getAuthorities()` to check for the `ADMIN` role instead.

---

### 🟡 Medium: Cart Not Protected by Spring Security

`CartController` routes are not in `WebSecurityConfig`. Manual principal checks can be inconsistent. The `deleteItem` handler has a bug — `getName() == null` uses reference equality.

---

### 🟢 Low: Aadhaar Number in Plain Text

`employee.adhar_number` is stored as-is (`VARCHAR(20)`) with no encryption. For a production system handling government IDs, this is a compliance risk.

---

### 🟢 Low: `dealer` Table is Empty

The `dealer` table exists in schema.sql and has a DAO but contains no seed data and no active admin UI. It is effectively dead code.

---

## What's Done Well

- ✅ BCrypt password encoding (strength 10 by default)
- ✅ Spring Security role enforcement on all `/admin/**` routes
- ✅ Username and phone uniqueness enforced at both DB constraint and application level
- ✅ Form login with failure URL and error flag
- ✅ HTTPS-ready architecture (just needs SSL termination at the load balancer)

---

## Related Pages
- [Authentication concept](../concepts/authentication.md)
- [WebSecurityConfig source](../sources/WebSecurityConfig.md)
- [Cart entity](../entities/Cart.md) — SQL injection detail
- [Data Access Layer](../concepts/data-access-layer.md) — DAO patterns
- [LoginController source](../sources/LoginController.md) — hardcoded admin
