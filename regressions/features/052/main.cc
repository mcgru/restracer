//#include <>

/* Resource (C++ (array) type) leak */

int main(void) {
    char* p;

    art_start("");

    p = new char[10];

    return 0;
}
