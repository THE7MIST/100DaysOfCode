# MCQ Arena - Google Apps Script Integration Guide

## Objective

Integrate the React + Vite based **MCQ Arena** application with **Google Apps Script** and **Google Sheets** to provide:

- User Authentication
- Quiz Result Storage
- Analytics
- Cloud Database without Firebase

---

# Project Architecture

```
React + Vite
       │
       │ HTTP POST
       ▼
Google Apps Script (Code.gs)
       │
       ▼
Google Sheets
 ├── Users
 └── Results
```

---

# Features

- User Login
- Google Sheet Authentication
- Result Storage
- Analytics
- GitHub Pages Compatible
- No Backend Server Required

---

# Google Spreadsheet

Create one spreadsheet containing two sheets.

## Sheet 1

### Users

| Email | PasswordTkn | Name |
|--------|-------------|------|
| student1@gmail.com | pass123 | Student 1 |
| student2@gmail.com | pass456 | Student 2 |

---

## Sheet 2

### Results

| user | subject | score | correct | wrong | date | stage | unattempted | totalQuestions | weakAreas |

---

# Google Apps Script

Open

Extensions → Apps Script

Replace the default code with your `Code.gs`.

Update

```javascript
const SPREADSHEET_ID = "YOUR_SPREADSHEET_ID";
```

Save the project.

---

# Initialize Sheets

Run

```
setupSheets()
```

This automatically creates

- Users
- Results

if they don't already exist.

---

# Deploy Apps Script

Deploy

→ New Deployment

Type

```
Web App
```

Execute As

```
Me
```

Who Has Access

```
Anyone
```

Copy the generated URL.

Example

```
https://script.google.com/macros/s/XXXXXXXXXXXXXXXXXXXXXXXX/exec
```

---

# React Configuration

## Option 1 (Recommended)

Create

```
.env
```

```env
VITE_APPS_SCRIPT_URL=https://script.google.com/macros/s/XXXXXXXXXXXXXXXXXXXXXXXX/exec
```

Restart Vite

```
npm run dev
```

---

## Option 2

Hardcode

```javascript
const API_URL =
"https://script.google.com/macros/s/XXXXXXXXXXXXXXXXXXXXXXXX/exec";
```

inside

```
resultsService.js
```

and

```
authService.js
```

---

# Login Flow

Frontend sends

```json
{
  "action":"login",
  "email":"student@gmail.com",
  "passwordToken":"abc123"
}
```

Apps Script

↓

Reads

```
Users
```

↓

Validates credentials

↓

Returns

```json
{
  "ok":true,
  "user":{
      "email":"student@gmail.com",
      "name":"Student"
  }
}
```

---

# Save Result Flow

Frontend sends

```json
{
    "action":"saveResult",
    "result":{
        "user":"student@gmail.com",
        "subject":"PKI",
        "score":18,
        "correct":18,
        "wrong":2,
        "stage":"Warm Up",
        "weakAreas":"RSA,Certificates"
    }
}
```

Apps Script appends a new row to

```
Results
```

---

# Analytics Flow

Frontend

↓

```json
{
    "action":"getAnalytics",
    "email":"student@gmail.com"
}
```

Apps Script

↓

Reads Results sheet

↓

Returns all attempts

↓

React renders Dashboard

---

# Testing Login

Open

```
https://script.google.com/macros/s/XXXXX/exec?action=login&email=test@gmail.com&passwordToken=test123
```

Expected

```json
{
    "ok":true
}
```

---

# Testing Health

```
?action=health
```

Returns

```json
{
  "ok":true,
  "message":"MCQ Arena API is online."
}
```

---

# Testing SaveResult

Temporary function

```javascript
function testSave() {
  Logger.log(
    saveResult({
      user:"test@gmail.com",
      subject:"PKI",
      score:90,
      correct:18,
      wrong:2,
      stage:"Set 1",
      totalQuestions:20,
      unattempted:0,
      weakAreas:"RSA"
    })
  );
}
```

Run

```
testSave()
```

Verify a new row appears in

```
Results
```

---

# Common Issues

## Login Works but Results Not Saving

Possible reasons

- saveResult() not called
- Old Apps Script deployment
- Incorrect API URL
- Missing rebuild after changing .env

---

## Apps Script Updated but Website Uses Old Version

After every Apps Script update

Deploy

↓

Manage Deployments

↓

Create New Version

↓

Deploy

---

## .env Changes Not Reflected

Remember

```
.env
```

is compiled during

```
npm run build
```

Always rebuild after modifying

```
.env
```

---

## Verify Network Requests

Chrome

F12

↓

Network

↓

Submit Quiz

Look for requests to

```
script.google.com
```

---

# Project Components

## Frontend

- Login Page
- Quiz Engine
- Result Page
- Analytics Dashboard

## Backend

- Google Apps Script

## Database

- Google Sheets

---

# Advantages

- Free Hosting
- No Firebase Required
- Easy Maintenance
- Google Authentication Ready
- Unlimited Custom MCQs
- GitHub Pages Compatible

---

# Recommended Future Improvements

- Password Hashing
- JWT Sessions
- Admin Panel
- User Registration
- Leaderboard
- Performance Graphs
- Export Results as PDF
- Email Notifications
- Detailed Attempt Review
- Question-wise Analytics

---

# Final Architecture

```
Users
   │
   ▼
GitHub Pages
   │
   ▼
React + Vite
   │
   ▼
Google Apps Script
   │
   ▼
Google Sheets
   ├── Users
   └── Results
```

---

# Conclusion

The MCQ Arena platform now supports:

- Secure login using Google Sheets
- Cloud-based result storage
- User analytics
- GitHub Pages deployment
- Google Apps Script backend
- Fully serverless architecture

This setup provides a lightweight, scalable, and cost-effective solution for hosting an online MCQ examination platform.
