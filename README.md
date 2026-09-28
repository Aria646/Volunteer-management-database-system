# Volunteer Management Database System

A PostgreSQL-based database project for managing volunteers, event roles, shifts, and signups. The project demonstrates relational database design, integrity constraints, PL/pgSQL functions, and trigger-based validation.

## Project Overview

The system models a volunteer scheduling environment with four core entities:

- **Roles** — volunteer role definitions, minimum age requirements, and hourly credits
- **Volunteers** — volunteer profiles, dates of birth, contact details, and accumulated credits
- **Shifts** — scheduled volunteer sessions with venues, time ranges, capacities, and role assignments
- **Signups** — volunteer registrations for individual shifts

## Key Features

### Shift validation

A database-level `CHECK` constraint ensures that every shift:

- ends after it starts; and
- does not exceed eight hours in duration.

### Signup eligibility validation

A PL/pgSQL trigger function validates new volunteer signups before insertion. It checks:

- whether the volunteer satisfies the minimum-age requirement for the selected role; and
- whether the shift still has available capacity.

Cancelled signups are excluded from capacity calculations.

### Trigger-based business rules

The project uses PostgreSQL triggers to enforce business logic at the database layer, helping keep validation consistent regardless of which application accesses the database.

## Technologies

- PostgreSQL
- SQL
- PL/pgSQL
- Relational database design
- Constraints and triggers

## Repository Structure

```text
Volunteer-management-database-system/
├── README.md
└── volunteer_management.sql
```

## Skills Demonstrated

- Relational schema understanding
- SQL data definition and manipulation
- Database integrity constraints
- PL/pgSQL stored functions
- Trigger implementation
- Business-rule validation
- Capacity and eligibility logic

## Notes

This repository is a portfolio-oriented version of an academic database project. Student identifiers, submission templates, assessment instructions, and other course-administration material have been removed so the repository focuses on the technical implementation.
