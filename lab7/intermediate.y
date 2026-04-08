%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int yylex();
int yyerror(const char *s);

/* ---------- GLOBALS ---------- */
int temp_count = 0;
int ic_index = 0;
int opt_index = 0;

char ic[100][50];
char opt_ic[100][50];

/* ---------- UTILITIES ---------- */
char* newTemp() {
    char temp[10];
    sprintf(temp, "t%d", temp_count++);
    return strdup(temp);
}

void addIC(char *str) {
    strcpy(ic[ic_index++], str);
}

int isNumber(char *s) {
    for(int i = 0; s[i]; i++) {
        if(!isdigit(s[i])) return 0;
    }
    return 1;
}
%}

/* ---------- UNION ---------- */
%union {
    char* str;
}

/* ---------- TOKENS ---------- */
%token <str> ID NUM
%token PLUS MUL ASSIGN SEMI
%type <str> expr term factor

%%

/* ---------- GRAMMAR ---------- */
program: program stmt
       | stmt
       ;

stmt: ID ASSIGN expr SEMI {
        char buffer[50];
        sprintf(buffer, "%s = %s", $1, $3);
        addIC(buffer);
     }
     ;

expr: expr PLUS term {
        char *t = newTemp();
        char buffer[50];
        sprintf(buffer, "%s = %s + %s", t, $1, $3);
        addIC(buffer);
        $$ = t;
     }
    | term { $$ = $1; }
    ;

term: term MUL factor {
        char *t = newTemp();
        char buffer[50];
        sprintf(buffer, "%s = %s * %s", t, $1, $3);
        addIC(buffer);
        $$ = t;
     }
    | factor { $$ = $1; }
    ;

factor: ID { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%

/* ---------- OPTIMIZATION ---------- */
void optimize() {
    int j = 0;

    char expr_table[100][30];
    char expr_result[100][10];
    int expr_count = 0;

    for(int i = 0; i < ic_index; i++) {

        char res[10], op1[10], op2[10], operator;

        if(sscanf(ic[i], "%s = %s %c %s", res, op1, &operator, op2) == 4) {

            /* ---------- CONSTANT FOLDING ---------- */
            if(isNumber(op1) && isNumber(op2)) {
                int val1 = atoi(op1);
                int val2 = atoi(op2);
                int result;

                if(operator == '+') result = val1 + val2;
                else if(operator == '*') result = val1 * val2;

                char buffer[50];
                sprintf(buffer, "%s = %d", res, result);
                strcpy(opt_ic[j++], buffer);
                continue;
            }

            /* ---------- COMMUTATIVE NORMALIZATION ---------- */
            if(operator == '+' || operator == '*') {
                if(strcmp(op1, op2) > 0) {
                    char temp[10];
                    strcpy(temp, op1);
                    strcpy(op1, op2);
                    strcpy(op2, temp);
                }
            }

            /* ---------- COMMON SUBEXPRESSION ---------- */
            char expr[30];
            sprintf(expr, "%s%c%s", op1, operator, op2);

            int found = -1;
            for(int k = 0; k < expr_count; k++) {
                if(strcmp(expr_table[k], expr) == 0) {
                    found = k;
                    break;
                }
            }

            if(found != -1) {
                char buffer[50];
                sprintf(buffer, "%s = %s", res, expr_result[found]);
                strcpy(opt_ic[j++], buffer);
            } else {
                strcpy(expr_table[expr_count], expr);
                strcpy(expr_result[expr_count], res);
                expr_count++;

                strcpy(opt_ic[j++], ic[i]);
            }
        }
        else {
            /* ---------- COPY ELIMINATION ---------- */
            if(strstr(ic[i], " = t") &&
               strchr(ic[i], '+') == NULL &&
               strchr(ic[i], '*') == NULL) {
                continue;
            }

            strcpy(opt_ic[j++], ic[i]);
        }
    }

    opt_index = j;
}

/* ---------- CODE GENERATION ---------- */
void generateCode() {
    printf("\nTARGET CODE (without DAG):\n");

    for(int i = 0; i < opt_index; i++) {
        char op1[10], op2[10], res[10], operator;

        if(sscanf(opt_ic[i], "%s = %s %c %s", res, op1, &operator, op2) == 4) {
            printf("MOV R0, %s\n", op1);

            if(operator == '+')
                printf("ADD R0, %s\n", op2);
            else if(operator == '*')
                printf("MUL R0, %s\n", op2);

            printf("MOV %s, R0\n", res);
        }
        else {
            char lhs[10], rhs[10];
            sscanf(opt_ic[i], "%s = %s", lhs, rhs);
            printf("MOV %s, %s\n", lhs, rhs);
        }
    }
}

/* ---------- MAIN ---------- */
int main() {
    printf("Enter Expression(s):\n");
    yyparse();

    printf("\nINTERMEDIATE CODE:\n");
    for(int i = 0; i < ic_index; i++)
        printf("%s\n", ic[i]);

    optimize();

    printf("\nOPTIMIZED CODE:\n");
    for(int i = 0; i < opt_index; i++)
        printf("%s\n", opt_ic[i]);

    generateCode();
    return 0;
}

/* ---------- ERROR ---------- */
int yyerror(const char *s) {
    printf("Error: %s\n", s);
    return 0;
}