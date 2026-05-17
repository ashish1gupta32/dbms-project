# AGENTS.md — Sarika Silk House LLM Wiki Schema

This file is the **schema** for the project wiki. Any LLM agent working on this project **must read this file first** before performing any wiki operation. It defines the directory layout, page conventions, and the exact workflows to follow for each operation type.

---

## 1. Project Overview

**Project:** Sarika Silk House — an eCommerce web application for a silk/textile business.
**Stack:** Java 11, Spring Boot 2.1.9, Spring MVC, Spring Security, Spring JDBC, Thymeleaf, H2 (dev) / MySQL (prod).
**Package root:** `com.sarika.silkhouse`

---

## 2. Three-Layer Architecture

| Layer | Location | Owner | Rule |
|---|---|---|---|
| Raw Sources | `src/`, `pom.xml`, `schema.sql` | You (developer) | **Immutable** — never modify during wiki operations |
| Wiki | `wiki/` | LLM agent | LLM writes and maintains all pages here |
| Schema | `AGENTS.md` (this file) | Co-evolved | Update as conventions improve |

---

## 3. Wiki Directory Layout

```
wiki/
├── index.md              ← Master catalog, always updated on every ingest
├── log.md                ← Append-only chronological log of all operations
├── overview.md           ← High-level project summary
├── entities/             ← One page per domain entity / DB table
│   ├── User.md
│   ├── Profile.md
│   ├── Item.md
│   ├── Cart.md
│   ├── Billing.md
│   ├── Employee.md
│   └── Customer.md
├── concepts/             ← Cross-cutting technical concepts
│   ├── authentication.md
│   ├── data-access-layer.md
│   └── product-catalog.md
├── endpoints/            ← URL route reference by controller
│   ├── admin-routes.md
│   ├── user-routes.md
│   └── cart-routes.md
├── sources/              ← One summary per ingested raw source file
│   ├── AdminController.md
│   ├── CartController.md
│   ├── LoginController.md
│   ├── ItemsController.md
│   ├── WebSecurityConfig.md
│   └── schema-sql.md
└── synthesis/            ← Analytical, cross-cutting pages
    ├── architecture-overview.md
    └── security-model.md
```

---

## 4. Page Frontmatter Format

Every wiki page **must** start with YAML frontmatter:

```yaml
---
title: "Page Title"
category: entity | concept | endpoint | source | synthesis | meta
tags: [tag1, tag2]
last_updated: "YYYY-MM-DD"
source_count: N
---
```

- `category` must be one of the enum values.
- `tags` help the index group related pages.
- `last_updated` is the date this page was last modified by the LLM.
- `source_count` = number of raw source files that informed this page.

---

## 5. Cross-Reference Convention

Use standard markdown links to cross-reference other wiki pages:
- Within the same directory: `[Cart entity](../entities/Cart.md)`
- From root: `[authentication](concepts/authentication.md)`

Every entity page **must** link to its DAO concept page. Every endpoint page **must** link to the entity pages for objects it handles. This keeps the wiki navigable as a graph.

---

## 6. Operation Workflows

### 6.1 INGEST — Adding a new source file to the wiki

**When:** You want the LLM to process a new or changed source file (Java, SQL, HTML, config).

**Steps:**
1. Read `wiki/index.md` to understand current wiki state.
2. Read `wiki/log.md` (last 10 entries) for recent context.
3. Read the raw source file(s) fully.
4. **Discuss** key takeaways (what does this file do, what's notable, what's new or changed).
5. Create or update the source summary page in `wiki/sources/`.
6. Update the relevant **entity pages** (`wiki/entities/`) if the source reveals fields, relationships, or business rules.
7. Update the relevant **concept pages** (`wiki/concepts/`) if the source touches authentication, DAOs, or product logic.
8. Update the relevant **endpoint pages** (`wiki/endpoints/`) if the source defines routes.
9. Update `wiki/index.md` — add any new pages, update summaries of changed pages.
10. Append an entry to `wiki/log.md` using the format:
    ```
    ## [YYYY-MM-DD] ingest | SourceFileName
    - Summary of what was ingested
    - Pages created: ...
    - Pages updated: ...
    ```

**Important:** A single source file may touch 5–10 wiki pages. Do all updates in one pass.

---

### 6.2 QUERY — Answering a question about the project

**When:** User asks a question about the codebase, architecture, business logic, or data model.

**Steps:**
1. Read `wiki/index.md` first. Identify the 3–5 most relevant pages.
2. Read those pages in full.
3. Synthesize an answer with citations (e.g., `[Cart entity](entities/Cart.md)`).
4. **If the answer reveals a valuable insight** (a cross-reference, a comparison, an analysis), **file it back** as a new page in `wiki/synthesis/` or update an existing page.
5. Append a query entry to `wiki/log.md`:
    ```
    ## [YYYY-MM-DD] query | "Question summary"
    - Pages consulted: ...
    - New page created (if any): ...
    ```

---

### 6.3 LINT — Health-checking the wiki

**When:** Periodically run to keep the wiki clean and consistent.

**Check for:**
- [ ] Pages in `wiki/` not listed in `wiki/index.md` (orphan pages)
- [ ] Pages listed in `wiki/index.md` that don't exist (broken links)
- [ ] Entity pages missing links to their concept page (`data-access-layer.md`)
- [ ] Endpoint pages missing entity links
- [ ] Contradictions between pages (e.g., field name differences)
- [ ] Stale claims — pages that haven't been updated since a related source changed
- [ ] Important concepts mentioned but lacking their own page
- [ ] `log.md` entries referencing files that no longer exist

**Output:** A lint report listing all issues, grouped by severity (error / warning / suggestion). File the lint report as `wiki/synthesis/lint-report-YYYY-MM-DD.md`.

Append to `wiki/log.md`:
```
## [YYYY-MM-DD] lint | Health check
- Issues found: N errors, M warnings, K suggestions
- Report filed: synthesis/lint-report-YYYY-MM-DD.md
```

---

## 7. index.md Format

`wiki/index.md` must be organized by category. Each entry:
```
- [Page Title](relative/path/to/page.md) — One-line summary. `last_updated: YYYY-MM-DD`
```

Categories: **Meta**, **Entities**, **Concepts**, **Endpoints**, **Sources**, **Synthesis**.

---

## 8. log.md Format

Each entry must start with:
```
## [YYYY-MM-DD] <operation> | <title>
```
Operations: `ingest`, `query`, `lint`, `update`.

The log is **append-only** — never delete or edit past entries. New entries go at the **bottom**.

Tip: `grep "^## \[" wiki/log.md | tail -10` gives the 10 most recent entries.

---

## 9. Guidelines

- **Never modify raw sources** (`src/`, `pom.xml`, `schema.sql`, `AGENTS.md`) during wiki operations.
- **Always read `index.md` first** before answering queries — never read raw source code to answer a query if the answer exists in the wiki.
- **Keep cross-references bidirectional** — if page A links to page B, page B should link back to A where appropriate.
- **File valuable answers** — don't let important syntheses disappear into chat history.
- **Prefer updating over creating** — update an existing page rather than creating a near-duplicate.
- The wiki is a **git repo** — all changes are version-tracked automatically.
