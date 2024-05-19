#include <stdint.h>
#include "platform.h"


#define RESULT_SUCCESS  1
#define RESULT_NO       0


void int_handler()
{
    if (!ps2_ptr->unread_data)
        return;

    uint32_t i = 1;
    uint32_t in = ps2_ptr->scan_code;

    while (i != in) {
        i <<= 1;
        if (i != 0)
            continue;

        hex_ptr->hex0 = 1;
        return;
    }
    
    hex_ptr->hex0 = 0;
}


int main(int argc, char** argv)
{
    while (1) {
        
    }

    return 0;
}
