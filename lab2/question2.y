%{
#include <stdio.h>
int yylex();
void yyerror(const char *s);
%}

%token IF ELSE
%token ID NUMBER
%token LT GT LE GE EQ NE
%token ASSIGN
%token LPAREN RPAREN LBRACE RBRACE SEMI

%%

program:
        if_stmt
      ;

if_stmt:
        IF LPAREN cond RPAREN block
            { printf("Valid IF statement\n"); }
      | IF LPAREN cond RPAREN block ELSE block
            { printf("Valid IF-ELSE statement\n"); }
      ;

block:
        LBRACE stmt RBRACE
      | LBRACE RBRACE
      ;

stmt:
        ID ASSIGN expr SEMI
      ;

cond:
        ID relop ID
      | ID
      ;

relop:
        LT | GT | LE | GE | EQ | NE
      ;

expr:
        ID
      | NUMBER
      ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}

int main()
{
    printf("Enter if / if-else statement:\n");
    yyparse();
    return 0;
}
