# 05 · Implementation

**Goal of this phase:** deliver a working desktop application that implements the class
design from [`03-system-design`](../03-system-design) against the database from
[`04-database-engineering`](../04-database-engineering) — turning the requirements from
phase 01 into software that actually runs.

---

## 1. Tech Stack

- **Language / Framework:** C#.NET (WinForms)
- **Database:** Microsoft SQL Server
- **IDE / Tools:** Visual Studio 2022, SQL Server Management Studio, Microsoft Visio

---

## 2. How to Run

```bash
1. Open src/AquamanGamingManagement.sln in Visual Studio 2022
2. Restore NuGet packages (if prompted)
3. Update the connection string in [App.config / relevant config file] to point to your
   local SQL Server instance
4. Run docs/04-database-engineering/schema.sql against your SQL Server to create the database
5. Press F5 to build and run
```

> ⚠️ Replace any real server name / credentials in the connection string with a placeholder
> before pushing this repo publicly — see [`04-database-engineering`](../04-database-engineering)
> for the schema this app depends on.

---

## 3. Core Features

| Module | What it does |
|---|---|
| **Authentication** | Separate login flows for customers and staff, with input validation and lockout after repeated failed attempts |
| **Account Management** | Create regular/temporary accounts, activate/lock/delete with state transitions, search & filter |
| **Top-up & Invoicing** | Create top-up invoices, multiple payment methods, search by invoice ID/amount/method |
| **User Information Management** | Full CRUD with multi-criteria search (name, phone, DOB, gender) |
| **Food & Beverage Service** | Menu CRUD, order management, order confirmation & printed invoice |
| **Technical Support** | Log incidents, track status (unprocessed / processed / under maintenance), search by description or date range |
| **Reporting & Statistics** | Station revenue, F&B revenue, incident statistics, user statistics, station status overview |
| **Promotions** | CRUD for promotional programs with search |

---

## 4. Screenshots

<img width="884" height="576" alt="image" src="https://github.com/user-attachments/assets/87f31df9-1347-418a-aa1e-1eb1cef1b2fd" />


<img width="888" height="579" alt="image" src="https://github.com/user-attachments/assets/36335b7a-4a98-470c-93da-d98cee18b708" />


<img width="822" height="536" alt="image" src="https://github.com/user-attachments/assets/d5493060-ab47-4e93-9f58-9a3547823667" />


<img width="882" height="575" alt="image" src="https://github.com/user-attachments/assets/f2e11df4-6705-403d-9010-9481af0c3235" />


<img width="871" height="568" alt="image" src="https://github.com/user-attachments/assets/89922ab3-5fde-4d69-8c33-31253f879b41" />


<img width="915" height="597" alt="image" src="https://github.com/user-attachments/assets/ebf7fef9-e4b0-415f-b8c8-3a91ab3e37a8" />


<img width="882" height="575" alt="image" src="https://github.com/user-attachments/assets/d4263a8d-9caf-4af6-8b6e-4ea06ae459bf" />


<img width="875" height="570" alt="image" src="https://github.com/user-attachments/assets/35e3dea6-31d1-4af4-ab09-b196ca7c4759" />


<img width="915" height="597" alt="image" src="https://github.com/user-attachments/assets/103eb294-9c68-4d48-9618-215092f3a4b0" />


---

## 5. Design Decisions Worth Calling Out

- **Input validation everywhere a user can make a mistake** — empty fields, duplicate
  usernames, mismatched password confirmation, invalid balance — all caught before hitting
  the database, with clear inline error messages
- **State-driven account lifecycle** — accounts move through Active/Locked/Deleted states
  matching the state diagram from [`03-system-design`](../03-system-design), not just a
  boolean flag
- **Business logic reused from the database layer** — the app calls the stored procedures
  and views from [`04-database-engineering`](../04-database-engineering) instead of
  duplicating that logic in C#, keeping a single source of truth for business rules

---

## 6. Outcomes

- Delivered a fully working desktop application covering all 8 core modules identified
  back in [`01-business-analysis`](../01-business-analysis)
- Implemented input validation and state-driven workflows matching the design artifacts
  from [`03-system-design`](../03-system-design) — the design wasn't just documentation,
  it was actually followed through to code
- Integrated directly with the stored procedures, views, and triggers from
  [`04-database-engineering`](../04-database-engineering) rather than re-implementing
  business logic in the application layer
- Closed the loop from [`01-business-analysis`](../01-business-analysis): every functional
  requirement defined in phase 01 has a corresponding, working feature here

---

## What this phase demonstrates

The ability to carry a design through to a working product — not just C# syntax, but
translating UML class/state diagrams and enforced database rules into a coherent,
validated application. Combined with phases 01–04, this closes the loop from business
problem to shipped software: the kind of end-to-end delivery view that's valuable whether
you end up in a BA, DA, or PO role.
