# Railway Ticketing and Management System (CLI)

---

## Overview

This project delivers a **secure, resource-optimized, command-line interface (CLI)** for railway ticketing. It is engineered to operate efficiently within a Linux shell environment, serving as a robust, industry-compliant solution where system overhead must be minimal. The design separates concerns into Passenger and Administration domains, built upon a high-integrity database foundation.

---

## System Capabilities Matrix

| Feature Set | Passenger Module | Administration Module | Technical Implementation |
| :--- | :--- | :--- | :--- |
| **Authentication** | Secure Registration and Login | Dedicated Admin Credentials | Bash Scripts interfacing with Database User Table |
| **Ticketing** | Search, Real-time Availability Check, Booking (PNR Generated) | View All Reservations (Global Oversight) | SQL Queries (SELECT, INSERT) via `sqlite3` or `psql` |
| **Management** | View History, Cancel Ticket | Add/Remove/Update Trains, Schedule Management | Bash Logic for Input Validation and SQL (UPDATE, DELETE) |
| **Interface** | Interactive Text-based User Interface (TUI) | Command-line Dashboard | **`dialog`** or **`whiptail`** Utilities |

---

## Technical Architecture (Hybrid Standard)

The system adheres to a modern, decoupled architecture, utilizing the following core components:

| Component | Technology | Role | Advantage |
| :--- | :--- | :--- | :--- |
| **Frontend/UI** | **`dialog`** / **`whiptail`** | Presents interactive menus and input forms to the user. | Superior User Experience within the terminal environment. |
| **Application Logic** | Structured **Bash Scripts** | Acts as the Controller; handles input validation, session management, and database communication. | Highly portable, lightweight, and leverages native Linux utilities. |
| **Persistence** | **SQLite** or **PostgreSQL** | Relational Database for secure and consistent storage of all user, train, and booking data. | Ensures data integrity, scalability, and robust transaction management. |
| **Data Access** | **SQL Commands** | Executed directly from Bash via the database's CLI client. | Eliminates unnecessary abstraction layers, maximizing performance. |

---

## Deployment and Operation

| Step | Command / Requirement | Purpose |
| :--- | :--- | :--- |
| **1. Prerequisites** | Linux Shell, Bash, `dialog`, `sqlite3` / `psql` | Ensure foundational utilities are installed. |
| **2. Clone** | `git clone [repository-url]` | Acquire the source code locally. |
| **3. Database Setup** | Execute `setup_database.sh` script | Initialize the database schema (Tables: `users`, `trains`, `bookings`). |
| **4. Execution** | `./main_menu.sh` | Launch the primary application entry point. |

---

## Contribution and Governance

A rigorous **Git Flow** is maintained to guarantee code stability and quality:
1.  **`main`** branch: Always production-ready and stable.
2.  **`temp_work`** branch: Integration point for all new features.
3.  **Feature Branches:** Required for all new work, branching off `temp_work`.
4.  **Pull Requests (PRs):** Mandatory for merging to `temp_work`, requiring minimum **one peer review** for code audit and quality assurance.

---

## License

*This project is licensed under the **MIT License** - see the [LICENSE.md](LICENSE.md) file for details.*
