# 03 · System & Solution Design (Object-Oriented / UML)

**Goal of this phase:** re-express the use cases and data model from
[`02-system-analysis`](../02-system-analysis) in object-oriented form — how objects
collaborate to fulfill each use case, what states an entity can be in, and how the classes
are structured. This is the direct blueprint for the C# implementation.

---

## 1. Detailed Use Case Diagrams

Refined use case breakdown covering 8 functional areas — food & beverage service, station
management, user information, account registration, technical support, reporting, promotions,
staff information, and document/voucher management.

<img width="902" height="1155" alt="image" src="https://github.com/user-attachments/assets/c823ba71-9a5e-48c8-8b54-08a03cee2492" />


<img width="839" height="550" alt="image" src="https://github.com/user-attachments/assets/34eff015-1172-492d-bca7-9060248d2745" />


<img width="817" height="592" alt="image" src="https://github.com/user-attachments/assets/fba02603-e509-4680-a187-1a621ab26cad" />


<img width="843" height="582" alt="image" src="https://github.com/user-attachments/assets/09c80dc9-f7c1-4dbf-baa0-72848021388b" />


<img width="847" height="596" alt="image" src="https://github.com/user-attachments/assets/7a77627e-6c8e-494e-93c0-d3b69b08b6e1" />


The remaining diagrams are in the complete project.   

---

## 2. Behavioral Diagrams

For each of the 5 core workflows (login, station login, account creation, top-up invoicing,
incident confirmation), three complementary views were modeled: **activity** (the process
flow), **sequence** (object interaction over time), and **collaboration** (object
relationships during the interaction).

<img width="910" height="864" alt="image" src="https://github.com/user-attachments/assets/c61045a1-4100-449d-8967-524815335993" />


<img width="906" height="1055" alt="image" src="https://github.com/user-attachments/assets/0f5c70e0-9f1d-4df0-b1b3-b7d6f65b9ec2" />


<img width="906" height="503" alt="image" src="https://github.com/user-attachments/assets/c8b85fb0-2890-4a4f-b194-8f63ed15f391" />


The remaining diagrams are in the complete project.   

---

## 3. Class Diagram

The central design artifact of this phase — defines every class, its attributes,
operations, and relationships (association, aggregation, inheritance) across the system.

<img width="907" height="1023" alt="image" src="https://github.com/user-attachments/assets/1395996e-ed0b-4b4f-9cb1-0d2092916ea2" />


---

## 4. State Diagrams

Modeled the lifecycle of 8 key entities — each shows the valid states an object can be in
and the events that trigger transitions between them (useful for surfacing business rules
like "a station cannot go directly from Available to Under Maintenance without passing
through In Use").

<img width="915" height="395" alt="image" src="https://github.com/user-attachments/assets/38368d08-7400-4f13-8ae5-df50f6bfa745" />


<img width="915" height="413" alt="image" src="https://github.com/user-attachments/assets/7b44b52e-14a6-4de4-aa27-70556bfb06da" />


<img width="915" height="349" alt="image" src="https://github.com/user-attachments/assets/3c27dcf9-22bd-4814-a316-3119b956ed0c" />


The remaining diagrams are in the complete project.

---

## 5. Architecture & Deployment

<img width="910" height="919" alt="image" src="https://github.com/user-attachments/assets/b2bb24cb-cdce-4c79-9d24-33e00ca9475f" />


<img width="908" height="573" alt="image" src="https://github.com/user-attachments/assets/faca92f8-5db7-4812-b629-af157bbd2167" />


---

## 6. Outcomes

- Modeled 5 core workflows through 3 complementary UML views each (activity, sequence,
  collaboration) — 15 diagrams tracing exactly how objects collaborate to fulfill each use case
- Produced a full class diagram defining every class, attribute, and relationship used in
  the implementation — the direct blueprint for the C# object model in
  [`05-implementation`](../05-implementation)
- Modeled state lifecycles for 8 key entities, surfacing business rules (e.g. valid state
  transitions) that the implementation had to enforce in code
- Documented system architecture (component + deployment diagrams), connecting the design
  directly to how the application and database are actually deployed

---

## What this phase demonstrates

Object-oriented analysis and design using the full UML toolkit — not just drawing a class
diagram, but tracing a single business workflow through activity, sequence, and
collaboration views to validate the design before writing any code. This is the level of
detail a development team would expect from a solution design handoff.

**Next phase → [`04-database-engineering`](../04-database-engineering)**: the data
structures defined in the class diagram get implemented as an actual SQL Server schema,
with business rules enforced through views, stored procedures, and triggers.
