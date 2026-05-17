---
title: "Source: ItemsController.java"
category: source
tags: [controller, items, categories, file-upload]
last_updated: "2026-05-17"
source_count: 1
---

# Source: ItemsController.java

**Path:** `src/main/java/com/sarika/silkhouse/ItemsController.java`
**Type:** Spring MVC `@Controller`
**Lines:** 95

---

## Purpose
Handles browsing of items by category ID for both users and admins. Also contains a file upload endpoint (`/readxml`) that saves uploaded files to the servlet context path.

---

## Dependencies (Autowired)

| Field | Type | Used For |
|---|---|---|
| `itemsdao` | `Itemsdao` | Fetch items by category |

---

## Key Methods

| Method | Route | Template | Description |
|---|---|---|---|
| `getitems()` | GET `/buyitem/{catid}` | `items` | Fetch items by category ID for users |
| `additems()` | GET `/admin/adminbuyitem/{catid}` | `admin/adminitems` | Fetch items by category for admin |
| `addcat()` | GET `/admin/adminbuyitem/additems/{catid}` | `admin/additems` | Blank add-item form per category |
| `addItem()` | POST `/admin/adminbuyitem/additems/{catid}` | redirect → `/admin` | Save item to category |
| `deleteItem()` | GET `/admin/adminbuyitem/deleteitems/{itemId}` | redirect → `/admin` | Delete item by ID |
| `upload()` | POST `/readxml` | `success` | File upload — saves to servlet context |

---

## Differences from `AdminController` Product Management

This controller uses `Itemsdao` (category-based items) while `AdminController` uses `productdao` (product catalog based on `products` table). These appear to be **two separate product management systems** that may be partially redundant:

| Aspect | `ItemsController` + `Itemsdao` | `AdminController` + `productdao` |
|---|---|---|
| DAO | `Itemsdao` / `ItemsdaoImpl` | `productdao` / `productdaoimplementation` |
| Model | `Items.java` | `Item.java` |
| Filter | By category ID (int) | By category string + type string |
| Route | `/buyitem/{catid}` | `/admin/allcat/{str}` |

---

## File Upload (`/readxml`)

- Accepts `CommonsMultipartFile` via POST
- Saves file to servlet context real path (e.g., server temp dir)
- Returns `"success"` view (template not found in current template list — possible dead feature)
- **Not secured** — no `@PreAuthorize` or role check on this endpoint

---

## Related Pages
- [Item entity](../entities/Item.md)
- [Product Catalog concept](../concepts/product-catalog.md)
- [Admin Routes](../endpoints/admin-routes.md)
- [Cart Routes](../endpoints/cart-routes.md)
