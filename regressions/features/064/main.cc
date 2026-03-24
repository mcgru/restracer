#include <iostream>

/* Working constructor, destructor */

class A {
    int m_i;

public:
    A(){std::cout << "I'm constructor" << std::endl;}
    ~A(){std::cout << "I'm destructor" << std::endl;}
};

int main(void) {
    A* p;

//    art_start("");

    p = new A;

    delete p;

    return 0;
}
