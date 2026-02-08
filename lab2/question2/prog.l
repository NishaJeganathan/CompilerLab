%{
#include "prog.tab.h"
#include <stdio.h>

extern FILE *yyin;
%}

%%

"if"                        { return IF; }
"else"                      { return ELSE; }
"while"                     { return WHILE; }
"printf"                    { return PRINTF; }
"scanf"                     { return SCANF; }
"int main()"                { return OPEN; }
"#include <stdio.h>"        { return HEADER; }
"int"                       { return INT;}
[a-zA-Z_][a-zA-Z0-9_]*      { return ID; }
[0-9]+                      { return NUM; }
","                         { return COMMA; }
\"([^\\\"]|\\.)*\"          { return STRING; }

"("                         { return LPAREN; }
")"                         { return RPAREN; }
"{"                         { return LBRACE; }
"}"                         { return RBRACE; }
";"                         { return SEMICOLON; }
"%"                         { return MODULO; }
"+"|"-"|"/"|"*"             { return ARITH; }
"<"|">"|">="|"<="|"=="|"!=" { return RELOP;}
"!"|"&&"|"||"               { return LOGIC; }
"&"                         { return AMP; }
"="                         { return ASSIGN; }

[ \t\n]+    ;   /* ignore spaces */

.           ;   /* ignore other characters */

%%

int yywrap() { return 1; }
