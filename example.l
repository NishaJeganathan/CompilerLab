%option noyywrap
%{
#include <stdio.h>
%}

%%
[0-9]+        { printf("NUMBER: %s\n", yytext); }
[a-zA-Z]+     { printf("WORD: %s\n", yytext); }
[ \t\n]+      ;   /* ignore whitespace */
"//".*                ;
.             { printf("CHAR: %s\n", yytext); }
%%

int main(void)
{
    yylex();
    return 0;
}
