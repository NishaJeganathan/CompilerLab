%{
#include "intermediate.tab.h"
#include <string.h>
%}

%%
[a-zA-Z][a-zA-Z0-9]*   { yylval.str = strdup(yytext); return ID; }
[0-9]+                 { yylval.str = strdup(yytext); return NUM; }
"+"                    { return PLUS; }
"*"                    { return MUL; }
"="                    { return ASSIGN; }
";"                    { return SEMI; }
[ \t\n]                ;
.                      { return yytext[0]; }
%%
int yywrap() {
    return 1;
}