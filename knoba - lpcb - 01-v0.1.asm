;************************************************************************
;************************************************************************
;
;   Filename:           01-v.0.1
;   Date:               29th Nov, 2013
;   File Version:       0.1
;   Author:             knoba
;
;***********************************************************************
;
;   Processor:          PIC16F690-I/P
;   Architecture:       Baseline PIC
;   Clock frequency:	4MHz
;   Instruction set:	14-bit
;   Files required:     P16F690.INC
;
;***********************************************************************
;
;   Programmer:         Pickit 2
;   Build environment:  Gnu/Linux Debian Jessie 3.2.0-4-686
;   IDE:                MplabX 1.95
;   Make:               GNU Make 3.81
;   Assembler:          MpasmWin 5.53
;   Linker:             Mplink 4.51
;
;***********************************************************************
;
;   Pin assignments:    
;
;***********************************************************************
;
;   Description:        Hello world!.
;   Notes:              From: Microchip Low Pin Count Demo Board Tutorials.
;
;***********************************************************************
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
;            __                      __
;           /\ \                    /\ \
;           \ \ \/'\     ___     ___\ \ \____     __
;            \ \ , <   /' _ `\  / __`\ \ '__`\  /'__`\
;             \ \ \\`\ /\ \/\ \/\ \L\ \ \ \L\ \/\ \L\.\_
;              \ \_\ \_\ \_\ \_\ \____/\ \_,__/\ \__/.\_\
;               \/_/\/_/\/_/\/_/\/___/  \/___/  \/__/\/_/
;
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
;************************************************************************






;************************************************************************
;	DIRECTIVES
;************************************************************************

        list        p=16F690        ; Defines processor to assembler
        include     <p16f690.inc>   ; Allows assembler to define processor aliases.

;************************************************************************
;	CONFIGURATION
;************************************************************************

        __config    _MCLRE_OFF & _CP_OFF & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _PWRTE_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF

; MCLRE ~ Manual master processor start/stop/reset (pin 8 pulled low).
; CP ~ Sets copy protection mode.
; WDT ~ Sets "Watch Dog Timer" auto reset feature.
; IntRC_OSC ~ Sets internal 4MHz resistor/capacitor oscillator timer.

;************************************************************************
;	MACROS
;************************************************************************

;************************************************************************
;	VARIABLE DEFINITIONS
;************************************************************************

;************************************************************************
;	RC CALIBRATION
;************************************************************************

; Internal RC calibration value is placed at location 0x1FF by Microchip
; as a movlw k, where the k is a literal value.

;************************************************************************
;	RESET VECTOR
;************************************************************************

        org     0

;************************************************************************
;	SUBROUTINE VECTORS
;************************************************************************

;************************************************************************
;	MAIN PROGRAM
;************************************************************************

;************************************************************************
;	PROGRAMMING NOTES
;************************************************************************
;
;|<----------OPCODE---------->|
;Instruction		Address
;
;|<-------------FORMAT-------------->|
;Name	Operation	Target	Source
;
;Label/name
;       operation/instruction/statement/directive/register
;               operand/argument/parameter/target-source
;                               ;Comments.
;
;Label = optional jump-to point.
;	Instruction = operation being performed.
;		Register/address/literal = object of instruction.
;			Comments = purpose of line in program.
;
;For writing assembly language program Microchip Technology has suggested the following guidelines.
;Write instruction mnemonics in lower case. (e.g., movwf)
;Write the special register names, RAM variable names and bit names in upper case. (e.g., PCL, RP0, etc.)
;Write instructions and subroutine labels in mixed case. (e.g., Mainline, LoopTime)
;
;************************************************************************

;************************************************************************
;	INITIALISATION
;************************************************************************

start

        ;Initial starting vector for programming is "Bank 0".

        bsf     STATUS,RP0          ;Select register page 1 (bsf = "bit set f" set bit in defined register to 1 / register (shared) is "bank 0,1,2 & 3" STATUS @ h'03' / bit mask in register is set from BSF as 1 in RP0 = h'05').
        bcf     TRISC,3             ;Make i/o pin TRISC0 an output. Tristate register for i/o. (bcf = "bit clear f" set bit in defined register to 0 / register is "bank 1" TRISC @ h'fe' / bit mask in register is set from BSC as 0 in TRISC0 @ h'00'.
        bcf     STATUS,RP0          ;Back to register page 0 (bcf = "bit clear f" clear bit in defined register to 0 / register (shared) is "bank 0,1,2 & 3" STATUS @ h'03' / bit mask in register is set from BCF as 0 in RP0 = h'05').
;        bcf     PORTC,0             ;Turn off LED @ TRISC0.
        bsf     PORTC,3             ;Turn on LED @ TRISC0.

        goto    $

;************************************************************************
;	MAIN LOOP
;************************************************************************

;************************************************************************
;	END
;************************************************************************

        end                     ; directive 'end of program'



