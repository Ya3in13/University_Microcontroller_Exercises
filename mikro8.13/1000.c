#include <mega16a.h> 
#include <delay.h>
#define up PINA.0
#define down PINA.1
#define sen PINA.2
#define start PINA.3
#define motor PORTC.1


    bit k ;  
    bit v ;
    int a =3266;
 
int seg[13] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xD8,0x80,0x90,0xAF,0x8E,0xC7};
void main(void){
 DDRA=0XF0;
 DDRB=0XFF;
 DDRC=0XFF;
 DDRD=0XFF;
 PORTB=0XFF; 
 PORTC=0X00; 


    while(1){  
    
    if(PINA.0==0){
    if(k==0){
    a++;
    k=1; }
    }else k=0;

    if(PINA.1==0){
    if(v==0){
    a--;
    v=1; }
    }else v=0;

    PORTC=0B11111111;
    PORTB= seg[(a/1000)%10];
    PORTC=0B11101111;
    delay_ms(1);

    PORTC=0B11111111;
    PORTB= seg[(a/100)%10];
    PORTC=0B11011111;
    delay_ms(1);

    PORTC=0B11111111;
    PORTB= seg[(a/10)%10];
    PORTC=0B10111111;
    delay_ms(1);

    PORTC=0B11111111;
    PORTB= seg[(a/1)%10];
    PORTC=0B01111111;
    delay_ms(1);    

    }  
    }  
 