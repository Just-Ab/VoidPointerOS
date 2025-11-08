#include "Drivers/VgaDriver.h"
#include "Drivers/KeyboardDriver.h"


#include "Macros/Portio.h" 
#include "Macros/Time.h"

typedef struct Ball
{
    int pos;
    int vel;
    int acc;
}Ball;


void main(){
    char msg[] = "what";
    printScreen(msg,sizeof(msg)-1,VGA_MODE_NOBLINK_BLACK_HIGH_WHITE);
    Ball ball={0,0,0};
    delay(1);
    while (1)
    {

        ball.acc+=2 ;
        ball.vel+=ball.acc;
        ball.pos+= ball.vel/100;
        if (ball.pos>24){
            ball.pos = 24;
            ball.vel = -ball.vel;
        }
        clearScreen(' ',VGA_MODE_NOBLINK_BLACK_HIGH_WHITE);
        printHexWord(readRawKeyboard(),40,17,VGA_MODE_NOBLINK_BLACK_HIGH_WHITE);
        printChar(readASCIIKeyboard(),40,15,VGA_MODE_NOBLINK_BLACK_HIGH_WHITE);  
        delay(3);  
        
    }
        

}