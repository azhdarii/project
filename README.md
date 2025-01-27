a compiler that reads an assignment statement containing an expression and, while generating three-address code in C,

prints the result of the statement.

The following conditions must be considered during the expression evaluation:

1-The expression includes integers, addition (+), subtraction (-), multiplication (*), division (/), parentheses, and whitespace.

2-For multiples of 10, the number itself is used, but for other numbers, their reverse (both in input and during calculations) is considered.

3-The decimal part of any floating-point number obtained during calculations is discarded.

4-The precedence of addition and subtraction is higher than that of multiplication and division.

5-Associativity of addition and subtraction is right-to-left, while associativity of multiplication and division is left-to-right.

6-It is assumed that the input expression is free of compilation errors.


Examples:

<img width="434" alt="image" src="https://github.com/user-attachments/assets/ee212b8e-9868-4648-bbc1-b8aa92912958" />

