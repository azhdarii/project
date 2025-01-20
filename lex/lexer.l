%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" 




%}

%option noyywrap


digit [0-9]
number [+-]?{digit}+ 
letter [A-Za-z]
id {letter}({letter}|{digit})*
ws [ \t\n]+
semicolon [;]

%%

{id} { 
    return ID; 
}

{number} { 
    int num = atoi(yytext);
    if (num % 10 == 0) {
        yylval.num = num; 
    } else {
        int reversed = 0, original = num;
        while (original != 0) {
            reversed = reversed * 10 + original % 10;
            original /= 10;
        }
        yylval.num = reversed; 
    }
    return NUMBER;
}

"=" {  
    return '='; 
}
"+" { 
    return '+'; 
}
"-" { 
    return '-'; 
}
"*" { 
    return '*'; 
}
"/" { 
    return '/'; 
}

"(" { 
    return '('; 
}
")" { 
    return ')'; 
}

{ws} { 
    /* Ignore whitespace */ 
}

{semicolon} {
    return ';';
}

. { 
    printf("Unexpected character: %s\n", yytext); 
}

%%


