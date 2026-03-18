%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int temp=1;

char* newtemp()
{
    char *t = malloc(10);
    sprintf(t,"t%d",temp++);
    return t;
}

void yyerror(char *s)
{
    printf("Error\n");
}

int yylex();
%}

%union{
    char* str;
}

%token <str> ID NUM
%type <str> E

%%

S : ID '=' E ';'
{
    printf("%s = %s\n",$1,$3);
}
;

E : E '+' E
{
    char *t=newtemp();
    printf("%s = %s + %s\n",t,$1,$3);
    $$=t;
}

| E '*' E
{
    char *t=newtemp();
    printf("%s = %s * %s\n",t,$1,$3);
    $$=t;
}
| E '/' E
{
    char *t=newtemp();
    printf("%s = %s / %s\n",t,$1,$3);
    $$=t;
}
| ID
{
    $$=$1;
}

| NUM
{
    $$=$1;
}

;

%%

int main()
{
    printf("Enter expression:\n");
    yyparse();
}