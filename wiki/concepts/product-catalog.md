---
title: "Concept: Product Catalog"
category: concept
tags: [products, catalog, categories, filtering, items]
last_updated: "2026-05-17"
source_count: 3
---

# Concept: Product Catalog

## Summary
The product catalog is stored in the `products` table. Products have three classification dimensions: **category**, **type**, and **material**. Admins manage the catalog; customers browse it. There are two Java model classes for products: `Item` (admin form model with validation) and `Items` (read-only display model).

---

## Product Classification

| Dimension | DB Column | Example Values |
|---|---|---|
| Category | `product_category` | `Saree`, `Suit`, `Shirt`, `pant` |
| Type | `product_type` | `ethnic`, `casual`, `formal` |
| Material | `material` | `cotton`, `Cotton`, `silk` |

**Note:** `cotton` and `Cotton` are treated as different values due to case sensitivity. This is a data inconsistency issue.

---

## Browsing Hierarchy (Admin View)

The admin product UI offers three levels of filtering:

| Route | Level | Method |
|---|---|---|
| `/admin/allcat` | All products | `productdao.getAllItems()` |
| `/admin/allcat/{category}` | Filter by category | `productdao.getfilterItems(category)` |
| `/admin/allcat/{category}/{type}` | Filter by category + type | `productdao.getfilterItems(category, type)` |

---

## Product POJO Duality

### `Item.java` — Admin Input Model
- Used in admin "Add Product" form
- Has Bean Validation annotations (`@NotEmpty`, `@NotNull`)
- Used by `AdminController` via `@ModelAttribute`

### `Items.java` — Display / Read Model
- Lightweight POJO (no validation)
- Used for cart enrichment (`CartdaoImpl.getcart()` uses JOINs to return `Cart` objects with product name/price)
- Used by `ItemsController` for category browsing lists

---

## Product Lifecycle

```
Admin fills form (additem.html)
       ↓
POST /admin/allcat/additem
       ↓
AdminController.adminaddproduct1()
       ↓
productdao.save(item) → INSERT INTO products(...)
       ↓
addsuccesful.html
```

---

## Cart Integration

When a user adds a product to their cart (`/buyitem/addtocart/{iid}`), the cart DAO:
1. Checks if item already in `cart_details` for this user
2. Fetches `price` from `products` table
3. INSERTs into `cart_details` with `quantity=1` and `total_price=price`

When displaying the cart, a JOIN query fetches `name`, `price`, `discount` from `products` alongside `quantity` and `total_price` from `cart_details`.

---

## Known Data Issues

- **Case inconsistency** in `material` column: `cotton` vs `Cotton`
- **No image storage** — products have no image URL or file reference in the `products` table. UI uses placeholder/static images.
- **No category table** — categories are free-text strings stored directly in `product_category`, not a FK to a `category` table. A `Categorydao` and `Category` model exist but are for a different, older item structure.

---

## Related Pages
- [Item entity](../entities/Item.md) — product model details
- [Cart entity](../entities/Cart.md) — cart references products
- [Admin Routes](../endpoints/admin-routes.md) — product management routes
- [Data Access Layer](data-access-layer.md) — DAO query patterns
