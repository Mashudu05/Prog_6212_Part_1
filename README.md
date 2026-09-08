https://youtu.be/RehhAsktljA?feature=shared
The YouTube link above provides a brief explanation of Parts that were done for Part 1 of the RaceDay project. It includes the ERD diagram and SQL code along with their explanations.

# RaceDay — Part 1: System Planning and Database
 
Individual PoE project for a full-stack event management platform for South African road running, walking, and cycling events.
 
## What's in this part
 
Part 1 covers planning only — no application code. It contains:
 
| File | Description |
|---|---|
| `docs/RaceDay_ERD.png` / `.pdf` | Entity Relationship Diagram for the RaceDay database (6 entities) |
| `docs/RaceDay_Database.sql` | Full SQL Server script: schema + seed data |
| `docs/RaceDay_API_Endpoint_Plan.pdf` | Full RESTful API endpoint specification |
| `docs/README.md` | This file |
 
## Prerequisites
 
- **SQL Server** (Developer or Express edition) — a clean/local instance is fine
- **SQL Server Management Studio (SSMS)** to run the script
- No application runtime is required for Part 1 (Part 2 introduces the API)
## Database setup
 
1. Open SSMS and connect to your local SQL Server instance.
2. Open `RaceDay_Database.sql` (File → Open → File...).
3. Run the entire script (Execute / F5). It will:
   - Create the `RaceDayDB` database
   - Create all 6 tables (`Roles`, `Users`, `Events`, `Categories`, `EventEnrolments`, `Results`) with primary keys, foreign keys, and constraints
   - Seed the database with sample data: 2 organisers, 2 participants, 3 events, 2 categories per event, 4 enrolments, and 2 results
4. Confirm it ran without errors, then expand **Databases → RaceDayDB → Tables** in Object Explorer to check all 6 tables exist.
5. Spot-check the seed data, e.g.:
```sql
   USE RaceDayDB;
   SELECT * FROM Users;
   SELECT * FROM Events;
```
 
## Entity Relationship Diagram
 
`RaceDay_ERD.png` (also provided as `.pdf`) shows all 6 entities, their attributes, primary/foreign keys, and the cardinality of every relationship:
 
- **Roles → Users** (1:M) — role-based access for Organisers and Participants
- **Users → Events** (1:M) — an organiser creates many events
- **Events → Categories** (1:M) — an event offers multiple distance categories
- **Events → EventEnrolments** (1:M) and **Categories → EventEnrolments** (1:M)
- **Users → EventEnrolments** (1:M) — a participant enrols in many events
- **EventEnrolments → Results** (1:1) — each enrolment produces one result
## API Endpoint Plan
 
`RaceDay_API_Endpoint_Plan.pdf` specifies every endpoint the RaceDay API will expose in Part 2, covering:
 
- **Authentication** — register, login
- **User Profile** — view/update profile, personal results history
- **Events** — list, view, create, update, delete, plus a live weather forecast endpoint
- **Categories** — list, create, update, delete
- **Event Enrolments** — enrol, view own enrolments, view an event's enrolments (organiser), cancel
- **Results** — capture a result, view an event's leaderboard, view a single result
Each entry lists the HTTP method, route, description, role required, request body, and expected response. Routes marked "(owner)" require the authenticated user's ID to match the OrganiserID on the parent event or the ParticipantID on the parent enrolment — this is enforced server-side in Part 2, not just by role.
 
This plan is intended to be matched closely by the implemented API in Part 2; any unavoidable deviations should be documented at that stage.
 
## Notes on deviations
 
The SQL script matches the ERD exactly — no deviations. The `Roles` table was included as its own entity (rather than a plain text column on `Users`) specifically to demonstrate role-based system design ahead of Part 2's authentication endpoints.
 
## Figma Prototype
 
A Figma prototype for RaceDay is being designed from the planning artifacts above, covering the core screens implied by the ERD, the user roles, and the API endpoint plan:
 
- **Authentication** — register and login screens, with a role selection (Organiser / Participant)
- **Participant flows** — browse/search upcoming events, view an event's categories and entry fees, enrol in a category, view personal enrolments, view personal results/performance history, view live weather and route info for an upcoming event
- **Organiser flows** — create/edit an event, add/edit categories for an event, view participants enrolled in an event, capture results for an event
- **Shared** — event details screen, results/leaderboard view
Prototype link: `[Add Figma link here]`
 
## Next steps (Part 2)
 
Part 2 will implement the RESTful API against this schema, covering authentication, user profiles, events, categories, enrolments, and results. 
