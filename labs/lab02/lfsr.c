#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    unsigned zero_bit = (*reg) & 1;
    unsigned two_bit = (*reg >> 2) & 1;
    unsigned three_bit = (*reg >> 3) & 1;
    unsigned five_bit = (*reg >> 5) & 1;
    unsigned shift_bit = ((zero_bit ^ two_bit) ^ three_bit) ^ five_bit;
    *reg = *reg >> 1;
    *reg = ((*reg) & (~(1 << 15))) | (shift_bit << 15);
}

