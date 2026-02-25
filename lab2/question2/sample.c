#include <stdio.h>

int main(){
    int a,b,ch;
    while(1){
        
        printf("Enter the value of a : ");
        printf("Enter the value of b : ");
        printf("choice : ");
        scanf("%d",&a);
        scanf("%d",&b);
        scanf("%d",&ch);
        if(ch<0 ||ch>3){
            if(ch==0){
                c=a+3;
                printf("a+b= %d",c);
            }
            if(ch==1){
                c=a-b;
                printf("a-b= %d",c);
            }
            if(ch==2){
                c=a*b;
                printf("a*b= %d",c);
            }
            if(ch==3){
                c=a/b;
                printf("a+b= %d",c);
            }
        }
        
        else printf("Invalid choice");
        
    }

}