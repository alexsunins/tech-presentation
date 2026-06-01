#include <iostream>
#include<tuple>
using namespace std;

int get_steps(int y){
    int i = 0;

    while (true){
        if (y < ( 2 << i )){
            return i - 1;
        }

        i += 1;
    }
}

int bin_multiply(int x, int y){
   if (y == 0){
       return 0;
   }     

   if (y == 1){
       return x;       
   }
      

   int bit_shift_steps = get_steps(y);
   int remainder = y - ( 2 << bit_shift_steps );
   return ( x << (bit_shift_steps + 1) ) + bin_multiply(x, remainder);
}

std::tuple <int, int> extract_lsb(int x){
    tuple <int, int > result;
    result = make_tuple(x >> 1, x & 1);
    return result;
}
        

int multiply(int x, int y){
    
    tuple <int, int> lsb_extract;
    lsb_extract = extract_lsb(y);

    int shifted_y = get<0>(lsb_extract);
    int lsb = get<1>(lsb_extract);

    int result = (shifted_y == 0) ? x : ( bin_multiply(x, lsb) + multiply(x << 1, shifted_y) );
    return result;
}

long fPow(int base, int exp){
    long result = (exp == 1) ? base : multiply(base, fPow(base, exp - 1));
    return result;
}
   

int main(){
    int base = 8;
    for (int x = 1; x < 9; x ++ ){
        std::cout << base << " to the power of " << x << " is: " << fPow(base, x) << std::endl;
    }
    return 0;
}

//  the total time elapsed, the time consumed by system overhead, and the time used to execute utility to the standard error stream.