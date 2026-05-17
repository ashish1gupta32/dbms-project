---
title: "Endpoints: Cart Routes"
category: endpoint
tags: [cart, shopping, routes, buyitem]
last_updated: "2026-05-17"
source_count: 2
---

# Endpoints: Cart Routes

Cart routes are handled by `CartController`. All cart operations require the user to be logged in — unauthenticated requests are redirected to `/login`.

---

## Route Reference

| Method | URL | Handler | Template / Redirect | Description |
|---|---|---|---|---|
| GET | `/buyitem/addtocart/{iid}` | `addtocart()` | redirect → `/products` | Add product `iid` to cart. No-op if already in cart. |
| GET | `/buyitem/cart` | `showcart()` | `cart.html` | Display cart contents and total |
| GET | `/buyitem/update/{iid}` | `addquant()` | redirect → `/buyitem/cart` | Update quantity of item `iid` in cart |
| GET | `/buyitem/deleteitems/{itemId}` | `deleteItem()` | redirect → `/buyitem/cart` | Remove item `itemId` from cart |

---

## Route Details

### `GET /buyitem/addtocart/{iid}`
- Path var: `iid` — `product_id` from `products` table
- Extracts logged-in username via `request.getUserPrincipal().getName()`
- If not logged in → redirect to `/login`
- Calls `cartdao.addtocart(iid, uid, cart)` — inserts only if item not already in cart
- On success → redirect to `/products`

### `GET /buyitem/cart`
- Requires auth; unauthenticated → redirect to `/login`
- Calls `cartdao.getcart(uid)` → List of `Cart` (enriched with product name, price, discount via JOIN)
- Calls `cartdao.gettotal(uid)` → sum of `total_price`
- Passes `list` and `total` to `cart.html`

### `GET /buyitem/update/{iid}`
- Path var: `iid` — product_id
- Query param: `quantity` (read via `request.getParameter("quantity")`)
- Calls `cartdao.addquantity(quantity, iid, uid, cart)` — updates DB row and recalculates `total_price`

### `GET /buyitem/deleteitems/{itemId}`
- Path var: `itemId` — product_id
- Calls `cartdao.deleteItem(itemId, uid)` — DELETE from `cart_details`
- Bug: `getUserPrincipal().getName() == null` comparison uses `==` (reference equality) not `.equals()` — will not correctly detect null principal

---

## Model Attributes for `cart.html`

| Attribute | Type | Source |
|---|---|---|
| `list` | `List<Cart>` | `cartdao.getcart(uid)` — JOIN query |
| `total` | `int` | `cartdao.gettotal(uid)` — SUM query |

---

## Related Pages
- [Cart entity](../entities/Cart.md) — full DAO method docs and SQL injection warning
- [Item entity](../entities/Item.md) — products referenced by cart
- [CartController source](../sources/CartController.md)
- [Data Access Layer](../concepts/data-access-layer.md)
