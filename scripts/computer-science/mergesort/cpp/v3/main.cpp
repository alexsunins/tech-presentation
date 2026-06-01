#include <iostream>

using namespace std;

struct array_t {
    int *values;
    int len;
};


array_t concat(int n, array_t arr){
    int new_len = arr.len + 1;

    array_t r;
    r.values = new int[new_len];
    r.values[0] = n;
    r.len = new_len;

    int *pr     = &r.values[1];
    int *p_arr  = arr.values;
    
    for (int i = 0; i < arr.len; ++i) *pr++ = *p_arr++;

    return r;
}


array_t pop(array_t a){
    array_t r;
    r.len = a.len - 1;

    if (r.len == 0)
        return r;
    else {
        r.values = new int[r.len];
        int *pa = &a.values[1], *pr = r.values;

        for ( int i = 1; i < a.len; ++i) *pr++ = *pa++;

        return r;
    }
}


array_t merge(array_t x, array_t y){
    if (x.len == 0) return y;
    if (y.len == 0) return x;

    if (x.values[0] <= y.values[0])
        return concat(x.values[0], merge(pop(x), y));
    else
        return concat(y.values[0], merge(x, pop(y)));
}


array_t merge_sort(array_t a){
    if (a.len > 1){
        array_t lhs, rhs;
        int mid_idx = (a.len % 2 == 0) ? a.len / 2 : (a.len + 1) / 2;

        // cout << "\nmid_idx = " << mid_idx << endl;

        lhs.len = mid_idx;
        lhs.values = new int[lhs.len];        

        rhs.len = a.len - mid_idx;
        rhs.values = new int[rhs.len];        

        int *pa = a.values, *p_lhs = lhs.values, *p_rhs = rhs.values;
        for (int i = 0; i < mid_idx; ++i){
            *p_lhs = *pa;
            *p_rhs = *(pa + mid_idx);
            ++pa; ++p_lhs;
            if (lhs.len == rhs.len) ++p_rhs; else if (i < rhs.len) ++p_rhs;
        }

        // cout << "LHs: "; for (int i = 0; i < lhs.len; ++i) cout << lhs.values[i] << " "; cout << endl;
        // cout << "RHs: "; for (int i = 0; i < rhs.len; ++i) cout << rhs.values[i] << " "; cout << endl;

        return merge(merge_sort(lhs), merge_sort(rhs));
    } else
        return a;
}

int main(){
    int len = 11;
    int a[11] = {-25, 12, 13, 8, 4, -1, 15, 7, 11, 6, 9};
    array_t b;
    b.values = a;
    b.len = len;

    array_t c = merge_sort(b);

    for (int i = 0; i < c.len; ++i) cout << c.values[i] << " "; cout << endl;

    return 0;
}