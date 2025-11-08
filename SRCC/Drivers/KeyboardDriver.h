#ifndef KEYBOARDDRIVER_H
#define KEYBOARDDRIVER_H

#include "Macros/Portio.h"

#define KEYBOARD_REG_DATA 0x60
#define KEYBOARD_REG_CTRL 0x64


unsigned char readRawKeyboard();
unsigned char readASCIIKeyboard();
#endif