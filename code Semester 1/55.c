#include <mega16.h>
void main (void)
{

DDRA=0B00000000;
PORTA=0B11111111;
DDRC=0B11111111;
while(1){
  if(PINA.0==0) { 
  PORTC=0b01100110;
   } 
  
 if(PINA.1==0)
  { 
  PORTC=0b01111111; }
  
  if(PINA.2==0){
  PORTC=0b00100111;}
  
   if(PINA.3==0){
  PORTC=0b01101111;}
  else
  PORTA=0b00000000;
   }
  }
 
   