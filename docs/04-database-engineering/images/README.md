# 04 · Database Engineering

**Goal of this phase:** implement the logical data model from
[`02-system-analysis`](../02-system-analysis) as a real SQL Server database — and go
beyond plain tables by enforcing business rules (from
[`01-business-analysis`](../01-business-analysis)) directly at the data layer through
views, stored procedures, and triggers.

---

## 1. Entity-Relationship Diagram

<img width="915" height="718" alt="image" src="https://github.com/user-attachments/assets/274e9f71-5592-4d51-a121-d8a0fa051986" />


**Core tables:** `NGUOIDUNG` (User), `TAIKHOAN` (Account), `NHANVIEN` (Staff),
`TAIKHOANNHANVIEN` (Staff Account), `MAYTINH` (Station), `DICHVUANUONG` (F&B Service),
`HOADONNAPTIEN` (Top-up Invoice), `HOADONDICHVU` (Service Invoice), `KHUYENMAI`
(Promotion), `HOTROKYTHUAT` (Technical Support).

---

## 2. Schema (DDL)

The complete, executable schema — every `CREATE TABLE`, key, and constraint. This is a
real `.sql` file, not a screenshot, so it can be reviewed or run directly.

---

## 3. Business Rules Enforced at the Database Level

This is the most distinctive part of this repo — business rules from phase 01 aren't just
documented, they're **enforced in the schema itself** so invalid data can't exist
regardless of which application talks to the database.

| Rule | Enforcement mechanism |
|---|---|
| Account balance must be ≥ 5,000 VND to activate | Constraint / trigger on `TAIKHOAN` |
| Account auto-locked after 6 months of inactivity, deleted after 12 months | Business logic + scheduled check |
| Account status must be one of: *Not activated, Active, Locked, Deleted* | `CHECK` constraint on `TrangThaiTK` |
| New records get auto-generated IDs | `INSTEAD OF INSERT` trigger |
| Staff records are locked (not deleted) when an employee leaves | `INSTEAD OF DELETE` trigger on `NHANVIEN` |
| Unauthorized direct DML on protected tables is blocked | `INSTEAD OF` trigger + recovery procedure from log |
| All data changes are logged for audit | `AFTER` trigger writing to a history/log table |
| Password length must meet minimum requirement | `AFTER` trigger validation |
| Staff count per position is capped | `AFTER` trigger validation |
| Schema changes (DDL) are logged and can be restricted | `DDL trigger` |

---

## 4. Views

Reporting- and operations-oriented views that simplify querying without exposing raw
table joins to the application layer.

| View | Purpose |
|---|---|
| `vw_nguoidung` | Simplified user info (name, gender, DOB, phone) |
| `vw_thongtin_hoadonnaptien` | Full top-up invoice detail, joined across related tables |
| `vw_nguoidung_dangsudung` | Real-time list of customers currently occupying a station |
| `vw_doanhthu_anuong` | Aggregated food & beverage revenue |

---

## 5. Stored Procedures

| Procedure | Purpose |
|---|---|
| `usp_GetDichVuInfo` | Retrieve food/beverage service info by ID |
| `usp_GetTaiKhoanBySoDu` | List accounts with balance above a minimum threshold |
| Account creation procedure | Insert a new account plus all related records in one transaction |
| Top-up statistics procedure | Aggregate top-up activity per user |
| Service search procedure | Search food & beverage services by criteria |
| Recovery procedure | Restore a table's data from the audit log after a blocked/rolled-back change |

---

## 6. Outcomes

- Implemented the full logical data model from phase 02 as a working SQL Server schema
- Enforced 10+ business rules directly at the database layer (constraints, triggers) —
  meaning data integrity doesn't depend on the application layer getting it right every time
- Built an audit-logging mechanism (AFTER + DDL triggers) that tracks both data changes
  and schema changes
- Wrote reusable views and stored procedures that the C# application in
  [`05-implementation`](../05-implementation) calls directly instead of embedding raw SQL

---

## What this phase demonstrates

Practical SQL Server development beyond basic CRUD — trigger-based business rule
enforcement, audit logging, transactional stored procedures, and reporting views. This is
the layer of work most relevant to a Data Analyst role (writing and understanding
production-grade SQL) and shows a BA-adjacent skill most BAs don't have: the ability to
read and reason about the actual data layer, not just the diagrams above it.

**Next phase → [`05-implementation`](../05-implementation)**: the C# desktop application
that consumes this schema, these views, and these stored procedures.
