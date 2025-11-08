#include "Macros/ConversionTools.h"


    short hexToAscii(unsigned char hex){
        unsigned char hexList[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
        unsigned char low = hex & 0x0F;
        unsigned char high = (hex & 0xF0)>>4;

        short word = (hexList[high])<<8|hexList[low] ;
        return word;
    }