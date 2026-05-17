---
title: "Wiki Index"
category: meta
tags: [index, catalog]
last_updated: "2026-05-17"
source_count: 0
---

# Wiki Index — Sarika Silk House

Master catalog of all pages. Updated on every ingest, query (if new pages are filed), or lint pass.
See [AGENTS.md](../AGENTS.md) for operation workflows.

---

## Meta

- [Wiki Index](index.md) — This file. Catalog of all wiki pages. `last_updated: 2026-05-17`
- [Changelog / Log](log.md) — Chronological append-only operation log. `last_updated: 2026-05-17`
- [Project Overview](overview.md) — High-level summary of the Sarika Silk House project. `last_updated: 2026-05-17`

---

## Entities

Domain model classes and their corresponding DB tables.

- [User](entities/User.md) — Application user accounts; maps to the `user` table. `last_updated: 2026-05-17`
- [Profile](entities/Profile.md) — Shared personal info (name, phone, email); base for Customer, Employee, Dealer. `last_updated: 2026-05-17`
- [Item](entities/Item.md) — Product (admin-facing form model); maps to the `products` table. `last_updated: 2026-05-17`
- [Cart](entities/Cart.md) — Shopping cart entry; maps to `cart_details` table. `last_updated: 2026-05-17`
- [Billing](entities/Billing.md) — Billing header and line items; maps to `billing` + `billing_details` tables. `last_updated: 2026-05-17`
- [Employee](entities/Employee.md) — Staff record; maps to `employee` table (FK to `profile`). `last_updated: 2026-05-17`
- [Customer](entities/Customer.md) — Customer address record; maps to `customer` table (FK to `profile`). `last_updated: 2026-05-17`

---

## Concepts

Cross-cutting technical topics.

- [Authentication](concepts/authentication.md) — Spring Security config, roles, login flow, BCrypt. `last_updated: 2026-05-17`
- [Data Access Layer](concepts/data-access-layer.md) — DAO pattern, JdbcTemplate, H2/MySQL dual config. `last_updated: 2026-05-17`
- [Product Catalog](concepts/product-catalog.md) — Categories, materials, product types, filtering logic. `last_updated: 2026-05-17`

---

## Endpoints

URL route reference by controller.

- [Admin Routes](endpoints/admin-routes.md) — All `/admin/**` routes with method, params, return template. `last_updated: 2026-05-17`
- [User & Auth Routes](endpoints/user-routes.md) — Login, register, home, contact routes. `last_updated: 2026-05-17`
- [Cart Routes](endpoints/cart-routes.md) — Cart add, view, update quantity, delete, checkout routes. `last_updated: 2026-05-17`

---

## Sources

Summary pages for ingested raw source files.

- [AdminController.md](sources/AdminController.md) — All admin management operations (products, employees, billing). `last_updated: 2026-05-17`
- [CartController.md](sources/CartController.md) — User cart management routes. `last_updated: 2026-05-17`
- [LoginController.md](sources/LoginController.md) — Login, register, home routing logic. `last_updated: 2026-05-17`
- [ItemsController.md](sources/ItemsController.md) — Category-browsing and file-upload routes. `last_updated: 2026-05-17`
- [WebSecurityConfig.md](sources/WebSecurityConfig.md) — Spring Security HTTP config, role-based access rules. `last_updated: 2026-05-17`
- [schema-sql.md](sources/schema-sql.md) — Full DB schema: tables, columns, FKs, seed data. `last_updated: 2026-05-17`

---

## Synthesis

Cross-cutting analysis and derived knowledge.

- [Architecture Overview](synthesis/architecture-overview.md) — Layer diagram, request flow, component relationships. `last_updated: 2026-05-17`
- [Security Model](synthesis/security-model.md) — Role hierarchy, protected routes, known gaps. `last_updated: 2026-05-17`
