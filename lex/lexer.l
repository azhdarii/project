%{
#include <stdio.h>
#include <stdlib.h>

// Declare global variables or helper functions here if needed
%}

%option noyywrap

// Regular definitions
digit       [0-9]
number      {digit}+(\.{digit}+)?

%%

// Match numbers and handle multiples of 10
{number}    { 
                int num = atoi(yytext);
                if (num % 10 == 0) {
                    int reversed = 0;
                    while (num != 0) {
                        reversed = reversed * 10 + num % 10;
                        num /= 10;
                    }
                    printf("Reversed Number: %d\n", reversed);
                } else {
                    printf("Number: %s\n", yytext);
                }
                return NUMBER;
            }

// Match operators
"+"         { printf("Operator: +\n"); return '+'; }
"-"         { printf("Operator: -\n"); return '-'; }
"*"         { printf("Operator: *\n"); return '*'; }
"/"         { printf("Operator: /\n"); return '/'; }

// Match parentheses
"("         { printf("Left Parenthesis: (\n"); return '('; }
")"         { printf("Right Parenthesis: )\n"); return ')'; }

// Ignore whitespace
[ \t\n]+    { /* Ignore whitespace */ }

// Handle invalid characters
.           { printf("Unexpected character: %s\n", yytext); }

%%

// Main function to initialize lexical analysis
int main() {
    yylex(); // Start lexical analysis
    return 0;
}

// Error handler
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
