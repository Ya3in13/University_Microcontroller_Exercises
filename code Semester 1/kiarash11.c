#include <mega16.h>

 main(){
 DDRA=0B00000000;
 PORTA=0B11111111;           
 DDRC=0B11111111; 
 
 while (1){
   if(PINA.0==0) {
      PORTC=0B00100111;
   }  
   
   else if(PINA.1==0) {
   PORTC=0B01101111;
   }
   
   else if(PINA.2==0) {
   PORTC=0B01011111;
   }
   else if(PINA.3==0) {                                          
   PORTC=0B00000110;
   }
   else {
   PORTC=0B00111111;
   }
   }
   }
