---
title: "Concept: Authentication"
category: concept
tags: [security, spring-security, bcrypt, roles, login]
last_updated: "2026-05-17"
source_count: 3
---

# Concept: Authentication

## Summary
Authentication and authorization are handled entirely by **Spring Security 5** via `WebSecurityConfig`. Passwords are stored BCrypt-encoded. Roles are derived from the `user_type` column in the `user` table via a custom `UserDetailsService`.

---

## Components

| Component | Location | Role |
|---|---|---|
| `WebSecurityConfig` | `config/WebSecurityConfig.java` | HTTP security rules, form login config |
| `UserDetailsServiceImpl` | `service/UserDetailsServiceImpl.java` | Loads user from DB by username |
| `BCryptPasswordEncoder` | Bean in `WebSecurityConfig` | Password hashing (strength 10) |
| `LoginController` | `LoginController.java` | Register endpoint, home routing |

---

## Role Mapping

The `user.user_type` column maps to Spring Security authorities:

| `user_type` value | Authority string | Access level |
|---|---|---|
| `0` | `USER` (or no special role) | Regular customer — can browse, cart, checkout |
| `1` | `ADMIN` | Full admin access |

The `UserDetailsServiceImpl` reads `user_type` from the `user` table and maps it to Spring Security `GrantedAuthority` objects.

---

## Route Protection Rules (WebSecurityConfig)

```
/                 → permitAll
/login            → permitAll
/logout           → permitAll
/profile          → authenticated (any logged-in user)
/users, /user,
/employee/**      → hasAnyAuthority('ADMIN', 'USER_MANAGER')
/admin            → hasAnyAuthority('ADMIN')
/admin**          → hasAnyAuthority('ADMIN')
/admin/**         → hasAnyAuthority('ADMIN')
Access denied     → redirects to /403
```

---

## Login Flow

1. User submits form at `POST /j_spring_security_check` (Spring Security's processing URL)
2. Spring Security calls `UserDetailsServiceImpl.loadUserByUsername(username)`
3. Service fetches user from `user` table, constructs `UserDetails` with authorities
4. BCrypt comparison of submitted password vs stored hash
5. **Success** → redirect to `/home`
6. **Failure** → redirect to `/login?error=true` → `LoginController.loginError()` sets `error=true` in model

---

## Home Page Routing (Post-Login)

`LoginController.welcome()` runs on `GET /home` or `GET /`:
- If no principal (unauthenticated) → return `user_home` template
- If username equals `"ashishadmin"` (hardcoded) → return `admin` template
- Otherwise → return `user_home` template

> ⚠️ **Known Issue**: The admin home redirect is based on a **hardcoded username** (`"ashishadmin"`), not on the Spring Security role. This means if another admin account is created, the routing won't work correctly.

---

## CSRF

CSRF protection is **disabled**: `http.csrf().disable()`. This simplifies form handling but is a security trade-off for production.

---

## Password Encoding

Passwords are hashed with BCrypt before storage. The `BCryptPasswordEncoder` bean is used:
- In `WebSecurityConfig.configureGlobal()` to wire the encoder to authentication
- Via `UserdaoImpl.saveOrUpdate()` which calls `.encode()` before INSERT

---

## Related Pages
- [User entity](../entities/User.md) — `user` table structure
- [Security Model synthesis](../synthesis/security-model.md) — deeper analysis
- [WebSecurityConfig source](../sources/WebSecurityConfig.md)
- [LoginController source](../sources/LoginController.md)
- [User & Auth Routes](../endpoints/user-routes.md)
