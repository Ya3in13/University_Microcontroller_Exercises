#include <delay.h>
#include <mega16.h>
main()
{
DDRC=0B11111111;
while(1){  
PORTC=0b01001111;                 // 0b01001111       0b01011011     0b01111101
delay_ms(500);
PORTC=0b01011011;  
delay_ms(500);
PORTC=0b01111101;
delay_ms(500);
PORTC=0b01111101;
delay_ms(500);
PORTC=0B00000000;
delay_ms(500);
          }
          }