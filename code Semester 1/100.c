#include <mega16.h>
#include <delay.h>

#define up PINA.0
#define down PINA.1
#define sen PINB.1
#define start PINB.0
#define motor PORTD.0
#define valve PORTD.1

 bit fels = 0 ;
 int time , orgtime=5 ;
 int seg[10] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x27,0x7F,0x6F};

  main(){
    DDRA=0x00;
    DDRB=0x00;
    DDRC=0XFF;
    DDRD=0xFF ;
    PORTA=0xFF;
    PORTB=0xFF;
    time=orgtime;
    
     while(1){  
      PORTC=seg[time];
      if(start==0){motor=1;}   
       else if(sen==0){motor=0;valve=1;fels=1;time=orgtime;}
       if(fels==1){
       PORTC=seg[time];
       time--;
       delay_ms(1000);
       
       if(time==0){  
       PORTC=seg[time];
       valve=0;
       fels=0;
       time=orgtime;
       ;}   
      ;}      
      
     if(up==0){if(time<9){orgtime++;}delay_ms(500);time=orgtime;}
     if(down==0){if(time>1){orgtime--;}delay_ms(500);time=orgtime;}   


     }  
    }