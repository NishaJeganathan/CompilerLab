%option noyywrap
%x COMMENT
%{
#include <stdio.h>
#include <string.h>
%}

%%
"//".*        ;
"/*"          { BEGIN(COMMENT); }

<COMMENT>"*/" { BEGIN(INITIAL); }

<COMMENT>.    ;
<COMMENT>\n   ;
"#".* ;
"++"        { printf("Increment Operator (++)\n"); }
"--"        { printf("Decrement Operator (--)\n"); }

"+="        { printf("Addition Assignment Operator (+=)\n"); }
"-="        { printf("Subtraction Assignment Operator (-=)\n"); }
"*="        { printf("Multiplication Assignment Operator (*=)\n"); }
"/="        { printf("Division Assignment Operator (/=)\n"); }
"%="        { printf("Modulus Assignment Operator (%%=)\n"); }

"+"         { printf("Addition Operator (+)\n"); }
"-"         { printf("Subtraction Operator (-)\n"); }
"*"         { printf("Multiplication Operator (*)\n"); }
"/"         { printf("Division Operator (/)\n"); }
"%"         { printf("Modulus Operator (%%)\n"); }

"=="        { printf("Equal To Operator (==)\n"); }
"!="        { printf("Not Equal To Operator (!=)\n"); }
">="        { printf("Greater Than or Equal To Operator (>=)\n"); }
"<="        { printf("Less Than or Equal To Operator (<=)\n"); }
">"         { printf("Greater Than Operator (>)\n"); }
"<"         { printf("Less Than Operator (<)\n"); }

"&&"        { printf("Logical AND Operator (&&)\n"); }
"||"        { printf("Logical OR Operator (||)\n"); }
"!"         { printf("Logical NOT Operator (!)\n"); }

"="         { printf("Assignment Operator (=)\n"); }

"&"         { printf("Bitwise AND Operator (&)\n"); }
"|"         { printf("Bitwise OR Operator (|)\n"); }
"^"         { printf("Bitwise XOR Operator (^)\n"); }
"~"         { printf("Bitwise NOT Operator (~)\n"); }
"<<"        { printf("Left Shift Operator (<<)\n"); }
">>"        { printf("Right Shift Operator (>>)\n"); }
";"         { printf("SEMICOLON\n");}
[ \t\n]+    ;   /* Ignore whitespace */
.           ;   /* Ignore other characters */

%%

int main(int argc, char *argv[])
{
    if (argc < 2) return 1;
    yyin = fopen(argv[1], "r");
    if (!yyin) return 1;
    yylex();
    fclose(yyin);
    return 0;
}