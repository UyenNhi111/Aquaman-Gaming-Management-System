# Aquaman Gaming – Internet Café Service Management System

**An end-to-end case study: from business needs to a working software product.**

> Business Analysis → System Analysis → Solution Design → Database Engineering → Implementation

This repository documents how I took a real small-business operational problem — managing
an internet café's accounts, computer stations, food & beverage service, technical support,
and promotions — through a complete software delivery lifecycle: from talking to
stakeholders and mapping business processes, to a working C#.NET desktop application
backed by SQL Server.

It isn't a single class assignment. It's five pieces of work, done across different
courses, reorganized here into the order a real project would actually follow.

---

## Why this repo looks the way it does

Most student portfolios show either "I can code" or "I can draw a use case diagram."
This one shows the connective tissue between them: how a vague business problem gets
turned into requirements, requirements get turned into a data & object model, and that
model gets turned into a running application with business rules enforced at the database
level. That end-to-end view is the thing this repo is meant to demonstrate.

## How to navigate this repo depending on what you're evaluating

| If you're looking for... | Go to |
|---|---|
| Requirements gathering, stakeholder analysis, process modeling (BA skills) | [`docs/01-business-analysis`](docs/01-business-analysis) |
| Formal system specification: use cases, data flow, conceptual data model | [`docs/02-system-analysis`](docs/02-system-analysis) |
| Object-oriented design: class diagrams, sequence/activity/state diagrams | [`docs/03-system-design`](docs/03-system-design) |
| Database schema, views, stored procedures, triggers, business-rule enforcement | [`docs/04-database-engineering`](docs/04-database-engineering) |
| The actual running application, C# source, screenshots | [`docs/05-implementation`](docs/05-implementation) and [`src/`](src) |

---

## Project journey

### 1 — Business Analysis
Started from the business side, not the system side: who are the stakeholders, what do
they actually need, what's broken in the current (manual) process. Used the BACCM
framework, stakeholder analysis, SIPOC/AS-IS process mapping, SWOT, structured interviews
and user stories, resulting in a full functional/non-functional requirements set with a
requirements traceability matrix.
→ [`docs/01-business-analysis`](docs/01-business-analysis)

### 2 — System Analysis
Translated business requirements into a formal system specification: use case model,
business function decomposition (BFD), a 3-level data flow diagram (context → level 0 →
level 1), and a conceptual/logical data model.
→ [`docs/02-system-analysis`](docs/02-system-analysis)

### 3 — System & Solution Design
Re-expressed the analysis in object-oriented form: detailed use cases, class diagram,
activity/sequence/collaboration diagrams for core workflows, and state diagrams for key
entities.
→ [`docs/03-system-design`](docs/03-system-design)

### 4 — Database Engineering
Implemented the data layer in SQL Server — not just tables, but business rules enforced
directly through views, stored procedures, and triggers (validation, audit logging,
controlled data recovery).
→ [`docs/04-database-engineering`](docs/04-database-engineering)

### 5 — Implementation
Built the working desktop application in C#.NET against the SQL Server database: account
lifecycle management, top-up invoicing, food & beverage ordering, technical support
ticketing, reporting, and input validation throughout.
→ [`docs/05-implementation`](docs/05-implementation)

---

## Overall Outcomes

- Delivered a complete requirements set (BRD, use cases, traceability matrix) and carried
  every requirement through to a working feature — nothing was lost between analysis and
  implementation
- Modeled the system through both structured analysis (DFD/BFD) and object-oriented
  design (UML), showing fluency in two different analysis approaches on the same problem
- Enforced business rules directly at the database layer (triggers, stored procedures,
  audit logging) rather than relying on the application layer alone
- Shipped a working, validated desktop application covering all core business functions
  identified in the initial business analysis

## Tech stack

- **Modeling & documentation:** BPMN, UML (use case, class, sequence, activity, state), DFD, Microsoft Visio
- **Database:** Microsoft SQL Server, T-SQL (views, stored procedures, triggers)
- **Application:** C#.NET, Visual Studio 2022
- **Tools:** SQL Server Management Studio, Azure Data Studio

## About

Nguyễn Thị Uyên Nhi — final-year Management Information Systems student.
