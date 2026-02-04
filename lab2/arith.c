#include <stdio.h>

int main() {
    int a = 10, b = 5 , c=10 , d=10;

    a=b*c+d;
    a= a+b/c||a+b;
    b= (a>b)<=d;

    return 0;
}
