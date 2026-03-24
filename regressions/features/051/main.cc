//#include <>

/* Resource (C++ (non-array) type) leak */

int main(void) {
    short* p;

    art_start("");

    p = new short;

    return 0;
}
