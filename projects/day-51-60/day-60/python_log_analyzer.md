Bash Interview Challenge — Python Log Error Analyzer

Write a Bash script that:

Accepts a Python application log file as an argument.
Checks whether the log file exists and is readable.
Counts the total occurrences of:
ERROR
WARNING
CRITICAL
Displays the five most recent error lines.
Returns exit code 1 when at least one CRITICAL error is found.
Handles a missing or invalid file argument.
Example
./python_log_analyzer.sh app.log
Expected output
ERROR: 12
WARNING: 7
CRITICAL: 2

Recent errors:
2026-07-21 10:20:11 ERROR Database connection failed
2026-07-21 10:22:31 CRITICAL Application stopped

Try using:

grep
tail
wc
if
exit

File name: python_log_analyzer.sh

give me code
python_log_analyzer.sh
#!/bin/bash

# Check argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log-file>"
    exit 1
fi

log_file="$1"

# Check file
if [ ! -r "$log_file" ]; then
    echo "Error: '$log_file' does not exist or is not readable."
    exit 1
fi

# Count log levels
error_count=$(grep -c "ERROR" "$log_file")
warning_count=$(grep -c "WARNING" "$log_file")
critical_count=$(grep -c "CRITICAL" "$log_file")

echo "ERROR: $error_count"
echo "WARNING: $warning_count"
echo "CRITICAL: $critical_count"

echo
echo "Recent errors:"

grep -E "ERROR|CRITICAL" "$log_file" | tail -n 5

# Return exit code 1 if CRITICAL errors exist
if [ "$critical_count" -gt 0 ]; then
    exit 1
fi

exit 0

Run it:

chmod +x python_log_analyzer.sh
./python_log_analyzer.sh app.log

Check the exit code:

echo $?
0 means no critical errors.
1 means at least one critical error was found.5
