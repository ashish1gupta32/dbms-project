---
title: "Entity: Employee"
category: entity
tags: [employee, hr, db-table, profile]
last_updated: "2026-05-17"
source_count: 2
---

# Entity: Employee

## Summary
`Employee` represents staff of the Sarika Silk House. It is stored in the `employee` table with a FK to `profile.profile_id`. Employee records are created and managed exclusively by admins. The `Profile` holds personal info (name, phone) while `employee` holds HR-specific data (salary, holiday count, joining date).

---

## Source Files
- `model/Employee.java` — POJO
- `dao/Employeedao.java` + `dao/EmployeedaoImpl.java`
- `AdminController.java` — employee management routes
- `schema.sql` → `employee` table DDL

---

## Fields

| Field | Java Type | DB Column | Notes |
|---|---|---|---|
| `employee_id` | `long` | `employee_id` BIGINT | PK, FK → `profile.profile_id` |
| `employee_type` | `int` | `employee_type` INT | Role/type code (e.g., 0=staff, 2=manager, 3=senior) |
| `joining_date` | `String` | `joining_date` VARCHAR(10) | Stored as string (e.g., `"23/11/2018"`) |
| `holiday` | `int` | `holiday` INT | Holiday days remaining; default 0 |
| `salary` | `long` | `salary` BIGINT | Monthly salary in INR |
| `adhar_number` | `String` | `adhar_number` VARCHAR(20) | Aadhaar ID (government ID) |

The `Employee` POJO also carries `Profile` fields (name, phone) since the admin view joins the two tables.

---

## DB Table: `employee`

```sql
CREATE TABLE `employee` (
  `employee_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee_type` int(11) DEFAULT NULL,
  `joining_date` varchar(10) DEFAULT NULL,
  `holiday` int(11) DEFAULT '0',
  `salary` bigint(20) DEFAULT NULL,
  `adhar_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `employee_ibfk_1`
    FOREIGN KEY (`employee_id`) REFERENCES `profile`(`profile_id`)
);
```

---

## DAO Methods (EmployeedaoImpl)

| Method | Description |
|---|---|
| `getall()` | SELECT all employees (JOIN with profile for name/phone) |
| `save(Profile)` | INSERT into `profile` then `employee` — creates new employee |
| `delete(int eid)` | DELETE from `employee` by employee_id |
| `update(int holiday, int eid)` | UPDATE holiday count |

---

## Admin Employee Management Flow

1. `GET /admin/employee` → list all employees
2. `GET /admin/employee/addemployee` → blank `Profile` form
3. `POST /admin/employee/addemployee` → saves new employee → `addsuccesful.html`
4. `GET /admin/employeedelete/{iid}` → deletes employee, redirects to list
5. `POST /admin/employee/update/{eid}` → updates holiday days

---

## Related Pages
- [Profile entity](Profile.md) — personal data supertype
- [Admin Routes](../endpoints/admin-routes.md)
- [Data Access Layer](../concepts/data-access-layer.md)
