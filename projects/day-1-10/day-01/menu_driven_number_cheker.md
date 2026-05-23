# Number Checking Programs Using Bash and Python

## Introduction

This document explains four important number concepts implemented using both Bash scripting and Python programming.

The programs included are:

1. Even or Odd Number Check
2. Prime Number Check
3. Armstrong Number Check
4. Perfect Number Check

For each concept, this document explains:
- Definition
- Real meaning
- Example
- Logic used
- Bash implementation logic
- Python implementation logic

The purpose of these programs is to understand:
- Conditional statements
- Loops
- Mathematical logic
- Basic problem solving
- Number operations

---

# 1. Even or Odd Number Check

## Definition

An even number is a number completely divisible by 2.

An odd number is a number that leaves remainder 1 when divided by 2.

---

## Examples

| Number | Result |
|---|---|
| 4 | Even |
| 10 | Even |
| 7 | Odd |
| 15 | Odd |

---

## Core Logic

The modulus operator `%` is used.

If:

```text
number % 2 == 0
```

then the number is even.

Otherwise, it is odd.

---

# Bash Logic

## Code Logic

```bash
if [ $((num % 2)) -eq 0 ]
```

### Explanation

| Part | Meaning |
|---|---|
| num % 2 | Finds remainder after division by 2 |
| -eq 0 | Checks if remainder equals 0 |

If condition becomes true:
- Number is Even

Else:
- Number is Odd

---

# Python Logic

## Code Logic

```python
if num % 2 == 0:
```

### Explanation

| Part | Meaning |
|---|---|
| % | Modulus operator |
| num % 2 | Finds remainder |
| == 0 | Checks if remainder is zero |

---

# 2. Prime Number Check

## Definition

A prime number is a number greater than 1 that has exactly two factors:
- 1
- Itself

---

## Examples

| Number | Result |
|---|---|
| 2 | Prime |
| 5 | Prime |
| 7 | Prime |
| 9 | Not Prime |
| 12 | Not Prime |

---

## Core Logic

To check whether a number is prime:
- Count how many numbers divide it completely
- If factor count equals 2, it is prime

---

# Bash Logic

## Code Logic

```bash
for (( i=1; i<=num; i++ ))
```

Loop checks every number from 1 to entered number.

---

## Factor Check

```bash
if [ $((num % i)) -eq 0 ]
```

If remainder becomes 0:
- `i` is a factor
- Increase factor count

---

## Final Prime Condition

```bash
if [ $count -eq 2 ]
```

### Explanation

Prime numbers only have:
- 1
- The number itself

So total factors must be exactly 2.

---

# Python Logic

## Loop Logic

```python
for i in range(1, num + 1):
```

Checks all possible factors.

---

## Divisibility Check

```python
if num % i == 0:
```

If divisible:
- Increase factor count

---

## Final Condition

```python
if count == 2:
```

If total factors equal 2:
- Number is Prime

Otherwise:
- Number is Not Prime

---

# 3. Armstrong Number Check

## Definition

An Armstrong number is a number where:

Sum of each digit raised to the power of total digits equals the original number.

---

## Example

### Example: 153

Number of digits = 3

Calculation:

```text
1³ + 5³ + 3³
= 1 + 125 + 27
= 153
```

So:
- 153 is an Armstrong Number

---

## More Examples

| Number | Result |
|---|---|
| 153 | Armstrong |
| 370 | Armstrong |
| 371 | Armstrong |
| 123 | Not Armstrong |

---

## Core Logic

Steps:
1. Count digits
2. Extract each digit
3. Raise digit to power of total digits
4. Add all results
5. Compare with original number

---

# Bash Logic

## Digit Count

```bash
digits=${#num}
```

Counts total digits in number.

---

## Extract Last Digit

```bash
digit=$((num % 10))
```

Gets last digit from number.

---

## Raise Power

```bash
power=$((digit ** digits))
```

Raises digit to power of total digits.

---

## Remove Last Digit

```bash
num=$((num / 10))
```

Removes last digit from number.

---

## Final Comparison

```bash
if [ $sum -eq $original ]
```

If calculated sum equals original number:
- Armstrong Number

---

# Python Logic

## Count Digits

```python
digits = len(str(num))
```

Converts number into string and counts digits.

---

## Extract Digit

```python
digit = num % 10
```

Gets last digit.

---

## Power Calculation

```python
power = digit ** digits
```

Raises digit to required power.

---

## Remove Last Digit

```python
num = num // 10
```

Integer division removes last digit.

---

## Final Condition

```python
if sum == original:
```

If final sum equals original number:
- Armstrong Number

---

# 4. Perfect Number Check

## Definition

A perfect number is a number where:

Sum of all proper divisors equals the original number.

Proper divisors are numbers smaller than the number that divide it completely.

---

## Example

### Example: 6

Factors of 6:
- 1
- 2
- 3

Sum:

```text
1 + 2 + 3 = 6
```

So:
- 6 is a Perfect Number

---

## More Examples

| Number | Result |
|---|---|
| 6 | Perfect |
| 28 | Perfect |
| 12 | Not Perfect |
| 15 | Not Perfect |

---

## Core Logic

Steps:
1. Find all divisors smaller than number
2. Add them
3. Compare total with original number

---

# Bash Logic

## Loop Through Divisors

```bash
for (( i=1; i<num; i++ ))
```

Checks all numbers smaller than entered number.

---

## Divisibility Check

```bash
if [ $((num % i)) -eq 0 ]
```

If divisible:
- Add divisor to sum

---

## Final Condition

```bash
if [ $sum -eq $num ]
```

If divisor sum equals original number:
- Perfect Number

---

# Python Logic

## Loop Logic

```python
for i in range(1, num):
```

Checks numbers smaller than original number.

---

## Factor Check

```python
if num % i == 0:
```

If divisible:
- Add divisor into sum

---

## Final Condition

```python
if sum == num:
```

If divisor sum equals original number:
- Perfect Number

---

# Concepts Used in Both Programs

| Concept | Purpose |
|---|---|
| if statement | Decision making |
| loop | Repeating operations |
| modulus operator `%` | Finding remainder |
| variables | Storing data |
| arithmetic operators | Mathematical calculations |
| comparison operators | Condition checking |

---

# Difference Between Bash and Python

| Bash | Python |
|---|---|
| Shell scripting language | General purpose programming language |
| Mostly used in Linux automation | Used in multiple domains |
| Syntax is command-oriented | Syntax is cleaner and readable |
| Faster for system tasks | Better for large applications |

---

# Learning Outcomes

After completing these programs, the following concepts become clear:

- Number based logic building
- Conditional programming
- Loop implementation
- Mathematical problem solving
- Basic scripting
- Beginner level algorithm design
- Difference between Bash and Python logic

---

# Conclusion

These programs are important beginner-level programming exercises that improve logical thinking and problem-solving ability.

Even though the programs are simple, they introduce important concepts used in real software development:
- condition handling
- iteration
- mathematical computation
- structured programming

Implementing the same logic in both Bash and Python also helps understand how different programming languages solve the same problem using different syntax and approaches.
