%option noyywrap
%x COMMENT
%{
#include <stdio.h>
#include <string.h>
%}

%%
[0-9]+        { printf("NUMBER: %s\n", yytext); }
[ \t\n]+      ;
"//".*        ;
"/*"          { BEGIN(COMMENT); }

<COMMENT>"*/" { BEGIN(INITIAL); }

<COMMENT>.    ;
<COMMENT>\n   ;
\"([^\"\\]|\\.)*\" {
    printf("STRING: %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    if (strlen(yytext) > 32) {
        printf("ERROR: Identifier too long (%s)\n", yytext);
    }
    else if (
        strcmp(yytext, "int") == 0 ||
        strcmp(yytext, "float") == 0 ||
        strcmp(yytext, "char") == 0 ||
        strcmp(yytext, "double") == 0 ||
        strcmp(yytext, "if") == 0 ||
        strcmp(yytext, "else") == 0 ||
        strcmp(yytext, "while") == 0 ||

        strcmp(yytext, "for") == 0 ||

        strcmp(yytext, "include") == 0 ||

        strcmp(yytext, "printf") == 0 ||
        strcmp(yytext, "stdio") == 0 ||
        strcmp(yytext, "return") == 0
    ) {
        printf("KEYWORD: %s\n", yytext);
    }
    else {
        printf("IDENTIFIER: %s\n", yytext);
    }
}
.             ;
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
