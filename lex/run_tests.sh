#!/bin/bash

# Path to your parser executable
PARSER="./parser"  # Replace with the actual name of your parser executable

# Output log file
LOG_FILE="test_results.log"

# Test cases
declare -a TEST_CASES=(
    "a = 3 + 4;"
    "b = 10 - 5;"
    "c = 6 * 3;"
    "d = 8 / 3;"
    "e = 4 + 3 * 2;"
    "f = 10 / 2 - 3;"
    "g = 3 + 4 + 5;"
    "h = 10 - 2 - 3;"
    "i = 6 * 2 * 3;"
    "j = 12 / 2 / 3;"
    "k = (4 + 3) * 2;"
    "l = (10 - 2) / 3;"
    "m = 3 + 4 * (2 - 1);"
    "n = (6 / 2) + (8 - 3) * 2;"
    "o = 10 / 0;"
    "p = (5 - 5) * 3;"
)

# Start logging
echo "Running tests for the parser" > "$LOG_FILE"
echo "---------------------------------" >> "$LOG_FILE"

# Run each test case
for ((i = 0; i < ${#TEST_CASES[@]}; i++)); do
    TEST="${TEST_CASES[$i]}"
    echo "Test $((i + 1)): $TEST" >> "$LOG_FILE"
    echo "$TEST" | $PARSER >> "$LOG_FILE" 2>&1
    echo "---------------------------------" >> "$LOG_FILE"
done

echo "All tests completed. Results saved in $LOG_FILE."
