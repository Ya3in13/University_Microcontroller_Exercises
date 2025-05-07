#include <mega16.h>

 main(){
 DDRA=0X00;
 PORTA=0XFF;           
 DDRD=0X03;
 DDRC=0XFF;
 PORTC=0X71;     
 
 while (1){
   if(PINA.0==0X00) {
   PORTD=0X01;
   PORTC=0X50;
   }  
   
   else if(PINA.1==0X00) {
   PORTD=0X02;
   PORTC=0X38;
   }
   
   else if(PINA.2==0X00) {
   PORTD=0X00;
   PORTC=0X71;
   }
   }
   }
