//#include <>

/* Non-symmetric new-delete */

int main(void) {
    char* p;

//    art_start("");

    p = new char;

    delete[] p; // Should be 'delete p'

    return 0;
}
