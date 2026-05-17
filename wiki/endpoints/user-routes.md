---
title: "Endpoints: User & Auth Routes"
category: endpoint
tags: [login, register, home, user, auth, routes]
last_updated: "2026-05-17"
source_count: 2
---

# Endpoints: User & Auth Routes

Public and authenticated user routes. Handled primarily by `LoginController`.

---

## Home & Navigation

| Method | URL | Handler | Template | Access | Description |
|---|---|---|---|---|---|
| GET | `/` | `welcome()` | `user_home.html` or `admin.html` | Public | Home page; routes to admin if username is `ashishadmin` |
| GET | `/home` | `welcome()` | `user_home.html` or `admin.html` | Public | Same handler as `/` |
| GET | `/contact` | `contact()` | `contact.html` | Public | Contact page |
| GET | `/user` | `user()` | `user.html` | Authenticated | Shows logged-in username |
| GET | `/user/products` | `checker()` | `product.html` | Authenticated | User product page (stub) |

---

## Authentication

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/login` | `LoginController.login()` | `login.html` | Show login form |
| POST | `/j_spring_security_check` | *(Spring Security)* | — | Form processing URL (configured in `WebSecurityConfig`) |
| GET | `/loginError` | `loginError()` | `login.html` with `error=true` | Failed login redirect |
| GET | `/logout` | `LoginController.logout()` | `login.html` | Shows login page (Spring Security handles session invalidation) |

**Login form fields:** `username`, `password`
**On success:** redirect to `/home`
**On failure:** redirect to `/login?error=true`

---

## Registration

| Method | URL | Handler | Template | Description |
|---|---|---|---|---|
| GET | `/register` | `register()` | `register.html` | Blank registration form |
| POST | `/register` | `registerProcess()` | `registersuccesful.html` or back to `register` | Process new user |

**Registration validation steps (in order):**
1. Bean validation (`@Valid User`) — all fields `@NotEmpty`
2. `password == mpassword` — else error: *"passwords dont match"*
3. Username uniqueness — `userdao.getUser(username) == null` — else: *"username exists"*
4. Phone uniqueness — `userdao.getNumber(phone) == null` — else: *"mobile number already exists"*
5. Email length — `email.length() <= 100` — else: *"email length is very large"*
6. If all pass → `userdao.saveOrUpdate(user)` → `registersuccesful.html`

---

## Related Pages
- [User entity](../entities/User.md) — User POJO and DB table
- [Authentication concept](../concepts/authentication.md) — Spring Security config
- [LoginController source](../sources/LoginController.md)
- [WebSecurityConfig source](../sources/WebSecurityConfig.md)
