%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;

int yylex(void);
int yyerror(const char *s);
%}

%token IF ELSE ID NUM WHILE
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON
%token MODULO ARITH RELOP LOGIC ASSIGN 
%token INT OPEN HEADER 
%token SCANF PRINTF STRING COMMA AMP

%left LOGIC
%left RELOP
%left MODULO
%left ARITH
%right ASSIGN

%%
program 
    : HEADER OPEN LBRACE program1 RBRACE
    ;

program1
    : program1 stmt
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

print_stmt:
        PRINTF LPAREN STRING RPAREN SEMICOLON
      | PRINTF LPAREN STRING COMMA arg_list RPAREN SEMICOLON
      ;

scanf_stmt
      : SCANF LPAREN STRING RPAREN SEMICOLON
      | SCANF LPAREN STRING COMMA arg_list1 RPAREN SEMICOLON
      ;

arg_list
      :  arg
      | arg_list COMMA arg
      ;

arg
      : ID
      | NUM
      ;

arg_list1
      : AMP ID
      | arg_list1 COMMA AMP ID
      ;

init_stmt
    : INT decl_list SEMICOLON
    ;

decl_list
    : decl
    | decl_list COMMA decl
    ;

decl
    : ID
    | ID ASSIGN NUM
    | ID ASSIGN ID
    ;


while_stmt
    : WHILE LPAREN exp RPAREN simple 


simple
    : exp SEMICOLON
    | LBRACE program1 RBRACE
    | print_stmt
    | scanf_stmt
    | init_stmt
    | while_stmt
    ;


exp
    : exp MODULO exp 
    | exp ARITH exp
    | exp RELOP exp
    | exp LOGIC exp
    | ID ASSIGN exp
    | LPAREN exp RPAREN
    | ID
    | NUM
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
