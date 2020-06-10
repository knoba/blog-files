;************************************************************************
;************************************************************************
;
;   Filename:           02-v.0.2
;   Date:               29th Nov, 2013
;   File Version:       0.2
;   Author:             knoba
;
;***********************************************************************
;
;   Processor:          PIC16F690-I/P
;   Architecture:       Baseline PIC
;   Clock frequency:	4MHz
;   Instruction set:	14-bit
;   Files required:     P16F690.INC
;   Reloc/Abs:          Absolute
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
;   Description:        Delay loop.
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

        cblock  0x20
Delay           ;Assign an address to label Delay.
Delay1          ;Assign an address to label Delay1.
        endc

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
;Some MPASM directives do not allow a label to precede them (like banksel). In these cases put the label on a seperate line before the directive.
;
;As Microchip used UPPERCASE names for special function registers and constants I use the same convention in my code, If I need a register name that is like an existing Microchip definition then I add an underscore to it. For example _WREG is the name I usually use for the WREG save area in my interrupt code. I use so called UpperCamelCase names for labels in contrast to the register names.
;
;************************************************************************

;************************************************************************
;	INITIALISATION
;************************************************************************

start
        ;Program setup.
        ;Initial starting vector for programming is "Bank 0".

        bsf     STATUS,RP0          ;Set bit @ RP0, in status register, to 1 to switch to "bank 1".
        clrf    TRISC               ;Zero all bits in the tristate register. Outputs.
        bcf     STATUS,RP0          ;Set bit @ RP0, in status register, to 0 to switch back to "bank 0".

;************************************************************************
;	MAIN LOOP
;************************************************************************
main_loop
;Led #1
        ;LED turn on.
        bsf     PORTC,0         ;Turn on LED.
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_01
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_01         ;Go back to "loop_01" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_01         ;Go back to "loop_01" and decfsz again.

        ;LED turn off.
        bcf     PORTC,0
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_02
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_02         ;Go back to "loop_02" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_02         ;Go back to "loop_02" and decfsz again.

;Led #2

        ;LED turn on.
        bsf     PORTC,1         ;Turn on LED.
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_03
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_03         ;Go back to "loop_01" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_03         ;Go back to "loop_01" and decfsz again.

        ;LED turn off.
        bcf     PORTC,1
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_04
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_04         ;Go back to "loop_02" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_04         ;Go back to "loop_02" and decfsz again.

;Led #3

        ;LED turn on.
        bsf     PORTC,2         ;Turn on LED.
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_05
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_05         ;Go back to "loop_01" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_05         ;Go back to "loop_01" and decfsz again.

        ;LED turn off.
        bcf     PORTC,2
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_06
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_06         ;Go back to "loop_02" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_06         ;Go back to "loop_02" and decfsz again.

;Led #4

        ;LED turn on.
        bsf     PORTC,3         ;Turn on LED.
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_07
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_07         ;Go back to "loop_01" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_07         ;Go back to "loop_01" and decfsz again.

        ;LED turn off.
        bcf     PORTC,3
        clrf    Delay           ;Zero out variable "Delay".
        clrf    Delay1          ;Zero out variable "Delay1".

loop_08
        ;Long loop.
        decfsz  Delay,f         ;Decrement "Delay" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_08         ;Go back to "loop_02" and decfsz again.
        decfsz  Delay1,f        ;Decrement "Delay1" (.256 = .0) by 1 (.255). Skip when "Delay" = 0.
        goto    loop_08         ;Go back to "loop_02" and decfsz again.

        ;Back to main loop.
        goto    main_loop





;************************************************************************
;	END
;************************************************************************

        end                     ; directive 'end of program'



