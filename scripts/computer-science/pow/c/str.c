#include <stdio.h>
#include <stdlib.h>

const char* str_func(int x){
    char* ptr = (char*) malloc(8 * sizeof(char));

    int lsb;
    for (int i = 0; i < 8; i++){
        lsb = x & 128;
        ptr[i] = (lsb == 0) ? '0' : '1';
        x = x << 1;        
    }

    return &ptr[0];
}

int count_ones(int num){
    int c = 0;
    while (num){
        c += 1;
        num = num & (num - 1);
    }

    return c;
}

int main(){
    int int_val = 81;
    // for (int int_val = 0; int_val < 256; int_val++){
    //     printf("Binary of %d is %s\n", int_val, str_func(int_val));
    // }

    printf("Binary of %d is %s\n", int_val, str_func(int_val));
    printf("There are %d ones in %d\n", count_ones(int_val), int_val);
    
    return 0;
}