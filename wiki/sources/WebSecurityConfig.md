---
title: "Source: WebSecurityConfig.java"
category: source
tags: [security, spring-security, config, roles, bcrypt]
last_updated: "2026-05-17"
source_count: 1
---

# Source: WebSecurityConfig.java

**Path:** `src/main/java/com/sarika/silkhouse/config/WebSecurityConfig.java`
**Type:** Spring `@Configuration @EnableWebSecurity`
**Lines:** 70

---

## Purpose
Central Spring Security configuration. Defines:
- Authentication provider (DB-backed via `UserDetailsServiceImpl` + BCrypt)
- HTTP authorization rules (which roles can access which URLs)
- Form login and logout configuration

---

## Authentication Setup

```java
@Autowired
public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
    auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
}
```
Connects `UserDetailsServiceImpl` (custom DB loader) with BCrypt password encoder.

---

## BCrypt Bean

```java
@Bean
public BCryptPasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();  // default strength = 10
}
```
Used by `UserdaoImpl` to encode passwords before INSERT, and by Spring Security for login verification.

---

## HTTP Security Rules (in priority order)

| Pattern | Required Authority | Notes |
|---|---|---|
| `/`, `/login`, `/logout` | None (permitAll) | Public routes |
| `/profile` | authenticated | Any logged-in user |
| `/users`, `/user`, `/employee/**` | `ADMIN` or `USER_MANAGER` | Staff management |
| `/admin` | `ADMIN` only | Admin dashboard |
| `/admin**` | `ADMIN` only | Admin root pattern |
| `/admin/**` | `ADMIN` only | All admin sub-routes |
| Access denied | — | Redirects to `/403` |

---

## Form Login Configuration

| Setting | Value |
|---|---|
| Login processing URL | `/j_spring_security_check` |
| Login page | `/login` |
| Success redirect | `/home` |
| Failure redirect | `/login?error=true` |
| Username parameter | `username` |
| Password parameter | `password` |

---

## Logout Configuration

| Setting | Value |
|---|---|
| Logout URL | `/logout` |
| Post-logout redirect | `/` |

---

## CSRF

`http.csrf().disable()` — CSRF protection is disabled. Simplifies form handling but is a risk for production deployments.

---

## Notable Observations

1. **`USER_MANAGER` authority referenced** in `/users`, `/user`, `/employee/**` — but no user in the `user` table has `user_type` mapped to `USER_MANAGER`. This may be dead/future-proofing code.
2. **Cart routes NOT protected** — `CartController` routes (`/buyitem/**`) are not listed in `WebSecurityConfig`. Protection is done manually inside each controller method via `getUserPrincipal()` null check.
3. **Two admin patterns** — `/admin`, `/admin**`, `/admin/**` are listed separately. This triple-pattern approach is for thorough coverage but could be consolidated.

---

## Related Pages
- [Authentication concept](../concepts/authentication.md)
- [Security Model synthesis](../synthesis/security-model.md)
- [User entity](../entities/User.md)
- [User & Auth Routes](../endpoints/user-routes.md)
