# TESTING_PLAN.md

### Goal
Check that all main features work correctly, and errors are handled properly.

---

## Test Cases

### 1. User Registration
| Test | Steps | Expected Result | Status |
|------|-------|----------------|--------|
| Register with valid info | Enter username, password, email, phone | Account created | Pending |
| Register with existing username | Enter a username that’s already in use | Error: "Username already exists" | Pending |
| Register with wrong email | Enter email in wrong format | Error: "Invalid email" | Pending |
| Weak password | Enter password less than 6 chars | Error: "Password too short" | Pending |
| Missing fields | Leave any required field blank | Error: "Please fill all fields" | Pending |

### 2. User Login
| Test | Steps | Expected Result | Status |
|------|-------|----------------|--------|
| Login with correct info | Enter valid username and password | Login successful | Pending |
| Wrong password | Enter correct username, wrong password | Error: "Incorrect password" | Pending |
| Non-existent user | Enter username not in system | Error: "User not found" | Pending |

### 3. Ticket Booking
| Test | Steps | Expected Result | Status |
|------|-------|----------------|--------|
| Book ticket normally | Select train, date, seats, confirm | Booking succeeds | Pending |
| Book already taken seats | Select seats already booked | Error: "Seats unavailable" | Pending |
| Invalid date | Select a past date | Error: "Invalid date" | Pending |

### 4. View Tickets
| Test | Steps | Expected Result | Status |
|------|-------|----------------|--------|
| View all tickets | Go to "My Tickets" | Show all booked tickets | Pending |
| No bookings yet | Go to "My Tickets" | Show message: "No tickets booked" | Pending |

---

## Notes
- Make sure the database is set up before testing.
- Scripts should handle invalid inputs without crashing. 
- Record any bugs or unexpected behavior.
