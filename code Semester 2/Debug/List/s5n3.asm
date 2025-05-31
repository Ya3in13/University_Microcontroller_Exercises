
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cnt1=R4
	.DEF _cnt1_msb=R5
	.DEF _cnt2=R6
	.DEF _cnt2_msb=R7
	.DEF _cnt3=R8
	.DEF _cnt3_msb=R9
	.DEF _cnt4=R10
	.DEF _cnt4_msb=R11
	.DEF _cnt5=R12
	.DEF _cnt5_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

<<<<<<< Updated upstream
;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0002


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

=======
>>>>>>> Stashed changes
__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

<<<<<<< Updated upstream
;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

=======
>>>>>>> Stashed changes
;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
<<<<<<< Updated upstream
;bit ki,state=1;
;unsigned int cnt1,cnt2,cnt3,cnt4,cnt5,cntki;
=======
;
;unsigned int cnt1,cnt2,cnt3,cnt4,cnt5;
>>>>>>> Stashed changes
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){
; 0000 0005 interrupt [9] void timer1_ovf_isr(void){

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
<<<<<<< Updated upstream
	ST   -Y,R27
=======
>>>>>>> Stashed changes
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0006     TCNT1=-1000;
	LDI  R30,LOW(64536)
	LDI  R31,HIGH(64536)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0007     if(++cnt3>220){PORTB.0=!PORTB.0;cnt3=0;}
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	CPI  R30,LOW(0xDD)
	LDI  R26,HIGH(0xDD)
	CPC  R31,R26
	BRLO _0x3
	SBIS 0x18,0
	RJMP _0x4
	CBI  0x18,0
	RJMP _0x5
_0x4:
	SBI  0x18,0
_0x5:
	CLR  R8
	CLR  R9
; 0000 0008     if(++cnt4>670){PORTB.1=!PORTB.1;cnt4=0;}
_0x3:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	CPI  R30,LOW(0x29F)
	LDI  R26,HIGH(0x29F)
	CPC  R31,R26
	BRLO _0x6
	SBIS 0x18,1
	RJMP _0x7
	CBI  0x18,1
	RJMP _0x8
_0x7:
	SBI  0x18,1
_0x8:
	CLR  R10
	CLR  R11
; 0000 0009     if(++cnt5>1600){PORTB.2=!PORTB.2;cnt5=0;}
_0x6:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	CPI  R30,LOW(0x641)
	LDI  R26,HIGH(0x641)
	CPC  R31,R26
	BRLO _0x9
	SBIS 0x18,2
	RJMP _0xA
	CBI  0x18,2
	RJMP _0xB
_0xA:
	SBI  0x18,2
_0xB:
	CLR  R12
	CLR  R13
; 0000 000A     if(++cnt1>50){cnt2++;cnt1=0;}
_0x9:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,51
	BRLO _0xC
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
	CLR  R4
	CLR  R5
<<<<<<< Updated upstream
; 0000 000B     if(ki){cntki++;}
_0xC:
	SBRS R2,0
	RJMP _0xD
	LDI  R26,LOW(_cntki)
	LDI  R27,HIGH(_cntki)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 000C 
; 0000 000D }
_0xD:
=======
; 0000 000B }
_0xC:
>>>>>>> Stashed changes
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
<<<<<<< Updated upstream
	LD   R27,Y+
=======
>>>>>>> Stashed changes
	LD   R26,Y+
	RETI
