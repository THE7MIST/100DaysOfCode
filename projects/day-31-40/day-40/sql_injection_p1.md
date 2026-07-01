# SQL Injection (SQLi) Notes

> **Sources**
>
> - PortSwigger SQL Injection Academy
> - PortSwigger SQL Injection Labs
> - Educational video notes

---

# Learning Resources

## Theory

https://portswigger.net/web-security/sql-injection

## Video

https://youtu.be/FnurG_jsvWo

## Practice Labs

https://portswigger.net/web-security/all-labs#sql-injection

---

# What is SQL Injection?

SQL Injection (SQLi) is a **web application vulnerability** that occurs when user input is included directly in an SQL query without proper validation or parameterization.

Instead of treating the input as data, the database interprets it as part of the SQL command.

An attacker may then manipulate the query to:

- Read unauthorized data
- Bypass authentication
- Modify or delete records
- Escalate privileges
- In some environments, compromise the underlying server

---

# Definition

> SQL Injection is a vulnerability that allows an attacker to interfere with the SQL queries an application sends to its database.

---

# How a Web Application Communicates with a Database

```text
User
   │
   ▼
Website
   │
   ▼
SQL Query
   │
   ▼
Database
   │
   ▼
Result
   │
   ▼
Website
   │
   ▼
User
```

Example:

A student enters:

- Roll Number
- Name
- DOB

The application generates an SQL query.

The database returns matching records.

The website displays the result.

SQL Injection occurs when malicious input changes the SQL query.

---

# Database Architecture

```text
Database Server
        │
        ▼
    Database
        │
        ▼
      Tables
        │
        ▼
 Rows and Columns
```

A database server may contain multiple databases.

Each database contains multiple tables.

Each table stores records in rows and columns.

---

# Database Table Structure

Example:

| id | username | password |
|---:|----------|----------|
| 1 | jon | pass123 |
| 2 | admin | p4ssword |
| 3 | martin | secret123 |

## Columns

Columns represent attributes.

Examples:

- id
- username
- password

## Rows

Each row represents one record.

Example:

- Row 1 → Jon
- Row 2 → Admin
- Row 3 → Martin

---

# Login Authentication Process

Example credentials:

```text
Username : martin
Password : secret123
```

Application executes a query similar to:

```sql
SELECT *
FROM users
WHERE username='martin'
AND password='secret123';
```

If both values exist in the same row:

```text
Login Successful
```

Otherwise:

```text
Login Failed
```

---

# What is SQL?

SQL stands for **Structured Query Language**.

SQL is used to:

- Retrieve data
- Insert data
- Update data
- Delete data
- Manage databases

SQL Injection manipulates these SQL statements.

---

# SELECT Statement

General syntax:

```sql
SELECT * FROM users;
```

Meaning:

| Keyword | Description |
|----------|-------------|
| SELECT | Retrieve data |
| * | All columns |
| FROM | Specify table |
| users | Table name |

---

# Selecting Specific Columns

```sql
SELECT username, password
FROM users;
```

Only the specified columns are returned.

---

# LIMIT Clause

Example:

```sql
SELECT * FROM users LIMIT 1;
```

Returns only the first row.

Another example:

```sql
SELECT * FROM users LIMIT 2;
```

Returns the first two rows.

---

# WHERE Clause

Example:

```sql
SELECT *
FROM users
WHERE username='admin';
```

Only matching rows are returned.

---

# Normal Login Query

```sql
SELECT *
FROM users
WHERE username='alice'
AND password='secret123';
```

Both conditions must evaluate to TRUE.

---

# SQL Injection Authentication Bypass (Concept)

If user input is not validated, an attacker may inject SQL syntax.

Example payload:

```text
' OR '1'='1
```

Example query:

```sql
SELECT *
FROM users
WHERE username='' OR '1'='1'
AND password='';
```

Since:

```text
'1'='1'
```

is always TRUE, the query may return one or more rows.

The application may incorrectly treat this as a successful login.

> **Note:** This demonstrates the concept only. Whether authentication is bypassed depends on the application's implementation and database behavior.

---

# Impact of SQL Injection

| Impact | Description | Severity |
|----------|-------------|----------|
| Data Extraction | Read sensitive information | Critical |
| Authentication Bypass | Login without valid credentials | Critical |
| Data Manipulation | Insert, update, or delete data | Critical |
| Remote Code Execution* | Possible in some environments | Critical |
| Privilege Escalation | Gain higher privileges | High |
| Denial of Service | Disrupt database or application | High |

> *Remote Code Execution depends on the database system, configuration, installed features, and server permissions.

---

# CIA Triad Impact

## Confidentiality

Unauthorized access to sensitive data.

## Integrity

Unauthorized modification or deletion of data.

## Availability

