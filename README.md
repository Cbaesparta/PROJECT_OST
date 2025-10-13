

# PROJECT_OST  

## 🧭 Overview  

**PROJECT_OST** is a collaborative software project built to automate, organize, and manage operational tasks using shell scripts, a lightweight database, and Git-based collaboration.  
The project was designed as a **learning-focused, real-world simulation** of how developers work together in a version-controlled environment.  

It demonstrates how teamwork, Git commands, task division, and automation come together to create a functional and maintainable system.  

---

## 🚀 Project Goals  

- Build a working shell-based automation project with clear modularity.  
- Learn and apply **Git & GitHub collaboration techniques** (branching, merging, pull requests).  
- Practice **team-based development** with defined roles and responsibilities.  
- Create maintainable, reusable scripts for initialization, menu management, and utilities.  
- Gain hands-on experience with database integration in a shell project.  

---

## 🧩 Repository Structure  

```

PROJECT_OST/
│
├── scripts/               # Helper and automation scripts
├── .gitignore             # Ignored files
├── README.md              # Main documentation (this file)
├── READ_ME.md             # Legacy readme (can be merged later)
├── database_setup.sh      # Script to initialize database
├── menu.sh                # Menu-driven shell interface
├── railway.db             # SQLite database file
└── run.sh                 # Main startup script

````

---

## ⚙️ Project Setup & Workflow  

### 🧱 1. Initialization  

Clone the repository and create a working branch:

```bash
git clone https://github.com/Cbaesparta/PROJECT_OST.git
cd PROJECT_OST
git checkout -b temp_work
````

Make scripts executable:

```bash
chmod +x *.sh
chmod +x scripts/*.sh
```

### 🧰 2. Database Setup

Initialize the database:

```bash
./database_setup.sh
```

This script creates tables and inserts initial data into `railway.db`.

### ▶️ 3. Running the Project

Start the main program:

```bash
./run.sh
```

This triggers `menu.sh` to display an interactive menu with options such as starting modules, running tasks, or exiting.

---

## 🌿 Git Commands Used and Collaboration Process

Git was used to maintain version control, collaboration, and workflow organization.

### 🔹 Branching Strategy

* `main` — Stable, production-ready branch.
* `temp_work` — Development and experimental branch.
* Feature branches (e.g., `feature-database`) — for specific tasks.

Commands used:

```bash
git branch <branch-name>        # Create new branch
git checkout <branch-name>      # Switch branch
git merge <branch-name>         # Merge changes
git push origin <branch-name>   # Push to GitHub
```

### 🔹 Commit Practices

Meaningful commit messages:

```bash
git add .
git commit -m "Added database initialization script"
git commit -m "Fixed menu options and improved user interface"
```

* Use **imperative mood** (“Add feature”, “Fix bug”)
* Keep commits **small and logical**
* Reference issues/tasks when applicable

### 🔹 Collaboration & Review

* Members created **pull requests** for every feature branch.
* Each PR was reviewed by at least one other member.
* Conflicts resolved with:

```bash
git merge --abort
git pull --rebase
```

### 🔹 Synchronization

Keep local branches up to date:

```bash
git fetch origin
git pull origin main
```

---

## 👥 Team Roles & Contributions

| Member                          | Role               | Responsibilities                                                      |
| ------------------------------- | ------------------ | --------------------------------------------------------------------- |
| **Team Lead (Project Manager)** | Oversaw project    | Managed Git workflow, reviewed PRs, maintained branch stability       |
| **Database Specialist**         | DB design          | Created `database_setup.sh`, defined schema, ensured data consistency |
| **Backend Developer**           | Script logic       | Built `menu.sh`, implemented user interactions and core logic         |
| **DevOps Engineer**             | Automation & setup | Created `run.sh`, handled script execution and environment setup      |
| **QA / Tester**                 | Testing            | Verified menu options, database setup, and script behavior            |

---

## 🧠 Tasks Completed

### 🔸 Phase 1 – Initialization

* Git repository setup and `.gitignore` configuration
* Skeleton project structure created

### 🔸 Phase 2 – Database Development

* Designed schema and structure for `railway.db`
* Implemented `database_setup.sh`
* Verified DB creation and integrity

### 🔸 Phase 3 – Core Functionality

* Developed `menu.sh` for interactive menu
* Implemented user input handling and task execution
* Created `run.sh` as main entry point

### 🔸 Phase 4 – Scripts & Utilities

* Added `scripts/` folder with:

  * Backup utilities
  * Cleanup scripts
  * Logging and monitoring scripts

### 🔸 Phase 5 – Testing & Validation

* Manual testing of menu options and scripts
* Verified DB operations and script interactions

---

## ⚙️ Usage

Start the project:

```bash
./run.sh
```

Example menu workflow:

```text
Welcome to PROJECT_OST!
1) Module A
2) Module B
3) Cleanup
4) Exit
> 2
Running Task B...
Done.
> 4
Exiting. Goodbye!
```

Manual execution of scripts:

```bash
./scripts/backup.sh
./scripts/cleanup.sh
```

---

## 🧭 Lessons Learned

* Effective teamwork with **Git & GitHub**
* Conflict resolution using Git commands
* Database integration in shell scripts
* Script automation for setup and menu-driven execution
* Task management and clear role assignment
* Importance of descriptive commit messages and PR reviews

---

## 📅 Future Improvements

* Automated testing and validation scripts
* Logging for debugging and tracking user actions
* Version tagging with Git (`git tag`)
* Extend database to MySQL/PostgreSQL
* Web-based interface for better usability
* Expand script functionality and modularity

---

## 🏁 Conclusion

PROJECT_OST is a fully functional collaborative project demonstrating **teamwork, Git-based workflow, database integration, and shell scripting automation**.
Every member contributed meaningfully — from database setup to menu logic, script utilities, and testing — making this project both educational and practical.


