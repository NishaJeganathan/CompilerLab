%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int temp = 1;
int label = 1;

char* newtemp() {
    char *t = malloc(10);
    sprintf(t, "t%d", temp++);
    return t;
}

char* newlabel() {
    char *l = malloc(10);
    sprintf(l, "L%d", label++);
    return l;
}

void yyerror(char *s) {
    printf("Error\n");
}

int yylex();
%}

%union {
    struct {
        char* code;
        char* place;
    } expr;
    char* str;
}

%token <str> ID NUM 
%token WHILE LT IF ELSE EQ GT

%left '+'
%left '*'
%left '/'

%type <expr> E
%type <str> S

%%

S : WHILE '(' E LT E ')' S
{
    char *L1 = newlabel();
    char *L2 = newlabel();
    char *L3 = newlabel();

    printf("%s:\n", L1);
    printf("%s", $3.code);
    printf("%s", $5.code);

    printf("if %s < %s goto %s\n", $3.place, $5.place, L2);
    printf("goto %s\n", L3);

    printf("%s:\n", L2);
    printf("%s", $7);   // body inside loop
    printf("goto %s\n", L1);

    printf("%s:\n", L3);

    $$ = "";
}

| ID '=' E ';'
{
    char buffer[200];
    sprintf(buffer, "%s%s = %s\n", $3.code, $1, $3.place);
    $$ = strdup(buffer);
}

;

E : E '+' E
{
    char *t = newtemp();
    char buffer[200];

    sprintf(buffer, "%s%s%s = %s + %s\n",
            $1.code, $3.code, t, $1.place, $3.place);

    $$.code = strdup(buffer);
    $$.place = t;
}

| E '*' E
{
    char *t = newtemp();
    char buffer[200];

    sprintf(buffer, "%s%s%s = %s * %s\n",
            $1.code, $3.code, t, $1.place, $3.place);

    $$.code = strdup(buffer);
    $$.place = t;
}

| E '/' E
{
    char *t = newtemp();
    char buffer[200];

    sprintf(buffer, "%s%s%s = %s / %s\n",
            $1.code, $3.code, t, $1.place, $3.place);

    $$.code = strdup(buffer);
    $$.place = t;
}

| ID
{
    $$.code = "";
    $$.place = $1;
}

| NUM
{
    $$.code = "";
    $$.place = $1;
}

;

%%

int main() {
    printf("Enter statement:\n");
    yyparse();
}