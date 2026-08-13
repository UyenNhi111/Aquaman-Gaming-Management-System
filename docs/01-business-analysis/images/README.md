# 01 · Business Analysis

**Goal of this phase:** understand the business problem before touching any system design —
who is affected, what they actually need, how the process works today, and what "success"
looks like. This phase used the BACCM framework, stakeholder analysis, process mapping
(SIPOC / AS-IS / TO-BE), and requirements elicitation techniques from BABOK.

---

## 1. Project Context

The Aquaman Gaming internet café ran its operations manually — logging play time by hand,
calculating charges manually, and tracking food orders and technical issues on paper. This
created billing errors, slow checkout, and no reliable revenue reporting.

**Objective:** analyze the current business process and define the requirements for a
management system that automates account handling, session billing, food & beverage
service, technical support, and reporting.

---

## 2. Stakeholder Analysis

| Stakeholder | Role in the Project |
|---|---|
| Owner | Investment decision-maker; needs revenue tracking and financial reporting |
| Counter Staff | Operates the system daily — session assignment, billing, service entry |
| Customers | End users of the service; expect fast, accurate transactions |
| Technical Staff | Maintains hardware, updates computer/station records |
| Food & Beverage Staff | Handles food/drink orders for customers |
| Software Developer | Builds the system based on requirements defined by the BA |

---

## 3. BACCM Analysis (Business Analysis Core Concept Model)

| Concept | Summary |
|---|---|
| **Change** | Shift from manual, paper-based operations to an automated management system |
| **Need** | Fast session billing, accurate revenue tracking, food service management, customer data retention |
| **Solution** | A desktop management application covering login, station assignment, time-based billing, service orders, invoicing, and reporting |
| **Stakeholder** | Owner, counter staff, customers, technical staff, food service staff, developer |
| **Value** | Faster checkout, fewer billing errors, reliable revenue data for decision-making, better customer experience |
| **Context** | Mid-size café, open 24/7, mixed customer base (students, casual and competitive gamers), combined gaming + food service |

---

## 4. Elicitation & Analysis Techniques Applied

**Core techniques**
- Business Process Analysis — mapped the current workflow (station booking → billing → checkout) to surface bottlenecks
- Business Rules Analysis — extracted the policies the system must enforce (see §6)
- Business Process Modeling (BPMN) — visualized the end-to-end process flow
- Data Flow Diagram (DFD) — modeled how data moves between users, the system, and data stores

**Supporting techniques**
- Stakeholder Interviews / Survey — with the owner, staff, and customers
- User Stories — requirements written from the user's perspective
- SWOT Analysis — evaluated risk and opportunity of the proposed change
- Requirements Traceability Matrix — tracked each requirement from origin to design artifact

---

## 5. Requirements

### 5.1 Functional Requirements (sample)
- Record session start/end time per customer
- Automatically calculate charges based on usage time and services ordered
- Manage customer, station, and food/beverage service records
- Generate invoices and retain transaction history

<img width="667" height="724" alt="image" src="https://github.com/user-attachments/assets/a28f9e72-79ea-4235-ac9b-e6dbc81395a9" />

### 5.2 Non-Functional Requirements (sample)
- **Performance:** transactions processed in under 3 seconds
- **Security:** access restricted to authorized staff accounts
- **Availability:** system must run reliably 24/7
- **Usability:** interface simple enough for new staff to learn quickly

### 5.3 Business Rules (sample)
- 1 hour of usage = 10,000 VND
- VIP members receive a 10% discount on session rate
- Station automatically disconnects when time balance reaches zero
- Food & beverage charges are merged into the customer's session invoice

---

## 6. Process Analysis — AS-IS → TO-BE

- SIPOC diagram — account registration & top-up process
<img width="915" height="414" alt="image" src="https://github.com/user-attachments/assets/5804a2fe-0927-4906-bab0-b3c1e5ccd3eb" />


- SIPOC diagram — food & beverage service process
<img width="915" height="415" alt="image" src="https://github.com/user-attachments/assets/81888b70-9d48-4056-aca6-faf4bad0f5b5" />


- SIPOC diagram — technical support process
<img width="915" height="415" alt="image" src="https://github.com/user-attachments/assets/591f740a-b0a0-4f18-82be-b4e4c25bd26e" />


The TO-BE process eliminates manual time logging and paper-based billing — session charges, food orders, and technical support requests are now calculated and recorded automatically, reducing checkout time and removing the calculation errors inherent in the manual process.

---

## 7. Business Process & Data Modeling

- BPMN — account registration & management process
<img width="915" height="586" alt="image" src="https://github.com/user-attachments/assets/06866037-cfe6-46c0-a6cc-f98926789dd1" />


- BPMN — food & beverage service process
<img width="915" height="623" alt="image" src="https://github.com/user-attachments/assets/81944889-6d24-49c5-b804-f2fa695bccf6" />


- BPMN — technical support process
<img width="915" height="486" alt="image" src="https://github.com/user-attachments/assets/a587545a-4ba0-4516-9444-0b52d9906195" />


- DFD — context diagram (system boundary, external entities)
<img width="696" height="528" alt="image" src="https://github.com/user-attachments/assets/997377a8-fd2f-4057-b095-8a2f98903143" />


- DFD — level 1 (main process breakdown)
<img width="915" height="581" alt="image" src="https://github.com/user-attachments/assets/6f430163-b2bb-4e83-a041-9ba640b6bb09" />


---

## What this phase demonstrates

Stakeholder management, requirements elicitation (interviews, user stories), business
process modeling (BPMN/DFD), business rule definition, and requirements traceability —
the core deliverables of a Business Analyst working at the front end of a software project,
before any system or database design begins.

**Next phase → [`02-system-analysis`](../02-system-analysis)**: these requirements get
translated into a formal system specification (use cases, refined DFD, conceptual data model).
