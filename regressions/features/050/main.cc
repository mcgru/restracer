//#include <>

/* Resource (C++ (non-array) type) leak */

int main(void) {
    char* p;

    art_start("");

    p = new char;

    return 0;
}
