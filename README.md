https://youtu.be/RehhAsktljA

# RaceDay — Part 1: System Planning and Database

Individual PoE project for a full-stack event management platform for South African road running, walking, and cycling events.

## What's in this part

Part 1 covers planning only — no application code. It contains:

| File | Description |
|---|---|
| `docs/RaceDay_ERD.png` / `.pdf` | Entity Relationship Diagram for the RaceDay database (6 entities) |
| `docs/RaceDay_Database.sql` | Full SQL Server script: schema + seed data |
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

## Notes on deviations

The SQL script matches the ERD exactly — no deviations. The `Roles` table was included as its own entity (rather than a plain text column on `Users`) specifically to demonstrate role-based system design ahead of Part 2's authentication endpoints.

## Next steps (Part 2)

Part 2 will implement the RESTful API against this schema, covering authentication, user profiles, events, categories, enrolments, and results.
