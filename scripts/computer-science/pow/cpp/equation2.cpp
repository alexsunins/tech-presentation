#include <iostream>

int calculate_disc(int a, int b, int c){
    return (b * b) - (4 * a * c);
}

void print_roots(int disc, int x1, int x2){
    std::cout << "Disc: " << disc << std::endl;
    std::cout << "Root one: " << x1 << std::endl;
    std::cout << "Root two: " << x2 << std::endl;
}

int main(){
    int a = 1;
    int b = 5;
    int c = 6;

    int disc, root_one, root_two;

    if (a != 0){
        disc = calculate_disc(a, b, c);
        if (disc < 0){
            std::cout << "No solution in the real number system" << std::endl;
            return 0;
        }

        if (disc == 0){
            // one root
            root_one = (-b + sqrt(disc)) / (2 * a);
            std::cout << "One root: " << root_one << std::endl;
            return 0;
        }

        // otherwise two roots
        root_one = (-b + sqrt(disc)) / (2 * a);
        root_two = (-b- + sqrt(disc)) / (2 * a);

        print_roots(disc, root_one, root_two);
        return 0;
    }

    if (b != 0){
        std::cout << -c / b << std::endl;
        return 0;
    }

    if (c == 0){
        std::cout << "x - any number" << std::endl;
        return 0;
    }else{
        std::cout << "Equation does not exist" << std::endl;
        return 0;
    }

    return 0;
}