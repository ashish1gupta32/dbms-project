---
title: "Synthesis: Architecture Overview"
category: synthesis
tags: [architecture, layers, mvc, spring, flow]
last_updated: "2026-05-17"
source_count: 6
---

# Synthesis: Architecture Overview

## System Layers

```
┌──────────────────────────────────────────────────────────────────┐
│                        Browser (Client)                          │
│              Thymeleaf-rendered HTML pages                       │
└──────────────────────────┬───────────────────────────────────────┘
                           │  HTTP Request
┌──────────────────────────▼───────────────────────────────────────┐
│                   Spring Security Filter Chain                   │
│  Checks credentials, roles, CSRF (disabled), session            │
└──────────────────────────┬───────────────────────────────────────┘
                           │  Passes to
┌──────────────────────────▼───────────────────────────────────────┐
│                   Spring MVC @Controllers                        │
│                                                                  │
│  LoginController   AdminController   CartController              │
│  ItemsController   productscontroller                            │
│  CategoryController  LocationController                          │
└──────────────────────────┬───────────────────────────────────────┘
                           │  Calls
┌──────────────────────────▼───────────────────────────────────────┐
│                      DAO Layer (Interfaces)                      │
│  Userdao  Cartdao  productdao  Billingdao  Employeedao  ...      │
│              Implemented by @Repository classes                  │
└──────────────────────────┬───────────────────────────────────────┘
                           │  JdbcTemplate SQL
┌──────────────────────────▼───────────────────────────────────────┐
│               DataSource (H2 dev / MySQL prod)                   │
│  Schema loaded from schema.sql on H2 startup                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## Request Flow (Example: Add to Cart)

```
1. User clicks "Add to Cart" on product page
   GET /buyitem/addtocart/{productId}

2. Spring Security filter: checks user is authenticated
   (CartController does its own manual check via getUserPrincipal())

3. CartController.addtocart() runs:
   - Gets username from HttpServletRequest.getUserPrincipal().getName()
   - Calls CartdaoImpl.addtocart(productId, username, cart)

4. CartdaoImpl:
   - Checks if (username, productId) already in cart_details
   - If not: fetches price from products table
   - INSERTs into cart_details with quantity=1, total_price=price

5. Controller redirects to /products
```

---

## Component Map

| Component | Package/File | Role |
|---|---|---|
| `WebSecurityConfig` | `config/` | Security rules |
| `UserDetailsServiceImpl` | `service/` | DB-backed auth |
| `LoginController` | root package | Auth UI + registration |
| `AdminController` | root package | Admin CRUD operations |
| `CartController` | root package | Cart operations |
| `ItemsController` | root package | Category-based browsing |
| `productscontroller` | root package | Product display (user-facing) |
| `CategoryController` | root package | Category management |
| `LocationController` | root package | Order tracking |
| DAO implementations | `dao/` | All DB access |
| Domain models | `model/` | Plain Java POJOs |
| Thymeleaf templates | `resources/templates/` | Server-rendered HTML |
| Static assets | `resources/static/` | CSS, JS, images |

---

## Data Flow: Two Product Systems

A notable architectural duality: there are **two parallel product management systems**:

```
System A (Admin Catalog)                 System B (Category Items)
──────────────────────────               ────────────────────────────
productdao → productdaoimplementation    Itemsdao → ItemsdaoImpl
Item.java (admin form)                   Items.java (display)
AdminController (/admin/allcat/*)        ItemsController (/buyitem/{catid})
products table                           Same products table? (unclear)
```

These appear to have evolved separately. System A is used for admin inventory management; System B for browsing by category integer ID. The `cart_details` table uses `product_id` from `products`, so System A's `products` table is the canonical source.

---

## Configuration Files

| File | Purpose |
|---|---|
| `application.properties` | DB connection, Spring config |
| `schema.sql` | DDL + seed data (H2 startup) |
| `validation.properties` | Custom validation messages |
| `pom.xml` | Maven dependencies |

---

## Technology Choices Analysis

| Decision | Implication |
|---|---|
| JdbcTemplate (no ORM) | Full SQL control; no lazy-loading bugs; but verbose and SQL injection risk |
| Thymeleaf (server-rendered) | Simple, no API/SPA complexity; tightly coupled to controller models |
| H2 in-memory | Zero config for dev; data reset on restart; schema.sql is the single source of truth |
| Spring Security form login | Standard, battle-tested; but CSRF disabled reduces protection |

---

## Related Pages
- [Overview](../overview.md)
- [Security Model](security-model.md)
- [Data Access Layer](../concepts/data-access-layer.md)
- [Authentication](../concepts/authentication.md)
