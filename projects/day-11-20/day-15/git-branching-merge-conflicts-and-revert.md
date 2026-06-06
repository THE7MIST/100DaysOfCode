# Git Lab 4 and Git Lab 5

## Git Revert, Branching, Merge Conflict Resolution, and History Management

---

# Introduction

This document covers practical Git operations including:

* Git repository initialization
* Branch creation and management
* Commit history tracking
* Merge conflict generation
* Manual conflict resolution
* Git revert operations
* Branch history analysis
* Merge history visualization

These labs provide hands-on experience with real-world version control workflows used in software development teams.

---

# Git Lab 5

# Git Branching and Merge Conflict Resolution

## Question

Create a Git repository named `Lab_Q5` and create three branches named `main`, `dev1`, and `dev2`.

Create a text file named `Project_<PRN>.txt` containing 10 lines of content and commit it to the `main` branch.

Modify the same line differently in both `dev1` and `dev2` branches and commit the changes.

Merge `dev2` into `dev1`, resolve the merge conflict manually, and complete the merge.

Then modify the same line differently in both `main` and `dev1`, create another conflict, resolve it, and verify the final file.

Finally display branch history and merge history.

---

## Step 1: Create Repository

### Command

```bash
mkdir Lab_Q5
cd Lab_Q5
git init
```

### Explanation

| Command      | Purpose                   |
| ------------ | ------------------------- |
| mkdir Lab_Q5 | Create project directory  |
| cd Lab_Q5    | Enter project directory   |
| git init     | Initialize Git repository |

---

## Step 2: Create Main Branch

### Command

```bash
git checkout -b main
```

### Explanation

| Part     | Meaning       |
| -------- | ------------- |
| checkout | Switch branch |
| -b       | Create branch |
| main     | Branch name   |

---

## Step 3: Create Project File and Initial Commit

### Command

```bash
vim Project_<PRN>.txt

git add .

git commit -m "Initial project commit"
```

### Explanation

| Command    | Purpose           |
| ---------- | ----------------- |
| vim        | Edit file         |
| git add .  | Stage all changes |
| git commit | Create snapshot   |
| -m         | Commit message    |

---

## Step 4: Create Development Branches

### Command

```bash
git checkout -b dev1

git checkout main

git checkout -b dev2
```

### Purpose

Creates two independent development branches.

---

## Step 5: Modify File in dev1

### Command

```bash
git checkout dev1

vim Project_<PRN>.txt

git add .

git commit -m "Modified content in dev1"
```

### Purpose

Creates dev1-specific modifications.

---

## Step 6: Modify Same Line in dev2

### Command

```bash
git checkout dev2

vim Project_<PRN>.txt

git add .

git commit -m "Modified content in dev2"
```

### Purpose

Creates a merge conflict scenario.

---

## Step 7: Merge dev2 into dev1

### Command

```bash
git checkout dev1

git merge dev2
```

### Result

Git detects a merge conflict because both branches modified the same line differently.

---

## Step 8: Resolve First Merge Conflict

### Command

```bash
vim Project_<PRN>.txt

git add .

git commit -m "Resolved merge conflict between dev1 and dev2"
```

### Purpose

Remove conflict markers and keep desired content.

---

## Step 9: Verify Merged File

### Command

```bash
cat Project_<PRN>.txt
```

### Purpose

Verify merged content.

---

## Step 10: Modify File in Main Branch

### Command

```bash
git checkout main

vim Project_<PRN>.txt

git add .

git commit -m "Updated content in main"
```

---

## Step 11: Modify Same Line in dev1

### Command

```bash
git checkout dev1

vim Project_<PRN>.txt

git add .

git commit -m "Updated content in dev1"
```

---

## Step 12: Merge dev1 into Main

### Command

```bash
git checkout main

git merge dev1
```

### Result

Second merge conflict occurs.

---

## Step 13: Resolve Second Merge Conflict

### Command

```bash
vim Project_<PRN>.txt

git add .

git commit -m "Resolved merge conflict between main and dev1"
```

### Purpose

Finalize integration of all changes.

---

## Step 14: Verify Final File

### Command

```bash
cat Project_<PRN>.txt
```

### Purpose

Confirm final integrated content.

---

## Step 15: Display Branches

