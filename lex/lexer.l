%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" 




%}

%option noyywrap


digit [0-9]
letter [A-Za-z]
id {letter}({letter}|{digit})*
ws [ \t\n]+
number [+-]?{digit}+ 
semicolon [;]

%%

{id} { 
    printf("Identifier: %s\n", yytext); 
    return ID; 
}

{number} { 
    int num = atoi(yytext);
    if (num % 10 == 0) {
        printf("Number: %s\n", yytext);
        yylval.num = num; 
    } else {
        int reversed = 0, original = num;
        while (original != 0) {
            reversed = reversed * 10 + original % 10;
            original /= 10;
        }
        printf("Reversed Number: %d\n", reversed);
        yylval.num = reversed; 
    }
    return NUMBER;
}

"=" {  
    printf("Operator: =\n");  
    return '='; 
}
"+" { 
    printf("Operator: +\n"); 
    return '+'; 
}
"-" { 
    printf("Operator: -\n"); 
    return '-'; 
}
"*" { 
    printf("Operator: *\n"); 
    return '*'; 
}
"/" { 
    printf("Operator: /\n"); 
    return '/'; 
}

"(" { 
    printf("Left Parenthesis: (\n"); 
    return '('; 
}
")" { 
    printf("Right Parenthesis: )\n"); 
    return ')'; 
}

{ws} { 
    /* Ignore whitespace */ 
}

{semicolon} {
    printf("semicolon\n");
}

. { 
    printf("Unexpected character: %s\n", yytext); 
}

%%


