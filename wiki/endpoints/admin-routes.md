---
title: "Endpoints: Admin Routes"
category: endpoint
tags: [admin, routes, products, employees, billing, customers]
last_updated: "2026-05-17"
source_count: 2
---

# Endpoints: Admin Routes

All routes under `/admin/**` require the `ADMIN` authority (enforced by Spring Security).
See [authentication concept](../concepts/authentication.md) for role rules.

---

## Product Management

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/admin` | `AdminController.admin()` | `admin.html` | Admin home dashboard |
| GET | `/admin/allcat` | `adminproducts()` | `admin_product.html` | List all products |
| GET | `/admin/allcat/{str}` | `adminShirt()` | `admin_product1.html` | Filter by category (e.g., `Saree`) |
| GET | `/admin/allcat/{str}/{str2}` | `adminsuit()` | `admin_product2.html` | Filter by category + type |
| GET | `/admin/allcat/additem` | `adminaddproduct()` | `additem.html` | Blank add-item form |
| POST | `/admin/allcat/additem` | `adminaddproduct1()` | `addsuccesful.html` | Save new product |

**Models passed to templates:**
- `admin_product.html` ← `products` (List<Item>)
- `admin_product1.html` ← `products` + `var1` (category string)
- `admin_product2.html` ← `products` + `var1` + `var2` (category + type)
- `additem.html` ← `Item` (empty form object)

**Validation:** `additem` POST uses `@Valid` + `BindingResult`. On error, returns back to the additem path.

→ [Item entity](../entities/Item.md) | [Product Catalog](../concepts/product-catalog.md)

---

## Employee Management

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/admin/employee` | `adminemployee()` | `employee.html` | List all employees |
| GET | `/admin/employee/addemployee` | `registerProcess1()` | `addemployee.html` | Blank employee form |
| POST | `/admin/employee/addemployee` | `registerProcess()` | `addsuccesful.html` | Save new employee |
| GET | `/admin/employeedelete/{iid}` | `adminemployeedelete()` | redirect → `/admin/employee` | Delete employee by ID |
| POST | `/admin/employee/update/{eid}` | `adminemployeeupdate()` | redirect → `/admin/employee` | Update holiday count |

**Note:** The employee form uses `Profile` as the form model (not `Employee` directly).

→ [Employee entity](../entities/Employee.md) | [Profile entity](../entities/Profile.md)

---

## Customer Management

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/admin/allcustomer` | `adminallcustomer()` | `allcustomer.html` | List all customers |
| GET | `/admin/allcustomer/addcustomer` | `adminaddcustomer()` | `addcustomer.html` | Blank customer form |
| POST | `/admin/allcustomer/addcustomer` | `Addcustomer()` | `addsuccesful.html` | Save new customer |

→ [Customer entity](../entities/Customer.md)

---

## Billing Management

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/admin/billing` | `adminbilling()` | `billing.html` | Create new billing header form |
| POST | `/admin/billing` | `adminbilling1()` | redirect → `/admin/billing/details` | Save billing header |
| GET | `/admin/billing/details` | `billing_details()` | `billing_details.html` | View + add line items |
| POST | `/admin/billing/details` | `billing_details(POST)` | redirect → `/admin/billing/details` | Add line item |
| GET | `/admin/payment` | `payment()` | `payment.html` | View full bill total + payment |

**Billing flow:** Create billing header → add line items → view payment summary.

→ [Billing entity](../entities/Billing.md) | [Customer entity](../entities/Customer.md)

---

## Access Denied

| URL | Template | Notes |
|---|---|---|
| `/403` | `permission.html` | Spring Security redirects here on access denied |