### Command

```bash
git branch
```

### Purpose

Display available branches.

---

## Step 16: Display Merge History

### Command

```bash
git log --oneline --graph --all
```

### Explanation

| Option    | Purpose             |
| --------- | ------------------- |
| --oneline | Compact history     |
| --graph   | Visual branch graph |
| --all     | Show all branches   |

---

## Concepts Learned

* Branching
* Parallel development
* Merge conflicts
* Conflict resolution
* Branch integration
* Commit graph analysis

---

# Git Lab 4

# Git Revert

## Question

Create a repository named `Lab_Q4` and a branch named `main`.

Create a file named `Exam_details_<PRN>.txt`.

Make three commits with incremental modifications.

Display commit history.

Revert the last two commits while preserving history.

Verify that the file matches the first commit.

Display complete history and explain revert behavior.

---

## Step 1: Create Repository

### Command

```bash
mkdir Lab_Q4

cd Lab_Q4

git init
```

---

## Step 2: Create Main Branch

### Command

```bash
git checkout -b main
```

---

## Step 3: First Commit

### File Content

```text
PRN: <PRN_NUMBER>
This line added in first commit
```

### Command

```bash
vim Exam_details_<PRN>.txt

git add .

git commit -m "first commit"
```

---

## Step 4: Second Commit

### Updated Content

```text
PRN: <PRN_NUMBER>
This line added in first commit
Name: <FULL_NAME>
```

### Command

```bash
vim Exam_details_<PRN>.txt

git add .

git commit -m "second commit"
```

---

## Step 5: Third Commit

### Updated Content

```text
PRN: <PRN_NUMBER>
This line added in first commit
Name: <FULL_NAME>
Welcome to Ditiss
Date: <CURRENT_DATE>
```

### Command

```bash
vim Exam_details_<PRN>.txt

git add .

git commit -m "third commit"
```

---

## Step 6: Display Commit History

### Command

```bash
git log --oneline
```

### Purpose

View commit sequence.

---

## Step 7: Revert Third Commit

### Command

```bash
git revert HEAD
```

### Notes

If editor opens:

```bash
:wq
```

Save and exit.

---

## Step 8: Revert Second Commit

### Command

```bash
git revert HEAD~2
```

### Purpose

Return repository state to first commit while preserving history.

---

## Step 9: Verify File Content

### Command

```bash
cat Exam_details_<PRN>.txt
```

### Expected Output

```text
PRN: <PRN_NUMBER>
This line added in first commit
```

---

## Step 10: Display Complete History

### Command

```bash
git log

git log --oneline
```

### Purpose

View original commits and revert commits.

---

# Important Revert Concept

## Incorrect Approach

```bash
git revert <first_commit_id>
```

This does not restore the repository to the first commit.

Instead it reverses changes introduced by the first commit itself.

---

## Correct Approach

If:

```text
Commit 1 → first.txt
Commit 2 → second.txt
Commit 3 → third.txt
```

Current repository contains:

```text
first.txt
second.txt
third.txt
```

Run:

```bash
git revert <third_commit_id>

git revert <second_commit_id>
```

Result:

```text
first.txt
```

Repository history remains intact.

---

# Difference Between Revert and Reset

| Git Revert                   | Git Reset                         |
| ---------------------------- | --------------------------------- |
| Preserves history            | Rewrites history                  |
| Creates new commit           | Moves branch pointer              |
| Safe for shared repositories | Dangerous for shared repositories |
| Recommended for teams        | Mostly local use                  |

---

# Commands Summary

## Git Branching and Merge

```bash
git checkout -b main

git checkout -b dev1

git checkout -b dev2

git merge dev2

git merge dev1

git branch

git log --oneline --graph --all
```

---

## Git Revert

```bash
git log --oneline

git revert HEAD

git revert HEAD~2

git log

git log --oneline
```

---

# Conclusion

These labs demonstrate practical Git workflows used in professional software development environments.

Key topics covered include:

* Repository initialization
* Branch management
* Commit tracking
* Merge conflict generation
* Manual conflict resolution
* Non-destructive rollback using Git Revert
* Branch history visualization
* Collaborative development workflows

Understanding these concepts is essential for version control, DevOps practices, CI/CD pipelines, and collaborative software development.
