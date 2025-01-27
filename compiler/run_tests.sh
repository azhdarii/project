#!/bin/bash

# Path to your parser executable
PARSER="./compiler"  # Replace with the actual name of your parser executable

# Output log file
LOG_FILE="test_results.log"

# Test cases
declare -a TEST_CASES=(
   "a = 30+21/6*14;"
   "b = 20*(24/6)+45 -60;"
   "c = 23* 24/(5 +45)-16;"
   "jp = 34/3+12-(13+41)*7/3+(13-2/732/3+2+33/11);"
   "a = -5 /2 * 4/-3;"
   "k = 10 - 51 - 5 + ( 100/2) -41/3;"
   "k = 10 - 51 - 5;"
   "jp = 34/3+12-(13+41)*7/3+(13-2/7*(32/3)+2+33/11);"
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
