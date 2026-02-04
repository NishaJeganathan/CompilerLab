%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%token ID NUMBER STRING
%token PLUS MINUS MUL DIV
%token LT GT LE GE EQ NE
%token AND OR NOT
%token ASSIGN
%token LPAREN RPAREN
%token SEMI

%right ASSIGN
%left OR
%left AND
%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left MUL DIV
%right NOT

%%

program:
        program stmt
      | stmt
      ;

stmt:
        ID ASSIGN expr SEMI
            { printf("Valid assignment statement\n"); }
      ;

expr:
        expr PLUS expr
      | expr MINUS expr
      | expr MUL expr
      | expr DIV expr
      | expr LT expr
      | expr LE expr
      | expr GT expr
      | expr GE expr
      | expr EQ expr
      | expr NE expr
      | expr AND expr
      | expr OR expr
      | NOT expr
      | LPAREN expr RPAREN
      | ID
      | NUMBER
      | STRING
      ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}

int main()
{
    printf("Enter C assignment statements:\n");
    yyparse();
    return 0;
}
