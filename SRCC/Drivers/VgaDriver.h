#ifndef VGADRIVER_H
#define VGADRIVER_H

#include "Macros/ConversionTools.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_UNIT 2

#define VGA_MEMSTART 0xB8000
#define VGA_MEMEND   0xB8000 + VGA_WIDTH*VGA_HEIGHT*VGA_UNIT - 1

#define VGA_MODE_NOBLINK_BLACK_HIGH_WHITE 0b00001111
#define VGA_MODE_NOBLINK_WHITE_HIGH_BLACK 0b01111000

# define VGA_REG_CTRL 0x3D4
# define VGA_REG_DATA 0x3D5

void clearScreen(const unsigned char character,const unsigned char mode);
void printScreen(const unsigned char *String,const int size,const unsigned char mode);
void printChar(const unsigned char character,const int row,const int col,const unsigned char mode);
void printHexWord(const unsigned short character,const int row,const int col,const unsigned char mode);

#endif