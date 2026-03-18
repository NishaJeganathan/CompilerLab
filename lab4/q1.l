%{
#include "q1.tab.h"
#include<stdio.h>
#include<string.h>
%}
%%
[0-9]+ { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z]+ { yylval.str = strdup(yytext); return ID; }
"=" return '=';
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
";" return ';';





[ \t\n] ;
.  return yytext[0];

%%

int yywrap()
{
    return 1;
}