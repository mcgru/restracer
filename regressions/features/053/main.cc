//#include <>

/* Resource (C++ (array) type) leak */

int main(void) {
    short* p;

    art_start("");

    p = new short[10];

    return 0;
}
