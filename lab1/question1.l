%option noyywrap
%x COMMENT
%{
#include <stdio.h>
extern FILE *yyin;
%}



%%
[0-9]+        { printf("NUMBER: %s\n", yytext); }
[a-zA-Z]+     { printf("WORD: %s\n", yytext); }
[ \t\n]+      ;   /* ignore whitespace */
"//".*                ;
.             { printf("CHAR: %s\n", yytext); }
"/*"          { BEGIN(COMMENT); }

<COMMENT>"*/" { BEGIN(INITIAL); }

<COMMENT>.    ;
<COMMENT>\n   ;

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
