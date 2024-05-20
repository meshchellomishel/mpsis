#include <stdint.h>
#include "platform.h"


#define PS_UP 0xF0
#define PS_0  0x45
#define PS_1  0x16
#define PS_2  0x1E
#define PS_3  0x26
#define PS_4  0x25
#define PS_5  0x2E
#define PS_6  0x36
#define PS_7  0x3D
#define PS_8  0x3E
#define PS_9  0x46
#define PS_A  0x1C
#define PS_B  0x32
#define PS_C  0x21
#define PS_D  0x23
#define PS_E  0x24
#define PS_F  0x2B

#define PS_SP 0x29
#define PS_EN 0x5A

#define PS_STEP  1
#define PS_MAX   9


int res = 0, i_ps = 0;

void int_handler()
{
    if (!ps2_ptr->unread_data)
        return;

    uint32_t in = ps2_ptr->scan_code;

    if (i_ps == PS_MAX)
        goto calc;
    
    switch(in) {
        case PS_SP:
            res = 0;
            i_ps = 0;
            break;
        case PS_0:
            res = res*10;
            i_ps += PS_STEP;
            break;
        case PS_1:
            res = res*10 + 1;
            i_ps += PS_STEP;
            break;
        case PS_2:
            res = res*10 + 2;
            i_ps += PS_STEP;
            break;
        case PS_3:
            res = res*10 + 3;
            i_ps += PS_STEP;
            break;
        case PS_4:
            res = res*10 + 4;
            i_ps += PS_STEP;
            break;
        case PS_5:
            res = res*10 + 5;
            i_ps += PS_STEP;
            break;
        case PS_6:
            res = res*10 + 6;
            i_ps += PS_STEP;
            break;
        case PS_7:
            res = res*10 + 7;
            i_ps += PS_STEP;
            break;
        case PS_8:
            res = res*10 + 8;
            i_ps += PS_STEP;
            break;
        case PS_9:
            res = res*10 + 9;
            i_ps += PS_STEP;
            break;
        case PS_A:
            res = res*10 + 10;
            i_ps += PS_STEP;
            break;
        case PS_B:
            res = res*10 + 11;
            i_ps += PS_STEP;
            break;
        case PS_C:
            res = res*10 + 12;
            i_ps += PS_STEP;
            break;
        case PS_D:
            res = res*10 + 13;
            i_ps += PS_STEP;
            break;
        case PS_E:
            res = res*10 + 14;
            i_ps += PS_STEP;
            break;
        case PS_F:
            res = res*10 + 15;
            i_ps += PS_STEP;
            break;
        case PS_EN:
            goto calc;
            break;
        default:
            hex_ptr->hex0 = 0xE4404;
            break;
    }

    return;

calc:
    int i = 1;

    while (i != res && i != 0)
        i <<= 1;
    
    if (i == res)
        hex_ptr->hex0 = 1;
    else
        hex_ptr->hex0 = 0;

    res = 0;
    i_ps = 0;
}


int main(int argc, char** argv)
{
    while (1) {
        
    }

    return 0;
}