Disruption of application or database services.

---

# Detecting SQL Injection

Common manual techniques include:

- Single quote (`'`) testing
- Boolean conditions
- Time-based payloads
- Out-of-band (OAST) payloads
- Error-based testing

Automated detection can also be performed using tools such as Burp Suite Scanner.

---

# Common SQL Injection Locations

SQL Injection can occur in:

- WHERE clauses
- UPDATE statements
- INSERT statements
- SELECT column names
- ORDER BY clauses

---

# Types of SQL Injection

- Authentication Bypass
- Retrieving Hidden Data
- Error-Based SQL Injection
- UNION-Based SQL Injection
- Blind SQL Injection

---

# Retrieving Hidden Data

Original query:

```sql
SELECT *
FROM products
WHERE category='Gifts'
AND released=1;
```

Injected input:

```text
Gifts'--
```

Resulting query:

```sql
SELECT *
FROM products
WHERE category='Gifts'--'
AND released=1;
```

Everything after `--` becomes a comment, removing the `released=1` condition.

---

## Returning All Products

Injected input:

```text
Gifts' OR 1=1--
```

Resulting query:

```sql
SELECT *
FROM products
WHERE category='Gifts'
OR 1=1--'
AND released=1;
```

Since:

```text
1=1
```

is always TRUE, all matching rows may be returned.

> **Warning:** Injecting conditions such as `OR 1=1` into real applications may have unintended consequences, especially if the same input is reused in UPDATE or DELETE statements.

---

# Error-Based SQL Injection

Error messages generated by the database may reveal:

- Database type
- Table names
- Column names
- Query structure

These errors help identify SQL Injection vulnerabilities.

---

# UNION-Based SQL Injection

The `UNION` operator combines results from multiple `SELECT` queries.

Example:

```sql
SELECT a, b FROM table1
UNION
SELECT c, d FROM table2;
```

Requirements:

- Same number of columns
- Compatible data types

---

# Determining the Number of Columns

## Method 1: ORDER BY

```sql
' ORDER BY 1--
' ORDER BY 2--
' ORDER BY 3--
```

Increase the column index until an error occurs.

---

## Method 2: UNION SELECT NULL

```sql
' UNION SELECT NULL--
```

```sql
' UNION SELECT NULL,NULL--
```

```sql
' UNION SELECT NULL,NULL,NULL--
```

Increase the number of `NULL` values until the query succeeds.

`NULL` is used because it is compatible with most SQL data types.

---

# Finding Text-Compatible Columns

Example:

```sql
' UNION SELECT 'a',NULL,NULL--
```

```sql
' UNION SELECT NULL,'a',NULL--
```

```sql
' UNION SELECT NULL,NULL,'a'--
```

If the application displays the injected string, that column accepts text values.

---

# Retrieving Data Using UNION

If two text columns exist:

```sql
' UNION SELECT username,password
FROM users--
```

This retrieves data from another table.

To perform this successfully, the attacker must know (or discover) the table and column names.

---

# Practical Labs

## Lab 1

### Login Bypass

Objective:

Demonstrate how unsanitized login inputs can alter SQL queries and bypass authentication in a deliberately vulnerable application.

Reference:

https://portswigger.net/web-security/sql-injection/lab-login-bypass

---

## Lab 2

### Retrieve Hidden Data

Objective:

Use SQL Injection to access records that should normally remain hidden.

Reference:

https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data

---

## UNION Attack Lab

### Determine Number of Columns

Reference:

https://portswigger.net/web-security/sql-injection/union-attacks/lab-determine-number-of-columns

Technique:

```sql
' UNION SELECT NULL--
```

```sql
' UNION SELECT NULL,NULL--
```

```sql
' UNION SELECT NULL,NULL,NULL--
```

The first successful query reveals the number of columns returned.

---

## UNION Attack Lab

### Find a Column Containing Text

Reference:

https://portswigger.net/web-security/sql-injection/union-attacks/lab-find-column-containing-text

Technique:

```sql
' UNION SELECT 'a',NULL,NULL--
```

```sql
' UNION SELECT NULL,'a',NULL--
```

```sql
' UNION SELECT NULL,NULL,'a'--
```

The column that successfully displays the injected string is suitable for retrieving text data.

---

# Key Takeaways

- SQL Injection occurs when user input is incorporated into SQL queries without proper validation or parameterization.
- It can compromise confidentiality, integrity, and availability.
- Common attack techniques include authentication bypass, hidden data retrieval, error-based SQL Injection, UNION attacks, and blind SQL Injection.
- Defensive measures include parameterized queries (prepared statements), input validation, least-privilege database accounts, and secure error handling.

> These notes summarize the uploaded SQL Injection material. :contentReference[oaicite:0]{index=0}
```
