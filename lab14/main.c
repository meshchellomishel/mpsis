#include <stdint.h>
#include <stdbool.h>
#include "platform.h"


#define KC_UP 0xF0
#define KC_0  0x45
#define KC_1  0x16
#define KC_2  0x1E
#define KC_3  0x26
#define KC_4  0x25
#define KC_5  0x2E
#define KC_6  0x36
#define KC_7  0x3D
#define KC_8  0x3E
#define KC_9  0x46
#define KC_A  0x1C
#define KC_B  0x32
#define KC_C  0x21
#define KC_D  0x23
#define KC_E  0x24
#define KC_F  0x2B

#define KC_SP 0x29
#define KC_EN 0x5A

#define KC_STEP  1
#define KCS_MAX   9


int res = 0, i_ps = 0;
bool is_up = false;

void int_handler()
{
    if (!ps2_ptr->unread_data)
        return;

	bool need_calc = false;
    uint32_t in = ps2_ptr->scan_code;

	if (is_up) {
		is_up = false;
		return;
	}

	if (i_ps == KCS_MAX)
		need_calc = true;
    
    switch(in) {
        case KC_SP:
            res = 0;
            i_ps = 0;
            break;
        case KC_0:
            res = res*16;
            i_ps += KC_STEP;
            break;
        case KC_1:
            res = res*16 + 1;
            i_ps += KC_STEP;
            break;
        case KC_2:
            res = res*16 + 2;
            i_ps += KC_STEP;
            break;
        case KC_3:
            res = res*16 + 3;
            i_ps += KC_STEP;
            break;
        case KC_4:
            res = res*16 + 4;
            i_ps += KC_STEP;
            break;
        case KC_5:
            res = res*16 + 5;
            i_ps += KC_STEP;
            break;
        case KC_6:
            res = res*16 + 6;
            i_ps += KC_STEP;
            break;
        case KC_7:
            res = res*16 + 7;
            i_ps += KC_STEP;
            break;
        case KC_8:
            res = res*16 + 8;
            i_ps += KC_STEP;
            break;
        case KC_9:
            res = res*16 + 9;
            i_ps += KC_STEP;
            break;
        case KC_A:
            res = res*16 + 10;
            i_ps += KC_STEP;
            break;
        case KC_B:
            res = res*10 + 11;
            i_ps += KC_STEP;
            break;
        case KC_C:
            res = res*16 + 12;
            i_ps += KC_STEP;
            break;
        case KC_D:
            res = res*16 + 13;
            i_ps += KC_STEP;
            break;
        case KC_E:
            res = res*16 + 14;
            i_ps += KC_STEP;
            break;
        case KC_F:
            res = res*16 + 15;
            i_ps += KC_STEP;
            break;
        case KC_EN:
			need_calc = true;
            break;
		case KC_UP:
			is_up = true;
			break;
        default:
            hex_ptr->hex0 = 0xE;
			hex_ptr->hex1 = 0x4;
			hex_ptr->hex2 = 0x4;
			hex_ptr->hex3 = 0x0;
			hex_ptr->hex4 = 0x4;
            return;
    }

	hex_ptr->hex0 = res % 16;
	hex_ptr->hex1 = res / 16;
	hex_ptr->hex2 = res / (16*16);
	hex_ptr->hex3 = res / (16*16*16);
	hex_ptr->hex4 = res / (16*16*16*16);

	if (need_calc)
		goto calc;

    return;

calc:
    int i = 1;

    while (i != res && i != 0)
        i <<= 1;
    
	if (i == res && i != 0) {
		hex_ptr->hex0 = 0x1;
		hex_ptr->hex1 = 0x0;
		hex_ptr->hex2 = 0x5;
		hex_ptr->hex3 = 0xe;
		hex_ptr->hex4 = 0x4;
	} 
	else {
		hex_ptr->hex0 = 0x0;
		hex_ptr->hex1 = 0x0;
		hex_ptr->hex2 = 0x5;
		hex_ptr->hex3 = 0xe;
		hex_ptr->hex4 = 0x4;
	}

    res = 0;
    i_ps = 0;
}


int main(int argc, char** argv)
{
    while (1) {
        
    }

    return 0;
}
