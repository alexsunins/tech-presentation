#include <iostream>

short int calculate_disc(int a, int b, int c){
    short int result = (b * b) - (4 * a * c);
    // std::cout << result << std::endl;

    return result;
}

void print_roots(int x1, int x2){
    std::cout << "Root one: " << x1 << std::endl;
    std::cout << "Root two: " << x2 << std::endl;
}

int main(){
    // a = 1, b = -5 and c = 6
    int a = 1;
    int b = 0;
    int c = -16;

    int disc, root_one, root_two;

    if (a != 0){
        disc = calculate_disc(a, b, c);
        if (disc < 0){
            std::cout << "No real roots" << std::endl;
            return 0;
        }
    }

    if (b != 0){
        disc = calculate_disc(a, b, c);

        root_one = (-b + sqrt(disc)) / (2 * a);
        root_two = (-b - sqrt(disc)) / (2 * a);

        print_roots(root_one, root_two);
        
        return 0;
    }

    if (c == 0){
        std::cout << "x - any number" << std::endl;
        return 0;
    }
    else{
        if (b == 0){
            root_one = sqrt(-c);
            root_two = -(sqrt(-c));

            print_roots(root_one, root_two);
            return 0;
        }else{
            std::cout << "equation does not exist" << std::endl;
            return 0;
        }
    }

    // return 0;
}