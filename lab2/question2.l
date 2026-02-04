%{
#include "y.tab.h"
#include <stdio.h>
%}

%%

"if"            { return IF; }
"else"          { return ELSE; }

"<="            { return LE; }
">="            { return GE; }
"=="            { return EQ; }
"!="            { return NE; }
"<"             { return LT; }
">"             { return GT; }

"="             { return ASSIGN; }

[0-9]+          { return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }

"("             { return LPAREN; }
")"             { return RPAREN; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }
";"             { return SEMI; }

[ \t\n]+        ;

.               ;

%%

int yywrap()
{
    return 1;
}
