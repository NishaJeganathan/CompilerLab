%{
#include "q3.tab.h"
#include<string.h>
%}

%%
"||"        { return OR; }

[0-9]+      { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

"<"         { return LT; }
"="         { return '='; }
";"         { return ';'; }

[ \t\n]     ;

.           { return yytext[0]; }

%%

int yywrap() { return 1; }