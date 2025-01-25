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

int reverse(int num);

extern char *yytext;

%}

%token ID NUMBER
%right '+' '-'
%left '*' '/'




%union {
    struct expr_data {
        char* code;   // Temporary variable or value
        int value; // Computed value (if applicable)
    } expr_data;
    char* id; 
}

%type <expr_data> expr term factor
%type <expr_data> stmt
%type <expr_data> NUMBER
%type <id> ID

%%

stmt:
    ID '=' expr ';' {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s\n", $1, $3.code);
        printf("Result: %d\n", $3.value);
        free($3.code);
         YYACCEPT;
    }
    ;

expr:
    expr '*' term {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s * %s\n", temp, $1.code, $3.code);

         int rev=reverse( $1.value * $3.value);
        $$ = (struct expr_data) {temp,rev };
        free($1.code);
        free($3.code);
    }
    | expr '/' term {
        if ($3.value == 0) {
            yyerror("Division by zero");
            $$ = (struct expr_data) {strdup("error"), 0.0};
        } else {
            char* temp = new_temp();
            printf("Three-Address Code: %s = %s / %s\n", temp, $1.code, $3.code);

              int rev=reverse( $1.value / $3.value);
            $$ = (struct expr_data) {temp, rev};
        }
        free($1.code);
        free($3.code);
    }
    | term {
        $$ = $1;
    }
    ;
term:
    factor '+' term {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s + %s\n", temp, $1.code, $3.code);

          int rev=reverse( $1.value + $3.value);
        $$ = (struct expr_data) {temp, rev};
        free($1.code);
        free($3.code);
    }
    | factor '-' term {
        char* temp = new_temp();
        printf("Three-Address Code: %s = %s - %s\n", temp, $1.code, $3.code);

          int rev=reverse(  $1.value - $3.value);
        $$ = (struct expr_data) {temp,rev};
        free($1.code);
        free($3.code);
    }
    | factor {
        $$ = $1;
    }
    ;

factor:
    '(' expr ')' {
        
        $$=$2;
    }
    | NUMBER {
        $$ = (struct expr_data) {strdup($1.code), $1.value};
    }
     | '-' factor  {
           $2.value=-$2.value; 
           $$ =$2;
    }
    | '+' factor  {
      
            $$ = $2; 
        
    }
    ;

%%

int reverse(int num){
     if (num % 10 == 0) {
       return num;    
    } else {
        int reversed = 0, original = num;
        while (original != 0) {
            reversed = reversed * 10 + original % 10;
            original /= 10;
        }
        return reversed;
    }
}



int main() {
    printf("Enter an assignment expression (e.g., x = 3 * 4 + 2;):\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
