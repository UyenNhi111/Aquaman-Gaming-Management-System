# 02 · System Analysis

**Goal of this phase:** translate the business requirements defined in
[`01-business-analysis`](../01-business-analysis) into a formal system specification —
what the system must do (use cases), how data moves through it (BFD/DFD), and how that
data is structured (conceptual & logical data model). This is the handoff point between
"what the business needs" and "what the system looks like."

---

## 1. Use Case Model

The overall use case diagram identifies 3 actors (User/Customer, Staff, Manager) and 7
functional areas, each broken down into a detailed use case diagram.

<img width="915" height="659" alt="image" src="https://github.com/user-attachments/assets/ae93f2b2-10b9-4af2-a427-b6f7bf17f322" />


**Detailed use case diagrams:**

<img width="915" height="626" alt="image" src="https://github.com/user-attachments/assets/b8babe94-9400-41f7-844d-e967afbc2605" />


<img width="915" height="648" alt="image" src="https://github.com/user-attachments/assets/74eae57e-ba42-45a1-84f4-775ae1c61bd8" />


<img width="915" height="634" alt="image" src="https://github.com/user-attachments/assets/8ba1084c-4fe0-42f0-81e8-aa412041996e" />


<img width="915" height="626" alt="image" src="https://github.com/user-attachments/assets/0718376b-22ec-4326-bd56-8cb69afe05de" />


<img width="915" height="641" alt="image" src="https://github.com/user-attachments/assets/9f7100a4-1a0e-4ecc-abf5-105028bf858d" />


<img width="915" height="644" alt="image" src="https://github.com/user-attachments/assets/581e9417-8838-4985-9bcb-295ca5e56174" />


<img width="915" height="651" alt="image" src="https://github.com/user-attachments/assets/62bc3d32-fcc1-4e03-9faa-bde89b7d4dcc" />


---

## 2. Business Function Decomposition (BFD)

A top-down breakdown of the system's functions into a hierarchy — this is the bridge
between the use case model and the data flow diagrams below.

<img width="915" height="554" alt="image" src="https://github.com/user-attachments/assets/5c619b25-e8ce-43ed-9359-a1528d34c35f" />


---

## 3. Data Flow Diagrams (DFD)

Modeled at three levels of detail, standard for structured systems analysis: context
(system boundary), level 0 (major processes), and level 1 (detailed process breakdown
for each major workflow). Here is level 1

<img width="743" height="681" alt="image" src="https://github.com/user-attachments/assets/f9827bfa-7758-4d91-b9d9-2de6d96dd105" />


<img width="739" height="543" alt="image" src="https://github.com/user-attachments/assets/50a94395-e203-4e11-8120-4f87090c7224" />


<img width="915" height="672" alt="image" src="https://github.com/user-attachments/assets/393491fc-1d1a-4c64-a864-8b7e4a47de40" />


<img width="915" height="578" alt="image" src="https://github.com/user-attachments/assets/0d892863-f376-4902-86e0-1b6c82645893" />


---

## 4. Data Modeling

The DFD's data stores were formalized into a conceptual data model (entities and
relationships, technology-independent), then refined into a logical data model
(attributes, keys, and constraints defined) — the direct input to the database schema
in [`04-database-engineering`](../04-database-engineering).

<img width="915" height="718" alt="image" src="https://github.com/user-attachments/assets/8ea52f37-8dee-48d9-9f23-0c47c8c681b4" />


<img width="915" height="742" alt="image" src="https://github.com/user-attachments/assets/21012356-73c0-4768-ba43-cf45ea6365a6" />


**Core entities identified:** `NGUOIDUNG` (User), `TAIKHOAN` (Account), `MAYTINH`
(Station), `NHANVIEN` (Staff), `TAIKHOANNHANVIEN` (Staff Account), `HOADONNAPTIEN`
(Top-up Invoice), `KHUYENMAI` (Promotion), `DICHVUANUONG` (F&B Service),
`HOADONDICHVU` (Service Invoice).

---

## 5. Outcomes

- Translated the BRD from phase 01 into a complete use case model — 3 actors, 7 functional
  areas, both overview and detailed level
- Produced a 3-level DFD (context → level 0 → level 1) tracing data flow across all 4
  core business processes identified in phase 01
- Built a conceptual data model that was refined into a logical model — the direct
  blueprint for the physical schema implemented in
  [`04-database-engineering`](../04-database-engineering)
- Every use case and data entity here traces back to a specific requirement from
  [`01-business-analysis`](../01-business-analysis), keeping the requirements traceability
  matrix consistent end-to-end

---

## What this phase demonstrates

Formal requirements modeling using structured analysis techniques — use case modeling,
functional decomposition, data flow diagramming, and conceptual/logical data modeling.
This is the layer of work that sits between raw business requirements and technical design,
often owned by a Systems Analyst or a BA working closely with the development team.

**Next phase → [`03-system-design`](../03-system-design)**: these use cases and the data
model get re-expressed in object-oriented form — class diagrams, sequence diagrams, and
behavioral models — as the direct input to implementation.