; .FEND
;void main(void){
<<<<<<< Updated upstream
; 0000 000E void main(void){
_main:
; .FSTART _main
; 0000 000F     {
; 0000 0010     // Declare your local variables here
; 0000 0011 
; 0000 0012     // Input/Output Ports initialization
; 0000 0013     // Port A initialization
; 0000 0014     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0015     DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0016     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0017     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0018 
; 0000 0019     // Port B initialization
; 0000 001A     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 001B     DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 001C     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 001D     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 001E 
; 0000 001F     // Port C initialization
; 0000 0020     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0021     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0022     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0023     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0024 
; 0000 0025     // Port D initialization
; 0000 0026     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0027     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0028     // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0029     PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 002A 
; 0000 002B     // Timer/Counter 0 initialization
; 0000 002C     // Clock source: System Clock
; 0000 002D     // Clock value: Timer 0 Stopped
; 0000 002E     // Mode: Normal top=0xFF
; 0000 002F     // OC0 output: Disconnected
; 0000 0030     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0031     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0032     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0033 
; 0000 0034     // Timer/Counter 1 initialization
; 0000 0035     // Clock source: System Clock
; 0000 0036     // Clock value: 1000.000 kHz
; 0000 0037     // Mode: Normal top=0xFFFF
; 0000 0038     // OC1A output: Disconnected
; 0000 0039     // OC1B output: Disconnected
; 0000 003A     // Noise Canceler: Off
; 0000 003B     // Input Capture on Falling Edge
; 0000 003C     // Timer Period: 65.536 ms
; 0000 003D     // Timer1 Overflow Interrupt: On
; 0000 003E     // Input Capture Interrupt: Off
; 0000 003F     // Compare A Match Interrupt: Off
; 0000 0040     // Compare B Match Interrupt: Off
; 0000 0041     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0042     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0043     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0044     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0045     ICR1H=0x00;
	OUT  0x27,R30
; 0000 0046     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0047     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0048     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0049     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 004A     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 004B 
; 0000 004C     // Timer/Counter 2 initialization
; 0000 004D     // Clock source: System Clock
; 0000 004E     // Clock value: Timer2 Stopped
; 0000 004F     // Mode: Normal top=0xFF
; 0000 0050     // OC2 output: Disconnected
; 0000 0051     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0052     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0053     TCNT2=0x00;
	OUT  0x24,R30
; 0000 0054     OCR2=0x00;
	OUT  0x23,R30
; 0000 0055 
; 0000 0056     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0057     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0058 
; 0000 0059     // External Interrupt(s) initialization
; 0000 005A     // INT0: Off
; 0000 005B     // INT1: Off
; 0000 005C     // INT2: Off
; 0000 005D     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 005E     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 005F 
; 0000 0060     // USART initialization
; 0000 0061     // USART disabled
; 0000 0062     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0063 
; 0000 0064     // Analog Comparator initialization
; 0000 0065     // Analog Comparator: Off
; 0000 0066     // The Analog Comparator's positive input is
; 0000 0067     // connected to the AIN0 pin
; 0000 0068     // The Analog Comparator's negative input is
; 0000 0069     // connected to the AIN1 pin
; 0000 006A     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 006B     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 006C 
; 0000 006D     // ADC initialization
; 0000 006E     // ADC disabled
; 0000 006F     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0070 
; 0000 0071     // SPI initialization
; 0000 0072     // SPI disabled
; 0000 0073     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0074 
; 0000 0075     // TWI initialization
; 0000 0076     // TWI disabled
; 0000 0077     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0078 
; 0000 0079     // Global enable interrupts
; 0000 007A     #asm("sei")    }
	sei
; 0000 007B     while(1){
_0xE:
; 0000 007C         if(!PIND.7)ki=1;
	SBIC 0x10,7
	RJMP _0x11
	SET
	BLD  R2,0
; 0000 007D             else{ki=0;
	RJMP _0x12
_0x11:
	CLT
	BLD  R2,0
; 0000 007E             if(cntki<1000&&cntki>50&&state){
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRSH _0x14
	RCALL SUBOPT_0x0
	SBIW R26,51
	BRLO _0x14
	SBRC R2,1
	RJMP _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 007F                 PORTD.0=!PORTD.0;
	SBIS 0x12,0
	RJMP _0x16
	CBI  0x12,0
	RJMP _0x17
_0x16:
	SBI  0x12,0
_0x17:
; 0000 0080                 cntki=0;
	RJMP _0x39
; 0000 0081             }else if(cntki>1000){
_0x13:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLO _0x19
; 0000 0082                 state=!state;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 0083                 PORTD.1=!PORTD.1;
	SBIS 0x12,1
	RJMP _0x1A
	CBI  0x12,1
	RJMP _0x1B
_0x1A:
	SBI  0x12,1
_0x1B:
; 0000 0084                 cntki=0;
_0x39:
	LDI  R30,LOW(0)
	STS  _cntki,R30
	STS  _cntki+1,R30
; 0000 0085             }
; 0000 0086         }
_0x19:
_0x12:
; 0000 0087         /*----------------------------------------------------------(led)----------------------------------------------- ...
; 0000 0088         if(cnt2==1)PORTA=0B00000001;
=======
; 0000 000C void main(void){
_main:
; .FSTART _main
; 0000 000D     {
; 0000 000E     // Declare your local variables here
; 0000 000F 
; 0000 0010     // Input/Output Ports initialization
; 0000 0011     // Port A initialization
; 0000 0012     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0013     DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0014     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0015     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0016 
; 0000 0017     // Port B initialization
; 0000 0018     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0019     DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 001A     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 001B     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 001C 
; 0000 001D     // Port C initialization
; 0000 001E     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 001F     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0020     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0021     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0022 
; 0000 0023     // Port D initialization
; 0000 0024     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0025     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0026     // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0027     PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 0028 
; 0000 0029     // Timer/Counter 0 initialization
; 0000 002A     // Clock source: System Clock
; 0000 002B     // Clock value: Timer 0 Stopped
; 0000 002C     // Mode: Normal top=0xFF
; 0000 002D     // OC0 output: Disconnected
; 0000 002E     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 002F     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0030     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0031 
; 0000 0032     // Timer/Counter 1 initialization
; 0000 0033     // Clock source: System Clock
; 0000 0034     // Clock value: 1000.000 kHz
; 0000 0035     // Mode: Normal top=0xFFFF
; 0000 0036     // OC1A output: Disconnected
; 0000 0037     // OC1B output: Disconnected
; 0000 0038     // Noise Canceler: Off
; 0000 0039     // Input Capture on Falling Edge
; 0000 003A     // Timer Period: 65.536 ms
; 0000 003B     // Timer1 Overflow Interrupt: On
; 0000 003C     // Input Capture Interrupt: Off
; 0000 003D     // Compare A Match Interrupt: Off
; 0000 003E     // Compare B Match Interrupt: Off
; 0000 003F     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0040     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0041     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0042     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0043     ICR1H=0x00;
	OUT  0x27,R30
; 0000 0044     ICR1L=0x00;
	OUT  0x26,R30
; 0000 0045     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0046     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0047     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0048     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0049 
; 0000 004A     // Timer/Counter 2 initialization
; 0000 004B     // Clock source: System Clock
; 0000 004C     // Clock value: Timer2 Stopped
; 0000 004D     // Mode: Normal top=0xFF
; 0000 004E     // OC2 output: Disconnected
; 0000 004F     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0050     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0051     TCNT2=0x00;
	OUT  0x24,R30
; 0000 0052     OCR2=0x00;
	OUT  0x23,R30
; 0000 0053 
; 0000 0054     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0055     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0056 
; 0000 0057     // External Interrupt(s) initialization
; 0000 0058     // INT0: Off
; 0000 0059     // INT1: Off
; 0000 005A     // INT2: Off
; 0000 005B     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 005C     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 005D 
; 0000 005E     // USART initialization
; 0000 005F     // USART disabled
; 0000 0060     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0061 
; 0000 0062     // Analog Comparator initialization
; 0000 0063     // Analog Comparator: Off
; 0000 0064     // The Analog Comparator's positive input is
; 0000 0065     // connected to the AIN0 pin
; 0000 0066     // The Analog Comparator's negative input is
; 0000 0067     // connected to the AIN1 pin
; 0000 0068     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0069     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 006A 
; 0000 006B     // ADC initialization
; 0000 006C     // ADC disabled
; 0000 006D     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 006E 
; 0000 006F     // SPI initialization
; 0000 0070     // SPI disabled
; 0000 0071     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0072 
; 0000 0073     // TWI initialization
; 0000 0074     // TWI disabled
; 0000 0075     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0076 
; 0000 0077     // Global enable interrupts
; 0000 0078     #asm("sei")    }
	sei
; 0000 0079     while(1){
_0xD:
; 0000 007A         if(cnt2==1)PORTA=0B00000001;
>>>>>>> Stashed changes
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x1C
	OUT  0x1B,R30
; 0000 0089         if(cnt2==2)PORTA=0B00000010;
_0x1C:
=======
	BRNE _0x10
	OUT  0x1B,R30
; 0000 007B         if(cnt2==2)PORTA=0B00000010;
_0x10:
>>>>>>> Stashed changes
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x1D
	OUT  0x1B,R30
; 0000 008A         if(cnt2==3)PORTA=0B00000100;
_0x1D:
=======
	BRNE _0x11
	OUT  0x1B,R30
; 0000 007C         if(cnt2==3)PORTA=0B00000100;
_0x11:
>>>>>>> Stashed changes
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x1E
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 008B         if(cnt2==4)PORTA=0B00001000;
_0x1E:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1F
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 008C         if(cnt2==5)PORTA=0B00010000;
_0x1F:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x20
	LDI  R30,LOW(16)
	OUT  0x1B,R30
; 0000 008D         if(cnt2==6)PORTA=0B00100000;
_0x20:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x21
	LDI  R30,LOW(32)
	OUT  0x1B,R30
; 0000 008E         if(cnt2==7)PORTA=0B01000000;
_0x21:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x22
	LDI  R30,LOW(64)
	OUT  0x1B,R30
; 0000 008F         if(cnt2==8)PORTA=0B10000000;
_0x22:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x23
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0090         if(cnt2==9)PORTA=0B00000000;
_0x23:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x24
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0091 
; 0000 0092         if(cnt2==10)PORTA=0B10000000;
_0x24:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x25
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0093         if(cnt2==11)PORTA=0B01000000;
_0x25:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x26
	LDI  R30,LOW(64)
	OUT  0x1B,R30
; 0000 0094         if(cnt2==12)PORTA=0B00100000;
_0x26:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x27
	LDI  R30,LOW(32)
	OUT  0x1B,R30
; 0000 0095         if(cnt2==13)PORTA=0B00010000;
_0x27:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x28
	LDI  R30,LOW(16)
	OUT  0x1B,R30
; 0000 0096         if(cnt2==14)PORTA=0B00001000;
_0x28:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x29
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 0097         if(cnt2==15)PORTA=0B00000100;
_0x29:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x2A
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 0098         if(cnt2==16)PORTA=0B00000010;
_0x2A:
=======
	BRNE _0x12
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 007D         if(cnt2==4)PORTA=0B00001000;
_0x12:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x13
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 007E         if(cnt2==5)PORTA=0B00010000;
_0x13:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x14
	LDI  R30,LOW(16)
	OUT  0x1B,R30
; 0000 007F         if(cnt2==6)PORTA=0B00100000;
_0x14:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x15
	LDI  R30,LOW(32)
	OUT  0x1B,R30
; 0000 0080         if(cnt2==7)PORTA=0B01000000;
_0x15:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x16
	LDI  R30,LOW(64)
	OUT  0x1B,R30
; 0000 0081         if(cnt2==8)PORTA=0B10000000;
_0x16:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x17
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0082         if(cnt2==9)PORTA=0B00000000;
_0x17:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x18
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0083 
; 0000 0084         if(cnt2==10)PORTA=0B10000000;
_0x18:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x19
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0085         if(cnt2==11)PORTA=0B01000000;
_0x19:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1A
	LDI  R30,LOW(64)
	OUT  0x1B,R30
; 0000 0086         if(cnt2==12)PORTA=0B00100000;
_0x1A:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1B
	LDI  R30,LOW(32)
	OUT  0x1B,R30
; 0000 0087         if(cnt2==13)PORTA=0B00010000;
_0x1B:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1C
	LDI  R30,LOW(16)
	OUT  0x1B,R30
; 0000 0088         if(cnt2==14)PORTA=0B00001000;
_0x1C:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1D
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 0089         if(cnt2==15)PORTA=0B00000100;
_0x1D:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1E
	LDI  R30,LOW(4)
	OUT  0x1B,R30
; 0000 008A         if(cnt2==16)PORTA=0B00000010;
_0x1E:
>>>>>>> Stashed changes
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x2B
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 0099         if(cnt2==17)PORTA=0B00000001;
_0x2B:
=======
	BRNE _0x1F
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0000 008B         if(cnt2==17)PORTA=0B00000001;
_0x1F:
>>>>>>> Stashed changes
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x2C
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 009A         if(cnt2==18)PORTA=0B00000000;
_0x2C:
=======
	BRNE _0x20
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 008C         if(cnt2==18)PORTA=0B00000000;
_0x20:
>>>>>>> Stashed changes
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x2D
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 009B 
; 0000 009C         if(cnt2==19)PORTA=0B10001000;
_0x2D:
=======
	BRNE _0x21
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008D 
; 0000 008E         if(cnt2==19)PORTA=0B10001000;
_0x21:
>>>>>>> Stashed changes
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x2E
	LDI  R30,LOW(136)
	OUT  0x1B,R30
; 0000 009D         if(cnt2==20)PORTA=0B00100010;
_0x2E:
=======
	BRNE _0x22
	LDI  R30,LOW(136)
	OUT  0x1B,R30
; 0000 008F         if(cnt2==20)PORTA=0B00100010;
_0x22:
>>>>>>> Stashed changes
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x2F
	LDI  R30,LOW(34)
	OUT  0x1B,R30
; 0000 009E         if(cnt2==21)PORTA=0B01000100;
_0x2F:
=======
	BRNE _0x23
	LDI  R30,LOW(34)
	OUT  0x1B,R30
; 0000 0090         if(cnt2==21)PORTA=0B01000100;
_0x23:
>>>>>>> Stashed changes
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x30
	LDI  R30,LOW(68)
	OUT  0x1B,R30
; 0000 009F         if(cnt2==22)PORTA=0B00010001;
_0x30:
=======
	BRNE _0x24
	LDI  R30,LOW(68)
	OUT  0x1B,R30
; 0000 0091         if(cnt2==22)PORTA=0B00010001;
_0x24:
>>>>>>> Stashed changes
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x31
	LDI  R30,LOW(17)
	OUT  0x1B,R30
; 0000 00A0         if(cnt2==23)PORTA=0B10001000;
_0x31:
=======
	BRNE _0x25
	LDI  R30,LOW(17)
	OUT  0x1B,R30
; 0000 0092         if(cnt2==23)PORTA=0B10001000;
_0x25:
>>>>>>> Stashed changes
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x32
	LDI  R30,LOW(136)
	OUT  0x1B,R30
; 0000 00A1         if(cnt2==24)PORTA=0B00100010;
_0x32:
=======
	BRNE _0x26
	LDI  R30,LOW(136)
	OUT  0x1B,R30
; 0000 0093         if(cnt2==24)PORTA=0B00100010;
_0x26:
>>>>>>> Stashed changes
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x33
	LDI  R30,LOW(34)
	OUT  0x1B,R30
; 0000 00A2         if(cnt2==25)PORTA=0B01000100;
_0x33:
=======
	BRNE _0x27
	LDI  R30,LOW(34)
	OUT  0x1B,R30
; 0000 0094         if(cnt2==25)PORTA=0B01000100;
_0x27:
>>>>>>> Stashed changes
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x34
	LDI  R30,LOW(68)
	OUT  0x1B,R30
; 0000 00A3         if(cnt2==26)PORTA=0B00010001;
_0x34:
=======
	BRNE _0x28
	LDI  R30,LOW(68)
	OUT  0x1B,R30
; 0000 0095         if(cnt2==26)PORTA=0B00010001;
_0x28:
>>>>>>> Stashed changes
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x35
	LDI  R30,LOW(17)
	OUT  0x1B,R30
; 0000 00A4         if(cnt2==27)PORTA=0x00;
_0x35:
=======
	BRNE _0x29
	LDI  R30,LOW(17)
	OUT  0x1B,R30
; 0000 0096         if(cnt2==27)PORTA=0x00;
_0x29:
>>>>>>> Stashed changes
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x36
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00A5         if(cnt2==27)cnt2=0;
_0x36:
=======
	BRNE _0x2A
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0097         if(cnt2==27)cnt2=0;
_0x2A:
>>>>>>> Stashed changes
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	CP   R30,R6
	CPC  R31,R7
<<<<<<< Updated upstream
	BRNE _0x37
	CLR  R6
	CLR  R7
; 0000 00A6         }
_0x37:
	RJMP _0xE
; 0000 00A7 }
_0x38:
	RJMP _0x38
; .FEND

	.DSEG
_cntki:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R26,_cntki
	LDS  R27,_cntki+1
	RET

=======
	BRNE _0x2B
	CLR  R6
	CLR  R7
; 0000 0098 
; 0000 0099         }
_0x2B:
	RJMP _0xD
; 0000 009A }
_0x2C:
	RJMP _0x2C
; .FEND

	.CSEG
>>>>>>> Stashed changes

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
