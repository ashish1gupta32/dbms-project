---
title: "Project Overview"
category: meta
tags: [overview, architecture, tech-stack]
last_updated: "2026-05-17"
source_count: 6
---

# Sarika Silk House — Project Overview

## What Is This?

**Sarika Silk House** is a full-stack eCommerce web application for a silk and textile retail business. It supports two classes of users — **customers** (who browse products, manage carts, and place orders) and **admins** (who manage inventory, employees, customers, and billing).

---

## Technology Stack

| Layer | Technology |
|---|---|
| Language | Java 11 |
| Framework | Spring Boot 2.1.9.RELEASE |
| Web | Spring MVC + Thymeleaf (server-side rendering) |
| Security | Spring Security 5 (BCrypt password encoding, role-based access) |
| Data Access | Spring JDBC (`JdbcTemplate`) — **no ORM/JPA** used in practice |
| Dev Database | H2 in-memory (MySQL compatibility mode) |
| Prod Database | MySQL (RemoteMySQL, credentials in application.properties) |
| Build | Maven (`mvnw` wrapper) |
| Dev Tools | Spring Boot DevTools (hot reload) |

---

## Key Features

### Customer Side
- User **registration** with username uniqueness + phone uniqueness validation
- **Login / logout** via Spring Security form login
- **Product browsing** by category, type, and material
- **Shopping cart** — add, update quantity, delete, view total
- **Order tracking** UI (`tracking.html`)
- **Blog** (`blog.html`, `single-blog.html`) — informational pages

### Admin Side
- **Product management** — view all products, filter by category/type, add new items
- **Employee management** — view employees, add, delete, update holiday count
- **Customer management** — view all customers, add new customer
- **Billing** — create billing records, add line items, view payment summary

---

## Project Structure

```
src/main/java/com/sarika/silkhouse/
  ├── [Controllers]         — Spring MVC @Controller classes
  ├── config/               — Spring Security + MVC config
  ├── dao/                  — Data access interfaces + JDBC implementations
  ├── model/                — Plain Java domain objects (no @Entity)
  └── service/              — UserDetailsService for Spring Security

src/main/resources/
  ├── schema.sql            — Full DB DDL + seed data (run on startup with H2)
  ├── application.properties
  ├── templates/            — Thymeleaf HTML templates
  └── static/               — CSS, JS, images
```

---

## Database Tables

| Table | Purpose |
|---|---|
| `user` | App login credentials + personal info |
| `profile` | Shared personal data (name, phone, email) — supertype |
| `customer` | Customer address info (FK → profile) |
| `employee` | Employee HR data (FK → profile) |
| `dealer` | Dealer info (FK → profile, currently empty) |
| `products` | Entire product catalog |
| `cart_details` | Per-user shopping cart entries |
| `billing` | Billing header (date, customer, payment mode) |
| `billing_details` | Billing line items (billing FK + product FK) |

→ See [schema-sql.md](sources/schema-sql.md) for full DDL.
→ See [Data Access Layer](concepts/data-access-layer.md) for how the app queries these tables.

---

## Notable Design Decisions

1. **No JPA/Hibernate in practice** — despite `spring-boot-starter-data-jpa` being in `pom.xml`, all data access uses raw `JdbcTemplate` SQL. Domain classes are plain POJOs (no `@Entity`).
2. **Separate `user` and `profile` tables** — login credentials live in `user`; personal info (for employees/customers) lives in `profile`. These are not joined for customer-facing login.
3. **Admin hardcoded** — the admin check in `LoginController` compares username to the literal `"ashishadmin"`. The real role check is done by Spring Security via the `user_type` field.
4. **H2 for dev, MySQL for prod** — switching is done by commenting/uncommenting lines in `application.properties`.
5. **SQL injection risk** — several DAO implementations (e.g., `CartdaoImpl`) build SQL strings by concatenating user input. This is a known technical debt item.

---

## Related Pages

- [Authentication](concepts/authentication.md)
- [Data Access Layer](concepts/data-access-layer.md)
- [Product Catalog](concepts/product-catalog.md)
- [Architecture Overview](synthesis/architecture-overview.md)
- [Security Model](synthesis/security-model.md)
