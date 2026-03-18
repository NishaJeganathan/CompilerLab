%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int temp = 1;

char* newtemp() {
    char *t = malloc(10);
    sprintf(t, "t%d", temp++);
    return t;
}

void yyerror(char *s) {
    printf("Error\n");
}

int yylex();
%}

%union {
    char* str;
    struct {
        char* code;
        char* place;
    } expr;
}

/* TOKENS */
%token <str> ID 
%token OR LT

/* TYPES */
%type <expr> B

%%


S : ID '=' B ';'
{
    printf("%s", $3.code);
    printf("%s = %s\n", $1, $3.place);
}
;


B : ID LT ID
{
    char *t = newtemp();
    char buffer[100];

    sprintf(buffer, "%s = %s < %s\n", t, $1, $3);

    $$.code = strdup(buffer);
    $$.place = t;
}

| B OR B
{
    char *t = newtemp();
    char buffer[200];

    sprintf(buffer, "%s%s%s = %s || %s\n",
            $1.code, $3.code, t, $1.place, $3.place);

    $$.code = strdup(buffer);
    $$.place = t;
}

;

%%

int main() {
    printf("Enter statement:\n");
    yyparse();
}