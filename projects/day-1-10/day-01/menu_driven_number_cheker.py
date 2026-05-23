# ============================================
# Menu Driven Python Program
# ============================================
# This program performs:
# 1. Even or Odd Check
# 2. Prime Number Check
# 3. Armstrong Number Check
# 4. Perfect Number Check
#
# The code is written in simple way
# with easy comments for beginners.
# ============================================

# Infinite loop so menu keeps showing
while True:

    print("==================================")
    print("       MENU DRIVEN PROGRAM        ")
    print("==================================")
    print("1. Check Even or Odd")
    print("2. Check Prime Number")
    print("3. Check Armstrong Number")
    print("4. Check Perfect Number")
    print("5. Exit")
    print("==================================")

    # Take user choice
    choice = int(input("Enter your choice: "))

    # ============================================
    # Option 1
    # Even or Odd Check
    # ============================================
    if choice == 1:

        print("----- Even or Odd Check -----")

        # Take number input
        num = int(input("Enter a number: "))

        # If remainder after division by 2 is 0
        # then number is even
        if num % 2 == 0:
            print(num, "is Even")
        else:
            print(num, "is Odd")

    # ============================================
    # Option 2
    # Prime Number Check
    # ============================================
    elif choice == 2:

        print("----- Prime Number Check -----")

        # Take number input
        num = int(input("Enter a number: "))

        # Prime numbers are greater than 1
        if num <= 1:
            print(num, "is Not Prime")

        else:
            # Count variable stores total factors
            count = 0

            # Loop from 1 to entered number
            for i in range(1, num + 1):

                # Check if i divides number completely
                if num % i == 0:
                    count = count + 1

            # Prime number has exactly 2 factors
            # 1 and itself
            if count == 2:
                print(num, "is Prime")
            else:
                print(num, "is Not Prime")

    # ============================================
    # Option 3
    # Armstrong Number Check
    # ============================================
    elif choice == 3:

        print("----- Armstrong Number Check -----")

        # Take number input
        num = int(input("Enter a number: "))

        # Store original number safely
        original = num

        # Convert number to string
        # to count total digits
        digits = len(str(num))

        # Sum variable stores final result
        sum = 0

        # Loop until number becomes 0
        while num > 0:

            # Get last digit
            digit = num % 10

            # Raise digit to power of total digits
            power = digit ** digits

            # Add result into sum
            sum = sum + power

            # Remove last digit
            num = num // 10

        # Compare final sum with original number
        if sum == original:
            print(original, "is an Armstrong Number")
        else:
            print(original, "is Not an Armstrong Number")

    # ============================================
    # Option 4
    # Perfect Number Check
    # ============================================
    elif choice == 4:

        print("----- Perfect Number Check -----")

        # Take number input
        num = int(input("Enter a number: "))

        # Sum variable stores divisor addition
        sum = 0

        # Loop from 1 to number - 1
        for i in range(1, num):

            # Check if i divides number completely
            if num % i == 0:

                # Add divisor into sum
                sum = sum + i

        # Perfect number condition
        # Sum of divisors equals original number
        if sum == num:
            print(num, "is a Perfect Number")
        else:
            print(num, "is Not a Perfect Number")

    # ============================================
    # Option 5
    # Exit Program
    # ============================================
    elif choice == 5:

        print("Exiting Program...")
        break

    # ============================================
    # Invalid Choice
    # ============================================
    else:

        print("Invalid Choice")

    # Blank line for better readability
    print()
