# SkillMatch – A Web-Based Freelancer Marketplace Platform

> **Academic College Mini-Project / B.Tech Capstone**  
> Architecture: **JSP • Java Servlets • JDBC • MySQL • Apache Tomcat • Maven**

---

## 1. Project Overview & Workflow

**SkillMatch** is a full-featured, two-sided marketplace web application connecting clients who have software and design projects with skilled freelancers looking for work opportunities.

### End-to-End Workflow:
1. **Client Registration / Login**: Client signs in and accesses the Client Dashboard.
2. **Project Creation**: Client publishes a project with title, description, budget, and deadline.
3. **Freelancer Registration / Login**: Freelancer registers, customizes their profile (with bio, portfolio URL, areas of expertise, past project highlights), and assigns technical skill badges.
4. **Browse & Apply**: Freelancer browses open projects, reviews requirements, and submits a proposal along with their proposed budget.
5. **Application Management**: Client reviews submitted proposals, inspects the freelancer's profile and skills, and either **Accepts** or **Rejects** the bid.
6. **Automatic State Transition**: When a client accepts an application:
   - Chosen application status becomes `ACCEPTED`.
   - All other applications for the same project transition to `REJECTED`.
   - Project status automatically moves from `OPEN` to `IN_PROGRESS`.
7. **In-App Messaging / Collaboration**: Once accepted, client and freelancer unlock the **Project Chat** to exchange messages, discuss project deliverables, and track progress.
8. **Project Completion**: Client marks project as `COMPLETED`.

---

## 2. Technology Stack

- **Frontend**: HTML5, Modern CSS3 (responsive grid, badges, stat cards), JSP (Jakarta Server Pages), Vanilla JavaScript
- **Backend**: Java 17, Java Servlets (`jakarta.servlet.*`)
- **Database**: MySQL 8.0+
- **Connectivity**: JDBC (`PreparedStatement`, Transaction Management, Connection Pooling utility)
- **Web Server**: Apache Tomcat 10.x (or Tomcat 9 with javax packaging)
- **Build & Dependency Management**: Apache Maven 3.8+
- **Architecture**: MVC (Model - View - Controller) + DAO Pattern

---

## 3. Database Architecture (`skillmatch_db`)

The database consists of 7 normalized relational tables:

