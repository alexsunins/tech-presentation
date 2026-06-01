#include <iostream>

using namespace std;

struct mult_t {
    int shift;
    int lsb;
};


mult_t extract_lsb(int x){
    mult_t res;
    res.shift   = x >> 1;
    res.lsb     = x & 1;
    return res;
}


int binary_multiply(int x, int y){
    mult_t lsb = extract_lsb(y);
    if (lsb.shift == 0)
        return x;
    else
        if (lsb.lsb == 0) return binary_multiply(x << 1, lsb.shift); else return x + binary_multiply(x << 1, lsb.shift);
}


int main(){
    int a = 25;
    int b = 4;
    printf("%d x %d = %d\n", a, b, binary_multiply(a,b));
}