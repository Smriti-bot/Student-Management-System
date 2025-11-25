# 🎓 Student Management System  
### *A Complete Java Web Application using JSP, Servlets, JDBC & MySQL*

The **Student Management System** is a full-featured web-based application built using **Java**, **JSP**, **Servlets**, **JDBC**, **MySQL**, and **Maven**.  
It allows administrators to manage student records through an easy-to-use interface, demonstrating **Core Java**, **OOP**, **MVC**, and **Database connectivity**.

---

## 🚀 Features

### 🔐 Authentication
- Secure login system  
- Session-based authentication  
- Logout functionality  

### 👨‍🎓 Student Management (CRUD)
- ✔ Add Student  
- ✔ Edit Student  
- ✔ Delete Student (with confirmation modal)  
- ✔ Search Students (name, course, email)  
- ✔ Serial numbers in listing  
- ✔ Total student count  

### 📄 Export / Report  
- ✔ Download CSV  
- ✔ Download PDF (iText)  

### 🎨 UI / UX Enhancements
- Login page centered with background image  
- Light, modern student dashboard UI  
- Zebra-striped table rows  
- Validation for forms  
- Dropdowns for Course & Grade  
- Toast notifications  
- Delete confirmation modal  
- Responsive design  

### 🗄 Database Integration
- MySQL database with JDBC  
- Auto-increment ID  
- Proper DAO layer  
- Stable ordering of records  
- Fully working DB operations  

---

## 🏗 Project Structure
C:.
│   .gitignore
│   pom.xml
│   README.md
│
├───.idea
│       .gitignore
│       compiler.xml
│       encodings.xml
│       jarRepositories.xml
│       misc.xml
│       vcs.xml
│       workspace.xml
│
├───.mvn
├───.smarttomcat
│   └───StudentManagementSystem
│       └───conf
│           │   catalina.policy
│           │   catalina.properties
│           │   context.xml
│           │   jaspic-providers.xml
│           │   jaspic-providers.xsd
│           │   logging.properties
│           │   server.xml
│           │   tomcat-users.xml
│           │   tomcat-users.xsd
│           │   web.xml
│           │
│           └───Catalina
│               └───localhost
├───lib
│       students (1).csv
│       students.csv
│       students.pdf
│       web-app_3_1.xsd
│
├───src
│   └───main
│       ├───java
│       │   └───com
│       │       └───yourorg
│       │           └───sms
│       │               │   JdbcTest.java
│       │               │
│       │               ├───dao
│       │               │       StudentDAO.java
│       │               │
│       │               ├───filter
│       │               │       AuthFilter.java
│       │               │
│       │               ├───listener
│       │               │       AppStartupListener.java
│       │               │
│       │               ├───model
│       │               │       Student.java
│       │               │
│       │               ├───servlet
│       │               │       LoginServlet.java
│       │               │       LogoutServlet.java
│       │               │       ReportServlet.java
│       │               │       StudentServlet.java
│       │               │
│       │               └───util
│       │                       DataSourceProvider.java
│       │                       DBUtil.java
│       │
│       ├───resources
│       └───webapp
│           │   index.jsp
│           │
│           ├───assets
│           │   └───img
│           │           bg.png
│           │           study.webp
│           │
│           ├───META-INF
│           │   └───assets
│           │       ├───css
│           │       │       style.css
│           │       │
│           │       └───js
│           │               scripts.js
│           │
│           └───WEB-INF
│                   login.jsp
│                   student-form.jsp
│                   student-list.jsp
│
└───target
    ├───classes
    │   └───com
    │       └───yourorg
    │           └───sms
    │               │   JdbcTest.class
    │               │
    │               ├───dao
    │               │       StudentDAO.class
    │               │
    │               ├───filter
    │               │       AuthFilter.class
    │               │
    │               ├───listener
    │               │       AppStartupListener.class
    │               │
    │               ├───model
    │               │       Student.class
    │               │
    │               ├───servlet
    │               │       LoginServlet.class
    │               │       LogoutServlet.class
    │               │       ReportServlet.class
    │               │       StudentServlet.class
    │               │
    │               └───util
    │                       DataSourceProvider.class
    │                       DBUtil.class
    │
    └───generated-sources
        └───annotations

        ## 🛢 MySQL Database Setup

### 1️⃣ Create the database

-- db/schema.sql
CREATE DATABASE IF NOT EXISTS sms_db;
USE sms_db;

CREATE TABLE IF NOT EXISTS students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  course VARCHAR(100),
  grade VARCHAR(5),
  enrollment_date DATE
);

-- sample data
INSERT INTO students (first_name,last_name,email,course,grade,enrollment_date)
VALUES
  ('Aman','Verma','aman.v@example.com','Computer Science','A','2024-08-01'),
  ('Sana','Gupta','sana.g@example.com','Mechanical','B','2023-07-15');
USE sms_db;
SELECT COUNT(*) FROM students;
SELECT * FROM students LIMIT 10;

▶ Running the Project (IntelliJ IDEA + Tomcat)
Step 1 — Open Project

File → Open → Select project folder

Step 2 — Build Project

Build → Rebuild Project

Step 3 — Configure Tomcat

Run → Edit Configurations

Add New Configuration → Tomcat Local

Add Artifact → WAR exploded

Apply → Run

Step 4 — Open Application
http://localhost:8080/student-management-system/login

📦 Build WAR (Optional)

Build → Build Artifacts

Select student-management-system:war

WAR file generated in:

out/artifacts/student-management-system_war/

🛠 Technologies Used

Java 17

JSP / Servlets

JDBC

MySQL

Maven

iText (PDF generation)

HTML / CSS / JavaScript

Apache Tomcat
🎯 Learning Outcomes

Through this project, the following concepts are demonstrated:

OOP (Classes, Methods, Encapsulation, Constructors)

Servlet lifecycle (doGet, doPost, init)

JSP with JSTL

MVC architecture

MySQL + JDBC integration

Making a production-ready Java web application

📝 Conclusion

The Student Management System is a complete, functional Java web application suitable for college submission, portfolio, and real-world learning.
It implements essential backend concepts along with polished UI and reporting features.