1. **`users`**: User authentication and role management (`CLIENT`, `FREELANCER`), hashed passwords.
2. **`freelancer_profiles`**: Freelancer bio, experience level, phone, location, portfolio URL, expertise, and past projects.
3. **`skills`**: Master lookup table of available technology skills.
4. **`freelancer_skills`**: Many-to-Many junction table linking freelancers to their technical skills.
5. **`projects`**: Project details, client foreign key, budget, deadline, and status (`OPEN`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`).
6. **`applications`**: Freelancer proposals, proposed budget, status (`PENDING`, `ACCEPTED`, `REJECTED`), with a `UNIQUE(project_id, freelancer_id)` constraint.
7. **`messages`**: In-app project chat messages between the client and the accepted freelancer (`sender_id`, `receiver_id`, `message_text`, `sent_at`, `is_read`).

---

## 4. Default Test Credentials

Pre-seeded in `skillmatch_db.sql`:

| Role | Name | Email | Password |
|---|---|---|---|
| **Client** | TechCorp Solutions | `client@skillmatch.com` | `client123` |
| **Client** | Apex Retailers | `apex@client.com` | `client123` |
| **Freelancer** | Alex Johnson | `freelancer@skillmatch.com` | `freelancer123` |
| **Freelancer** | Sarah Miller | `sarah@freelancer.com` | `freelancer123` |
| **Freelancer** | David Chen | `david@freelancer.com` | `freelancer123` |

*All passwords in the database are hashed using SHA-256.*  
*Note: the seed hashes were corrected so these logins work after running `skillmatch_db.sql`.*

---

## 5. Running the Project

### Option A – Docker (easiest, nothing else to install except Docker Desktop)
```bash
docker compose up --build
```
Open **http://localhost:8080/skillmatch**. MySQL is created and seeded automatically.
(Stop with `Ctrl+C`; `docker compose down -v` also wipes the database.)

### Option B – VS Code + local MySQL
**Prerequisites:** JDK 17+, Maven 3.8+, MySQL 8 running on port 3306.

1. **Create the database** (this also re-seeds it any time you want a fresh demo):
   ```bash
   mysql -u root -p < skillmatch_db.sql
   ```
2. **Set your MySQL password** in `src/main/resources/db.properties` (`db.password=...`).
   Environment variables `DB_URL`, `DB_USER`, `DB_PASSWORD` override it if set.
3. **Open the folder in VS Code**, accept the "install recommended extensions" prompt
   (Extension Pack for Java, Maven for Java).
4. **Run:** `Terminal -> Run Build Task` (Ctrl+Shift+B) or in the terminal:
   ```bash
   mvn clean package cargo:run
   ```
   The first run downloads Tomcat 10.1 automatically. Then open **http://localhost:8080/skillmatch**.
   Stop with `Ctrl+C`.

### Option C – Existing Tomcat 10.1+
```bash
mvn clean package
cp target/skillmatch.war $CATALINA_HOME/webapps/
```
> Tomcat **9** will not work (this project uses the `jakarta.*` namespace, which needs Tomcat 10+).

### Troubleshooting
| Problem | Fix |
|---|---|
| "Database connection error" on login | MySQL not running, or wrong password in `db.properties` |
| Login says invalid credentials | Re-run `skillmatch_db.sql` (seed passwords were corrected) |
| Port 8080 busy | Stop the other app, or change `cargo.servlet.port` in `pom.xml` |
| `ClassNotFoundException: jakarta...` | You are on Tomcat 9 - use Tomcat 10.1 |

---

## Demo Script for Presentation (~5 min)
1. Log in as **client@skillmatch.com** -> dashboard shows projects & stats.
2. **Create a project** (title, description, budget, deadline).
3. Log out, log in as **freelancer@skillmatch.com** -> **Browse Projects**, open the new project, **submit a proposal**.
4. Log back in as the client -> **Applications** -> **Accept** (project becomes `IN_PROGRESS`, other bids auto-rejected).
5. Open **Messages** on that project to show the client-freelancer chat; mark project **COMPLETED**.
6. Mention security: hashed passwords, `PreparedStatement`, role checks, XSS output escaping, transactional accept.

---

## 6. Directory Structure
```
skillmatch/
├── pom.xml                                   # Maven build configuration & dependencies
├── skillmatch_db.sql                         # MySQL schema creation & seed data
├── README.md                                 # Complete documentation & viva guide
├── src/
│   └── main/
│       ├── java/
│       │   └── com/skillmatch/
│       │       ├── controller/               # Java Servlets
│       │       │   ├── LoginServlet.java
│       │       │   ├── RegisterServlet.java
│       │       │   ├── LogoutServlet.java
│       │       │   ├── ClientDashboardServlet.java
│       │       │   ├── CreateProjectServlet.java
│       │       │   ├── EditProjectServlet.java
│       │       │   ├── DeleteProjectServlet.java
│       │       │   ├── FreelancerDashboardServlet.java
│       │       │   ├── FreelancerProfileServlet.java  # + FreelancerApplicationsServlet, ClientApplicationsServlet,
│       │       │   │                                 #   ClientProjectsServlet, ProjectDetailsServlet
│       │       │   ├── SkillServlet.java
│       │       │   ├── ProjectListServlet.java
│       │       │   ├── ApplyProjectServlet.java
│       │       │   ├── UpdateApplicationStatusServlet.java
│       │       │   ├── UpdateProjectStatusServlet.java
│       │       │   └── MessageServlet.java   # In-app chat controller
│       │       ├── dao/                      # Data Access Objects (JDBC)
│       │       │   ├── UserDAO.java
│       │       │   ├── FreelancerProfileDAO.java
│       │       │   ├── SkillDAO.java
│       │       │   ├── ProjectDAO.java
│       │       │   ├── ApplicationDAO.java
│       │       │   └── MessageDAO.java
│       │       ├── model/                    # JavaBeans / Entity Models
│       │       │   ├── User.java
│       │       │   ├── FreelancerProfile.java
│       │       │   ├── Skill.java
│       │       │   ├── Project.java
│       │       │   ├── Application.java
│       │       │   └── Message.java
│       │       ├── filter/
│       │       │   └── DirectJspAccessFilter.java  # blocks direct /*.jsp access
│       │       └── util/
│       │           ├── HtmlUtil.java         # XSS output escaping
│       │           ├── DBConnection.java     # JDBC connection manager
│       │           └── PasswordUtil.java     # SHA-256 security hashing
│       └── webapp/                           # Presentation Layer (JSP / Web Assets)
│           ├── index.jsp                     # Homepage with brand identity
│           ├── login.jsp                     # User authentication
│           ├── register.jsp                  # Client / Freelancer signup
│           ├── messages.jsp                  # In-app chat interface
│           ├── css/
│           │   └── style.css                 # Responsive stylesheet
│           ├── js/
│           │   └── main.js                   # Client-side validation & utilities
│           ├── client/
│           │   ├── dashboard.jsp             # Client metrics & project table
│           │   ├── create-project.jsp        # Project creation form
│           │   ├── edit-project.jsp          # Edit project details
│           │   └── manage-applications.jsp   # Proposal review (accept/reject)
│           ├── freelancer/
│           │   ├── dashboard.jsp             # Freelancer metrics & overview
│           │   ├── browse-projects.jsp       # Open project catalogue
│           │   ├── project-details.jsp       # Proposal submission form
│           │   ├── my-applications.jsp       # Submitted bids & tracking
│           │   ├── profile.jsp               # Portfolio & past highlights
│           │   └── skills.jsp                # Technical skill manager
│           └── WEB-INF/
│               └── web.xml                   # Deployment descriptor
```

---

## 7. Viva Questions & Project Defense Guide

1. **Why use MVC Architecture?**  
   *Separation of Concerns*: Model handles data logic and DB operations (`DAO`), View renders the presentation layer (`JSP`), and Controller processes HTTP requests and routes responses (`Servlets`).

2. **How does Accept Application guarantee atomicity?**  
   In `ApplicationDAO.java`, we invoke `conn.setAutoCommit(false);`. Inside the transaction, we update the chosen application to `ACCEPTED`, mark other bids as `REJECTED`, and update project status to `IN_PROGRESS`. If any statement fails, `conn.rollback()` restores previous database state.

3. **How is SQL Injection prevented?**  
   All queries strictly use JDBC `PreparedStatement` with parameterized placeholders (`?`). No string concatenation is used for dynamic queries.

4. **How are passwords stored?**  
   Passwords are never stored in plain text. `PasswordUtil.java` hashes passwords using standard SHA-256 before storing them in MySQL.
