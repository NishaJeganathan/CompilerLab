%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror(char *s);

int temp_count = 1;

typedef struct Node {
    char *res;
    char *op;
    char *left;
    char *right;
} Node;

Node dag[50];
int dag_count = 0;

// Keep track of assignments for optimized code printing
typedef struct Assign {
    char *lhs;
    char *rhs;
} Assign;

Assign optcode[50];
int opt_count = 0;

// Find a node in DAG
int find_node(char *left, char *op, char *right) {
    for (int i = 0; i < dag_count; i++) {
        if (strcmp(dag[i].left, left) == 0 &&
            strcmp(dag[i].right, right) == 0 &&
            strcmp(dag[i].op, op) == 0)
            return i;
    }
    return -1;
}

char* newtemp() {
    char *t = (char*)malloc(5);
    sprintf(t, "t%d", temp_count++);
    return t;
}

void print_dag() {
    printf("\nDAG Nodes:\n");
    for (int i = 0; i < dag_count; i++) {
        if (dag[i].op && strlen(dag[i].op) > 0)
            printf("%s = %s %s %s\n", dag[i].res, dag[i].left, dag[i].op, dag[i].right);
        else
            printf("%s = %s\n", dag[i].res, dag[i].left);
    }
}

void print_optimized_code() {
    printf("\nOptimized Code:\n");
    for (int i = 0; i < dag_count; i++) {
        if (dag[i].op && strlen(dag[i].op) > 0)
            printf("%s = %s %s %s\n", dag[i].res, dag[i].left, dag[i].op, dag[i].right);
        else
            printf("%s = %s\n", dag[i].res, dag[i].left);
    }
}

%}

%union {
    char *id;
    int num;
}

%token <id> ID
%token <num> NUMBER
%token EOL

%type <id> expr expr1 statement

%%

program:
    statements
    ;

statements:
      /* empty */
    | statements statement
    ;

statement:
    expr EOL { }
    ;

expr:
      ID '=' expr1
      {
          int idx = find_node($3, "", "");
          if (idx != -1) {
              // RHS is already in DAG, map LHS
              dag[dag_count].res = strdup($1);
              dag[dag_count].op = strdup(dag[idx].op);
              dag[dag_count].left = strdup(dag[idx].left);
              dag[dag_count].right = strdup(dag[idx].right);
              dag_count++;
          } else {
              // RHS is a single variable
              dag[dag_count].res = strdup($1);
              dag[dag_count].op = strdup(""); // no operator
              dag[dag_count].left = strdup($3);
              dag[dag_count].right = strdup("");
              dag_count++;
          }
      }
    ;

expr1:
      ID '+' ID
      {
          int idx = find_node($1, "+", $3);
          if (idx != -1) $$ = strdup(dag[idx].res);
          else {
              char *t = newtemp();
              dag[dag_count].res = strdup(t);
              dag[dag_count].op = strdup("+");
              dag[dag_count].left = strdup($1);
              dag[dag_count].right = strdup($3);
              dag_count++;
              $$ = strdup(t);
          }
      }
    | ID
      { $$ = strdup($1); }
    ;

%%

int main() {
    printf("Enter statements (Ctrl+D to end):\n");
    yyparse();
    print_dag();
    print_optimized_code();
    return 0;
}

int yyerror(char *s) {
    printf("Parse error: %s\n", s);
    return 0;
}