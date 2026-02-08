%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;

int yylex(void);
int yyerror(const char *s);
%}

%token IF ELSE ID
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token ARITH RELOP LOGIC ASSIGN

%left LOGIC
%left RELOP
%left ARITH
%right ASSIGN

%%

program
    : program stmt
    | stmt
    ;
    
stmt
    : matched 
    | unmatched
    ;

matched
    : IF LPAREN exp RPAREN matched ELSE matched
    | simple 
    ;

unmatched
    : IF LPAREN exp RPAREN stmt
    | IF LPAREN exp RPAREN matched ELSE unmatched
    ;

simple
    : exp SEMICOLON
    | LBRACE program RBRACE
    ;


exp
    : exp ARITH exp
    | exp RELOP exp
    | exp LOGIC exp
    | exp ASSIGN exp
    | LPAREN exp RPAREN
    | ID
    ;

%%

int main(int argc, char *argv[])
{
    if (argc < 2) {
        printf("Usage: ./parser <file>\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Cannot open file\n");
        return 1;
    }

    if (yyparse() == 0)
        printf("Valid Syntax\n");

    fclose(yyin);
    return 0;
}

int yyerror(const char *s)
{
    printf("Syntax Error\n");
    return 0;
}
