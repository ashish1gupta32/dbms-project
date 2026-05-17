---
title: "Source: LoginController.java"
category: source
tags: [controller, login, register, home, routing]
last_updated: "2026-05-17"
source_count: 1
---

# Source: LoginController.java

**Path:** `src/main/java/com/sarika/silkhouse/LoginController.java`
**Type:** Spring MVC `@Controller`
**Lines:** 129

---

## Purpose
Handles authentication-adjacent routing: home page dispatch, user login/logout display, user registration, and a few static content pages. Spring Security handles the actual credential verification — this controller only manages the UI flows.

---

## Dependencies (Autowired)

| Field | Type | Used For |
|---|---|---|
| `userdao` | `Userdao` | Username/phone uniqueness checks + user save |

---

## Key Methods

| Method | Route | Description |
|---|---|---|
| `welcome()` | GET `/`, `/home` | Routes to admin or user home based on username |
| `login()` | GET `/login` | Show login template |
| `logout()` | GET `/logout` | Show login template (Spring Security handles invalidation) |
| `loginError()` | GET `/loginError` | Login page with `error=true` model attribute |
| `register()` | GET `/register` | Blank registration form |
| `registerProcess()` | POST `/register` | Validates and saves new user |
| `user()` | GET `/user` | Authenticated page showing logged-in username |
| `checker()` | GET `/user/products` | Product page stub for authenticated users |
| `contact()` | GET `/contact` | Contact page |

---

## Notable Observations

1. **Hardcoded admin routing**: `welcome()` checks `if (str1.equals(str))` where `str1 = "ashishadmin"`. This hardcodes a specific username as admin for routing purposes, separate from Spring Security's role system.
2. **Layered registration validation**: Checks are done in sequence — bean validation → password match → username unique → phone unique → email length.
3. **`@RestController` import is present but class is `@Controller`**: Unused import, likely leftover.
4. **`logout()` returns `"login"`** rather than triggering Spring Security logout — the actual logout (session invalidation) happens via the configured `logoutUrl("/logout")` in `WebSecurityConfig`.

---

## Related Pages
- [User entity](../entities/User.md)
- [User & Auth Routes](../endpoints/user-routes.md)
- [Authentication concept](../concepts/authentication.md)
- [WebSecurityConfig source](WebSecurityConfig.md)
