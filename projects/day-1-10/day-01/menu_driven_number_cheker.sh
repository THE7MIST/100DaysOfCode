#!/bin/bash

# ============================================
# Menu Driven Shell Script
# ============================================
# This script performs:
# 1. Even or Odd Check
# 2. Prime Number Check
# 3. Armstrong Number Check
# 4. Perfect Number Check
# ============================================

# Infinite loop so menu keeps showing
while true
do
    echo "=================================="
    echo "        MENU DRIVEN PROGRAM       "
    echo "=================================="
    echo "1. Check Even or Odd"
    echo "2. Check Prime Number"
    echo "3. Check Armstrong Number"
    echo "4. Check Perfect Number"
    echo "5. Exit"
    echo "=================================="

    # Read user choice
    read -p "Enter your choice: " choice

    # Case statement handles menu options
    case $choice in

        1)
            echo "----- Even or Odd Check -----"

            # Take number input from user
            read -p "Enter a number: " num

            # Modulus operator (%) gives remainder
            # If remainder is 0 after division by 2
            # then number is even
            if [ $((num % 2)) -eq 0 ]
            then
                echo "$num is Even"
            else
                echo "$num is Odd"
            fi
            ;;

        2)
            echo "----- Prime Number Check -----"

            # Take number input
            read -p "Enter a number: " num

            # Prime numbers are greater than 1
            if [ $num -le 1 ]
            then
                echo "$num is Not Prime"
            else

                # Variable to count factors
                count=0

                # Loop from 1 to entered number
                for (( i=1; i<=num; i++ ))
                do
                    # If number divides completely
                    # then it is a factor
                    if [ $((num % i)) -eq 0 ]
                    then
                        count=$((count + 1))
                    fi
                done

                # Prime number has exactly 2 factors
                # 1 and itself
                if [ $count -eq 2 ]
                then
                    echo "$num is Prime"
                else
                    echo "$num is Not Prime"
                fi
            fi
            ;;

        3)
            echo "----- Armstrong Number Check -----"

            # Take number input
            read -p "Enter a number: " num

            # Store original number safely
            original=$num

            # Variable to store final sum
            sum=0

            # Count number of digits
            digits=${#num}

            # Loop until number becomes 0
            while [ $num -gt 0 ]
            do
                # Get last digit
                digit=$((num % 10))

                # Raise digit to power of total digits
                power=$((digit ** digits))

                # Add result into sum
                sum=$((sum + power))

                # Remove last digit from number
                num=$((num / 10))
            done

            # Compare calculated sum with original number
            if [ $sum -eq $original ]
            then
                echo "$original is an Armstrong Number"
            else
                echo "$original is Not an Armstrong Number"
            fi
            ;;

        4)
            echo "----- Perfect Number Check -----"

            # Take number input
            read -p "Enter a number: " num

            # Sum variable stores factor addition
            sum=0

            # Find proper divisors
            # Proper divisors are numbers less than num
            for (( i=1; i<num; i++ ))
            do
                # Check if i divides num completely
                if [ $((num % i)) -eq 0 ]
                then
                    # Add divisor into sum
                    sum=$((sum + i))
                fi
            done

            # Perfect number condition
            # Sum of divisors equals original number
            if [ $sum -eq $num ]
            then
                echo "$num is a Perfect Number"
            else
                echo "$num is Not a Perfect Number"
            fi
            ;;

        5)
            echo "Exiting Program..."
            break
            ;;

        *)
            echo "Invalid Choice"
            ;;
    esac

    # Blank line for better readability
    echo ""

done
