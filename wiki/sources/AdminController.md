---
title: "Source: AdminController.java"
category: source
tags: [controller, admin, products, employees, billing, customers]
last_updated: "2026-05-17"
source_count: 1
---

# Source: AdminController.java

**Path:** `src/main/java/com/sarika/silkhouse/AdminController.java`
**Type:** Spring MVC `@Controller`
**Lines:** 210

---

## Purpose
`AdminController` handles all admin-facing functionality: product catalog management, employee CRUD, customer management, and the billing system. All routes are prefixed with `/admin` and protected by the `ADMIN` authority.

---

## Dependencies (Autowired)

| Field | Type | Used For |
|---|---|---|
| `products` | `productdao` | Product catalog queries |
| `employee` | `Employeedao` | Employee CRUD |
| `customerdao` | `Customerdao` | Customer listing and creation |
| `billdao` | `Billingdao` | Billing operations |

---

## Key Methods

### Product Management
- `adminproducts()` — GET `/admin/allcat` → all products → `admin_product.html`
- `adminShirt()` — GET `/admin/allcat/{str}` → filtered by category
- `adminsuit()` — GET `/admin/allcat/{str}/{str2}` → filtered by category + type
- `adminaddproduct()` — GET `/admin/allcat/additem` → blank Item form
- `adminaddproduct1()` — POST `/admin/allcat/additem` → validates + saves new item

### Employee Management
- `adminemployee()` — GET `/admin/employee` → employee list
- `registerProcess1()` — GET `/admin/employee/addemployee` → blank Profile form
- `registerProcess()` — POST `/admin/employee/addemployee` → saves Profile → `addsuccesful.html`
- `adminemployeedelete()` — GET `/admin/employeedelete/{iid}` → deletes employee
- `adminemployeeupdate()` — POST `/admin/employee/update/{eid}` → updates holiday count

### Customer Management
- `adminallcustomer()` — GET `/admin/allcustomer` → customer list
- `adminaddcustomer()` — GET `/admin/allcustomer/addcustomer` → blank Profile form
- `Addcustomer()` — POST `/admin/allcustomer/addcustomer` → saves customer

### Billing
- `adminbilling()` / `adminbilling1()` — GET/POST `/admin/billing` — create billing header
- `billing_details()` — GET/POST `/admin/billing/details` — view + add billing line items
- `payment()` — GET `/admin/payment` — full bill payment summary

---

## Notable Observations

1. **Method naming inconsistency**: Some methods use camelCase (`adminemployee`), others use PascalCase (`Addcustomer`).
2. **`@Valid` without full error handling**: The billing POST handlers don't check `result.hasErrors()`.
3. **Commented-out allbilling routes** (lines 188–205) — these routes (`/admin/allbilling`) are stubbed but commented out. The billing list view is incomplete.
4. **Employee form uses `Profile` not `Employee`** — the admin add-employee flow binds a `Profile` object, not an `Employee`.

---

## Related Pages
- [Admin Routes](../endpoints/admin-routes.md)
- [Item entity](../entities/Item.md)
- [Employee entity](../entities/Employee.md)
- [Billing entity](../entities/Billing.md)
- [Customer entity](../entities/Customer.md)
