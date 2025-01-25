%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" 

void reverse_string(char* str);


%}

%option noyywrap


digit [0-9]
number {digit}+ 
letter [A-Za-z]
id {letter}({letter}|{digit})*
ws [ \t\n]+
semicolon [;]

%%


{id} { 
    yylval.id=strdup(yytext);
    return ID; 
}

{number} { 
    int num = atoi(yytext);
    if (num % 10 == 0) {
        yylval.expr_data.value = num;
        yylval.expr_data.code = strdup(yytext);
        
        
    } else {
        int reversed = 0, original = num;
        while (original != 0) {
            reversed = reversed * 10 + original % 10;
            original /= 10;
        }
        
        yylval.expr_data.value = reversed;

        yylval.expr_data.code = malloc(strlen(yytext) + 1); 

        if (yylval.expr_data.code == NULL) {
            fprintf(stderr, "Memory allocation failed\n");
            exit(1);
        }
        strcpy(yylval.expr_data.code, yytext);
        reverse_string(yylval.expr_data.code);
       
  
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


void reverse_string(char* str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

