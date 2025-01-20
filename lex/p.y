%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// Temporary variable counter
int temp_count = 0;

// Function to generate a new temporary variable
char* new_temp() {
    static char temp[10];
    sprintf(temp, "t%d", temp_count++);
    return strdup(temp);
}

// Symbol table for variables
// For simplicity, variables are single letters (a-z)

// Forward declaration of yylex()
int yylex();
void yyerror(const char *s);

 extern char *yytext;



%}

%token ID NUMBER
%right '+' '-'
%left '*' '/'
%right '='

%%
program:
    program statement
    | /* empty */
    ;

statement:
    ID '=' expr ';' {
        printf("%s = %s\n", $1, $3); // Assign the result to the variable
        
    }
    ;

expr:
    expr '+' expr {
        char* temp = new_temp();
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr '-' expr {
        char* temp = new_temp();
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr '*' expr {
        char* temp = new_temp();
        printf("%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr '/' expr {
        char* temp = new_temp();
        printf("%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    | NUMBER {
        $$ = $1
    }
    | ID {
        $$ = $1
    }
    ;

%%
/* User code */
int main() {

   
    printf("Enter expressions (Ctrl+D to quit):\n");
    yyparse();
  
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
