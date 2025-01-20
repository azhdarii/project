%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Temporary variable counter
int temp_count = 0;

// Function to generate a new temporary variable
char* new_temp() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

// Forward declaration of yylex()
int yylex();
void yyerror(const char *s);

extern char *yytext;

%}

%token ID NUMBER
%right '+' '-'
%left '*' '/'
%right '='

%union {
    struct expr_data {
        char* code;   // Temporary variable or value
        double value; // Computed values
    } expr_data;
    char* id;        // For identifiers
    double num;      // For numeric values
}

%type <expr_data> expr
%type <id> ID
%type <num> NUMBER

%%

program:
    program statement
    | /* empty */
    ;

statement:
    ID '=' expr ';' {
        printf("%s = %s\n", $1, $3.code); // Generate three-address code
        printf("Value of %s: %f\n", $1, $3.value); // Output computed value
        free($3.code); // Free allocated memory
    }
    ;

expr:
    expr '+' expr {
        char* temp = new_temp();
        printf("%s = %s + %s\n", temp, $1.code, $3.code); // Generate three-address code
        $$ = (struct expr_data) {temp, $1.value + $3.value}; // Compute value
        free($1.code);
        free($3.code);
    }
    | expr '-' expr {
        char* temp = new_temp();
        printf("%s = %s - %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value - $3.value};
        free($1.code);
        free($3.code);
    }
    | expr '*' expr {
        char* temp = new_temp();
        printf("%s = %s * %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value * $3.value};
        free($1.code);
        free($3.code);
    }
    | expr '/' expr {
        if ($3.value == 0) {
            fprintf(stderr, "Error: Division by zero\n");
            exit(1);
        }
        char* temp = new_temp();
        printf("%s = %s / %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value / $3.value};
        free($1.code);
        free($3.code);
    }
    | '(' expr ')' {
        $$ = $2;
    }
    | NUMBER {
        $$ = (struct expr_data) {strdup(yytext), atof(yytext)};
    }
    | ID {
        $$ = (struct expr_data) {strdup(yytext), 0.0}; // Default value for ID
    }
    ;

%%

int main() {
    printf("Enter input for lexical analysis:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
