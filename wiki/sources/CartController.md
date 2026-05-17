---
title: "Source: CartController.java"
category: source
tags: [controller, cart, shopping, routes]
last_updated: "2026-05-17"
source_count: 1
---

# Source: CartController.java

**Path:** `src/main/java/com/sarika/silkhouse/CartController.java`
**Type:** Spring MVC `@Controller`
**Lines:** 86

---

## Purpose
Handles all shopping cart operations for logged-in users: adding items, viewing the cart, updating quantities, and removing items.

---

## Dependencies (Autowired)

| Field | Type | Used For |
|---|---|---|
| `cartdao` | `Cartdao` | All cart DB operations |
| `categorydao` | `Categorydao` | Autowired but **not used** in any method |

---

## Key Methods

| Method | Route | Description |
|---|---|---|
| `addtocart()` | GET `/buyitem/addtocart/{iid}` | Add item to cart; redirect to `/products` |
| `showcart()` | GET `/buyitem/cart` | Show cart contents and total |
| `addquant()` | GET `/buyitem/update/{iid}` | Update item quantity from request param |
| `deleteItem()` | GET `/buyitem/deleteitems/{itemId}` | Remove item from cart |

---

## Auth Pattern

All methods check `request.getUserPrincipal()` to get the username:
```java
if (request.getUserPrincipal() != null) {
    String uid = request.getUserPrincipal().getName();
    // proceed
} else {
    return "redirect:/login";
}
```

This is manual session checking — Spring Security does not auto-protect these routes (they're not listed in `WebSecurityConfig`).

---

## Notable Issues

1. **`categorydao` autowired but unused** — dead dependency.
2. **`deleteItem` bug** — uses `== null` (reference equality) instead of `!= null` check, which may not work as intended:
   ```java
   if (request.getUserPrincipal().getName() == null)  // should be != null or checked differently
   ```
3. **All cart routes use GET** — `addtocart`, `deleteitems`, and `update` are all `GET` requests. This means they can be triggered by link clicks, which is not idempotent-safe. Should use POST/DELETE.

---

## Related Pages
- [Cart entity](../entities/Cart.md)
- [Cart Routes](../endpoints/cart-routes.md)
- [Data Access Layer](../concepts/data-access-layer.md)
