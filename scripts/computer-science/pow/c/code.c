#include <stdio.h>

struct lsb_extract_type
{
    int shifted_y;
    int lsb;
};

int get_steps(int y){
    int i = 0;

    while (1 == 1){
        if (y < ( 2 << i )){
            return i - 1;
        }

        i += 1;
    }
}

int bin_multiply(int x, int y){
   if (y == 0){
       return 0;
   };

   if (y == 1){
       return x;       
   };      

   int bit_shift_steps = get_steps(y);
   int remainder = y - ( 2 << bit_shift_steps );
   return ( x << (bit_shift_steps + 1) ) + bin_multiply(x, remainder);
}

struct lsb_extract_type extract_lsb(int x)
{
    struct lsb_extract_type temp;
    temp.shifted_y = x >> 1;
    temp.lsb = x & 1;
    return temp;
}
       

int multiply(int x, int y){    
    
    struct lsb_extract_type lsb_extract;
    lsb_extract = extract_lsb(y);

    int result = (lsb_extract.shifted_y == 0) ? x : ( bin_multiply(x, lsb_extract.lsb) + multiply(x << 1, lsb_extract.shifted_y) );
    return result;
}

long int fPow(int base, int exp){
    long result = (exp == 1) ? base : multiply(base, fPow(base, exp - 1));
    return result;
}

int main(){
    int base = 4;
    for (int x = 1; x < 9; x++){
        printf("%d to the power of %d is: %ld\n", base, x, fPow(base, x));
    }
}