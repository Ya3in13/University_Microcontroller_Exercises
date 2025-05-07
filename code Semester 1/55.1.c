#include<mega16.h>
main()
{
DDRA=0B00000000;
PORTA=0B11111111;
DDRC=0B11111111;
while(1){
  if(PINA.0==1)  
  PORTC=0B01100110;
  else if(PINA.1==1)
  PORTC=0B01111111;
  else if(PINA.2==1)
  PORTC=0B00100111;
  else if(PINA.3==1)
  PORTC=0B01101111;
  else
  PORTA=0B00000000;
  
  }
  }
   