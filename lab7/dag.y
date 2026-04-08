%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int yylex();
int yyerror(const char *s);

/* ---------- 3AC ---------- */
char ic[100][50];
int ic_index = 0;
int temp_count = 0;

char* newTemp() {
    char temp[10];
    sprintf(temp, "t%d", temp_count++);
    return strdup(temp);
}

void addIC(char *str) {
    strcpy(ic[ic_index++], str);
}

/* ---------- VARIABLE MAP (FIX) ---------- */
typedef struct {
    char var[10];
    char val[10];
} Map;

Map var_map[100];
int map_count = 0;

char* getMapped(char *var) {
    for(int i = map_count-1; i >= 0; i--) {
        if(strcmp(var_map[i].var, var) == 0)
            return var_map[i].val;
    }
    return var;
}

void updateMap(char *var, char *val) {
    strcpy(var_map[map_count].var, var);
    strcpy(var_map[map_count].val, val);
    map_count++;
}

typedef struct {
    char op;
    char left[10];
    char right[10];
    char res[10];
} Node;

Node dag[100];
int dag_count = 0;

int findNode(char op, char *l, char *r) {
    for(int i = 0; i < dag_count; i++) {
        if(dag[i].op == op &&
           strcmp(dag[i].left, l) == 0 &&
           strcmp(dag[i].right, r) == 0)
            return i;
    }
    return -1;
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%token PLUS MUL ASSIGN SEMI
%type <str> expr term factor

%%

program: program stmt
       | stmt
       ;

stmt: ID ASSIGN expr SEMI {
        char buf[50];
        sprintf(buf, "%s = %s", $1, $3);
        addIC(buf);
     }
     ;

expr: expr PLUS term {
        char *t = newTemp();
        char buf[50];
        sprintf(buf, "%s = %s + %s", t, $1, $3);
        addIC(buf);
        $$ = t;
     }
    | term { $$ = $1; }
    ;

term: term MUL factor {
        char *t = newTemp();
        char buf[50];
        sprintf(buf, "%s = %s * %s", t, $1, $3);
        addIC(buf);
        $$ = t;
     }
    | factor { $$ = $1; }
    ;

factor: ID { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%

void buildDAG() {
    for(int i = 0; i < ic_index; i++) {

        char res[10], op1[10], op2[10], op;

        if(sscanf(ic[i], "%s = %s %c %s", res, op1, &op, op2) == 4) {

            char real_op1[10], real_op2[10];
            strcpy(real_op1, getMapped(op1));
            strcpy(real_op2, getMapped(op2));

            if(op == '+' || op == '*') {
                if(strcmp(real_op1, real_op2) > 0) {
                    char temp[10];
                    strcpy(temp, real_op1);
                    strcpy(real_op1, real_op2);
                    strcpy(real_op2, temp);
                }
            }

            int idx = findNode(op, real_op1, real_op2);

            char final_res[10];

            if(idx == -1) {
                strcpy(dag[dag_count].left, real_op1);
                strcpy(dag[dag_count].right, real_op2);
                dag[dag_count].op = op;
                strcpy(dag[dag_count].res, res);

                strcpy(final_res, res);

                dag_count++;
            } else {
                strcpy(final_res, dag[idx].res);
            }

            updateMap(res, final_res);
        }
        else {
            char lhs[10], rhs[10];
            sscanf(ic[i], "%s = %s", lhs, rhs);

            char *real_rhs = getMapped(rhs);

            dag[dag_count].op = '=';
            strcpy(dag[dag_count].left, real_rhs);
            strcpy(dag[dag_count].right, "");
            strcpy(dag[dag_count].res, lhs);
            dag_count++;

            updateMap(lhs, real_rhs);
        }
    }
}

/* ---------- PRINT DAG ---------- */
void printDAG() {
    printf("\nDAG:\n");
    for(int i = 0; i < dag_count; i++) {
        if(dag[i].op == '=')
            printf("%s = %s\n", dag[i].res, dag[i].left);
        else
            printf("%s = %s %c %s\n",
                   dag[i].res,
                   dag[i].left,
                   dag[i].op,
                   dag[i].right);
    }
}

/* ---------- OPTIMIZED IC ---------- */
void generateOptimizedIC() {
    printf("\nOPTIMIZED IC:\n");
    for(int i = 0; i < dag_count; i++) {
        if(dag[i].op == '=')
            printf("%s = %s\n", dag[i].res, dag[i].left);
        else
            printf("%s = %s %c %s\n",
                   dag[i].res,
                   dag[i].left,
                   dag[i].op,
                   dag[i].right);
    }
}

/* ---------- TARGET CODE ---------- */
void generateTarget() {
    printf("\nTARGET CODE:\n");

    for(int i = 0; i < dag_count; i++) {
        if(dag[i].op == '+' || dag[i].op == '*') {

            printf("MOV R0, %s\n", dag[i].left);

            if(dag[i].op == '+')
                printf("ADD R0, %s\n", dag[i].right);
            else
                printf("MUL R0, %s\n", dag[i].right);

            printf("MOV %s, R0\n", dag[i].res);
        }
        else {
            printf("MOV %s, %s\n", dag[i].res, dag[i].left);
        }
    }
}

/* ---------- MAIN ---------- */
int main() {
    printf("Enter input:\n");
    yyparse();

    printf("\n3-ADDRESS CODE:\n");
    for(int i = 0; i < ic_index; i++)
        printf("%s\n", ic[i]);

    buildDAG();
    printDAG();
    generateOptimizedIC();
    generateTarget();

    return 0;
}

int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}