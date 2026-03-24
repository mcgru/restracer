//#include <>

/* Non-symmetric c/c++ allocation/deallocation */

int main(void) {
    char* p;

//    art_start("");

    p = new char;

    free(p); // Should be delete

    return 0;
}
