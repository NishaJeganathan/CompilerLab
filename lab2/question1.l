%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

"#".*                           ;   

"if"|"else"|"switch"|"case"|"default"|"int"|"float"|"double"|"char"|"return"|"printf"|"scanf"|"main"         ;

";"                             { return SEMI; }
","|"{"|"}"|"["|"]"             ;

\"([^\\\"]|\\.)*\"              { return STRING; }

[0-9]+(\.[0-9]+)?               { return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*          { return ID; }

"&&"                            { return AND; }
"||"                            { return OR; }
"!"                             { return NOT; }

"<="                            { return LE; }
">="                            { return GE; }
"=="                            { return EQ; }
"!="                            { return NE; }
"<"                             { return LT; }
">"                             { return GT; }

"+"                             { return PLUS; }
"-"                             { return MINUS; }
"*"                             { return MUL; }
"/"                             { return DIV; }

"="                             { return ASSIGN; }

"("                             { return LPAREN; }
")"                             { return RPAREN; }

[ \t\n]+                        ;

.                               ;

%%

int yywrap()
{
    return 1;
}
