#include <mega16.h>
#include <delay.h>
main()

{
 DDRC=0XFF;
    DDRD=0XFF;
 while(1){
  PORTD=0XFF;
  PORTC=0X66; 
  PORTD=0XFE;
  delay_ms(4);
  PORTD=0XFF;
  PORTC=0X7F; 
  PORTD=0XFD;
  delay_ms(4);
  PORTD=0XFF;
  PORTC=0X27; 
  PORTD=0XFB;
  delay_ms(4);
  PORTD=0XFF;
  PORTC=0X27; 
  PORTD=0XF7;
  delay_ms(4);
             }
             }
             
  