#include "Macros/Time.h"


void delay(int ticks) {
    for (volatile int i = 0; i < ticks * 100000; i++) {
    }
}