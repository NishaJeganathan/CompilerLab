%{
#include "sample.tab.h"
#include <stdio.h>

extern FILE *yyin;
%}

%%

"if"        { return IF; }
"else"      { return ELSE; }
[a-zA-Z_][a-zA-Z0-9_]*   { return ID; }



"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
"+"|"-"|"/"|"*"|"%" { return ARITH; }
"<"|">"|">="|"<="|"=="|"!=" { return RELOP;}
"!"|"&"|"|" { return LOGIC; }
"="         { return ASSIGN; }
[ \t\n]+    ;   /* ignore spaces */

.           ;   /* ignore other characters */

%%

int yywrap() { return 1; }
