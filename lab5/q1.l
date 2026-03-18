%{
#include "q1.tab.h"
#include<string.h>
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }

[0-9]+      { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

"=="        { return EQ; }
"<"         { return LT; }
">"         { return GT; }

"+"         { return '+'; }
"*"         { return '*'; }
"/"         { return '/'; }
"="         { return '='; }

";"         { return ';'; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }

[ \t\n]     ;   // ignore whitespace

.           { return yytext[0]; }

%%

int yywrap() {
    return 1;
}