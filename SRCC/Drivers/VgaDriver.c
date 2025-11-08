#include "Drivers/VgaDriver.h"

void clearScreen(const unsigned char character , const unsigned char mode){
    
    volatile const unsigned char * VGA_MEMORY=(volatile const unsigned char*)VGA_MEMSTART;
    
    char *memoryPointer = (unsigned char*)VGA_MEMORY;

    for(int i=0;i<VGA_WIDTH*VGA_HEIGHT;i++){
        *(memoryPointer+i*VGA_UNIT)=character;
        *(memoryPointer+i*VGA_UNIT+1)=mode;

        
    }
}

void printScreen(const unsigned char *string,const int size,const unsigned char mode){
    volatile const unsigned short * VGA_MEMORY_START=(volatile const unsigned short*)VGA_MEMSTART;
    volatile const unsigned short * VGA_MEMORY_END=(volatile const unsigned short*)(VGA_MEMEND);

    unsigned short *memoryPointer = (unsigned short*)VGA_MEMORY_START;
    for(int i=0;i<size;i++){
        if(memoryPointer>(unsigned short*)VGA_MEMORY_END){break;}
        *(memoryPointer)=(mode<<8)|string[i];
        memoryPointer++;
    }
}


void printChar(const unsigned char character, const int col, const int row, const unsigned char mode) {
    if (row >= VGA_HEIGHT || row < 0 || col >= VGA_WIDTH || col < 0) return;
    unsigned short* memoryPointer = (unsigned short*)(VGA_MEMSTART + (row * VGA_WIDTH + col) * VGA_UNIT);
    *memoryPointer = ((unsigned short)mode << 8) | character;
}



void printHexWord(const unsigned short hex,const int col,const int row,const unsigned char mode){
    if(row>VGA_HEIGHT || row<0 || col>VGA_WIDTH-1 || col<0){return;}
    unsigned short* memoryPointer = (unsigned short*)(VGA_MEMSTART+(row*VGA_WIDTH+col)*VGA_UNIT);
    unsigned short word = hexToAscii(hex);
    *(memoryPointer) = (mode<<8)|((word&0xFF00)>>8);
    *(memoryPointer+1) = (mode<<8)|(word&0xFF);
}