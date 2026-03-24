//#include <>

/* Non-symmetric c/c++ allocation/deallocation */

int main(void) {
    char* p;

//    art_start("");

    p = (char *)malloc(1);

    delete[] p; // Should be free()

    return 0;
}
