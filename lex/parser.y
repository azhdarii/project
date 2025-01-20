%{
#include <stdio.h>
#include <stdlib.h>

int temp_count = 0;

// Function to generate a new temporary variable
char* new_temp() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

// Forward declaration
int yylex();
void yyerror(const char *s);

extern char *yytext;

%}

%token ID NUMBER
%right '+' '-'
%left '*' '/'

%union {
    struct expr_data {
        char* code;   // Temporary variable or value
        double value; // Computed value (if applicable)
    } expr_data;
    double num;
}

%type <expr_data> expr term factor
%type <expr_data> stmt
%type <num> NUMBER

%%

stmt:
    ID '=' expr ';' {

       
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s\n", $1, $3.code);
        printf("Result: %f\n", $3.value);
        free($3.code);
    }
    ;

expr:
    term '+' expr {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s + %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value + $3.value};
        free($1.code);
        free($3.code);
    }
    | term '-' expr {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s - %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value - $3.value};
        free($1.code);
        free($3.code);
    }
    | term {
        $$ = $1;
    }
    ;

term:
    term '*' factor {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s * %s\n", temp, $1.code, $3.code);
        $$ = (struct expr_data) {temp, $1.value * $3.value};
        free($1.code);
        free($3.code);
    }
    | term '/' factor {
        if ($3.value == 0) {
            yyerror("Division by zero");
            $$ = (struct expr_data) {strdup("error"), 0.0};
        } else {
            char* temp = new_temp();
            printf("Three-Address Code: %s = %s / %s\n", temp, $1.code, $3.code);
            $$ = (struct expr_data) {temp, $1.value / $3.value};
        }
        free($1.code);
        free($3.code);
    }
    | factor {
        $$ = $1;
    }
    ;

factor:
    '(' expr ')' {
        $$ = $2;
    }
    | NUMBER {
        $$ = (struct expr_data) {strdup(yytext), $1};
    }
    ;

%%

int main() {
    printf("Enter an assignment expression (e.g., x = 3 + 2 * (4 - 1);):\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
