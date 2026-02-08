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

int main()
{
    int choice;

    while (1)
    {
        printf("\n1. Check Syntax\n2. Exit\nEnter choice: ");
        scanf("%d", &choice);
        getchar();  // consume newline

        if (choice == 2)
            break;

        if (choice == 1)
        {
            char buffer[5000];
            int i = 0;
            char ch;
            printf("Enter code (end with #):\n");

            while ((ch = getchar()) != '#')
            {
                buffer[i++] = ch;
            }
            buffer[i] = '\0';

            FILE *temp = tmpfile();
            fputs(buffer, temp);
            rewind(temp);

            yyin = temp;

            if (yyparse() == 0)
                printf("Valid Syntax\n");
            else
                printf("\n");
        }
    }

    return 0;
}

int yyerror(const char *s)
{
    printf("Syntax Error\n");
    return 0;
}
