---
title: "Concept: Data Access Layer"
category: concept
tags: [dao, jdbc, jdbctemplate, h2, mysql, repository]
last_updated: "2026-05-17"
source_count: 4
---

# Concept: Data Access Layer

## Summary
All database access uses **Spring `JdbcTemplate`** — there is no ORM. Despite `spring-boot-starter-data-jpa` being in `pom.xml`, no `@Entity`, `@Repository` (JPA), or `CrudRepository` is used. The DAO pattern is implemented manually: an interface + an `@Repository @Transactional` implementation class per entity.

---

## Pattern

```
[Controller] → [DAO Interface] → [DaoImpl (@Repository)]
                                        ↓
                               JdbcTemplate → DataSource → H2 / MySQL
```

Each domain area has:
- **Interface** (e.g., `Cartdao.java`) — defines the contract
- **Implementation** (e.g., `CartdaoImpl.java`) — `@Repository @Transactional`, autowires `JdbcTemplate`

---

## DAO Inventory

| Interface | Implementation | Entity |
|---|---|---|
| `Cartdao` | `CartdaoImpl` | Cart / cart_details |
| `Userdao` | `UserdaoImpl` | User / user table |
| `Itemdao` | `ItemdaoImpl` | (secondary item DAO) |
| `Itemsdao` | `ItemsdaoImpl` | Items (category-based listing) |
| `productdao` | `productdaoimplementation` | Products (admin CRUD) |
| `Billingdao` | `BillingdaoImpl` | Billing + billing_details |
| `Customerdao` | `CustomerdaoImpl` | Customer + profile JOIN |
| `Employeedao` | `EmployeedaoImpl` | Employee + profile JOIN |
| `Categorydao` | `CategorydaoImpl` | Category listing |
| `Locationdao` | `LocationdaoImpl` | Location/tracking |
| `Admindao` | `AdmindaoImpl` | (stub — empty) |

---

## Query Styles Used

### 1. `BeanPropertyRowMapper` — for list queries
```java
jdbcTemplate.query(sql, new BeanPropertyRowMapper<Cart>(Cart.class))
```
Maps columns to POJO fields by name automatically.

### 2. `ResultSetExtractor` — for single-row queries
```java
jdbcTemplate.query(sql, new ResultSetExtractor<Cart>() {
    public Cart extractData(ResultSet rs) throws SQLException {
        if (rs.next()) { ... }
        return null;
    }
})
```
Used when fetching a single record or a computed value.

### 3. `queryForObject` — for scalar values
```java
jdbcTemplate.queryForObject(sql, new Object[]{id}, Long.class)
```
Used for price lookups and ID fetches.

### 4. `jdbcTemplate.update()` — for INSERT/UPDATE/DELETE
```java
jdbcTemplate.update(sql, objectArray)
```

### 5. `jdbcTemplate.execute()` — for raw SQL (used in cart update)
```java
jdbcTemplate.execute(rawSqlString)
```
> ⚠️ This bypasses parameterization entirely — **SQL injection risk**.

---

## Database Configuration

### Development (H2 in-memory)
```properties
spring.datasource.url=jdbc:h2:mem:testdb;MODE=MySQL
spring.datasource.driverClassName=org.h2.Driver
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=none
spring.datasource.initialization-mode=always
spring.datasource.schema=classpath:schema.sql
```
- Schema is loaded from `schema.sql` on every startup
- H2 console available at `/h2-console`
- Data is reset on every restart (in-memory)

### Production (MySQL)
```properties
spring.datasource.url=jdbc:mysql://remotemysql.com:3306/...
spring.datasource.username=...
spring.datasource.password=...
```
Uncomment lines in `application.properties` to switch.

---

## ⚠️ SQL Injection Issues

Several DAOs build SQL strings via string concatenation instead of parameterized queries:

```java
// CartdaoImpl — UNSAFE
String s = "select * from cart_details where cart_id='" + uid + "' and product_id='" + iid + "'";
```

Affected DAOs: `CartdaoImpl`, possibly others. Should be refactored to use `?` placeholders.

---

## Related Pages
- [Cart entity](../entities/Cart.md) — SQL injection flagged here
- [User entity](../entities/User.md)
- [schema-sql source](../sources/schema-sql.md)
- [Security Model](../synthesis/security-model.md) — SQL injection risk section
