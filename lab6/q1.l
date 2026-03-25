%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

digit   [0-9]
id      [a-zA-Z][a-zA-Z0-9]*

%%

{digit}+ { yylval.num = atoi(yytext); return NUMBER; }
{id}     { yylval.id = strdup(yytext); return ID; }
"="      { return '='; }
"+"      { return '+'; }
"-"      { return '-'; }
"*"      { return '*'; }
"/"      { return '/'; }
\n       { return EOL; }
[ \t]    ;   /* ignore whitespace */
.        { return yytext[0]; }

%%
int yywrap() { return 1; }