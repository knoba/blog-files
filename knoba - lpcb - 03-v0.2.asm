;************************************************************************
;************************************************************************
;
;   Filename:           03-v.0.2
;   Date:               30th Nov, 2013
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
;   Description:        Delay loop & rotate. Cylon
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
;	VARIABLE/CONSTANT DEFINITIONS
;************************************************************************

        cblock  0x20
Delay1          ;Assign an address to label Delay1.
Delay2          ;Assign an address to label Delay2.
Display1
Display2
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
        movlw   b'00000001'         ;Copy literal to W register.
        movwf   Display1             ;Copy w register to file register Display.
        movlw   b'00000001'         ;Copy literal to W register.
        movwf   Display2             ;Copy w register to file register Display.
        clrf    Delay1               ;Clear value of Display register on initialisation.
        clrf    Delay2              ;Clear value of Display1 register on initialisation.

;************************************************************************
;	MAIN LOOP
;************************************************************************

main_loop1
        ;LED output cycles for each one lit.
        movf    Display1,w       ;Copy value in Display file register to the w register.
        movwf   PORTC           ;Mask value in W register across all bits of PORTC register.b'00001000'

on_delay_loop1
        ;Delay loop for LED on & off times.
        decfsz  Delay1,f         ;Initial register state b'00000000', decf -1 = 255. Skip if zero = onto 2nd delay.
        goto    on_delay_loop1   ;Go back around.
        decfsz  Delay2,f        ;Initially b'00000000', decf -1 = 255. Skip if zero = onto rotate function.
        goto    on_delay_loop1   ;Go back around.

rotate_right_loop
        ;Rotate bit field right in Display (PORTC).
        bcf     STATUS,C
        rrf     Display1,f
        btfss   PORTC,0
        bsf     Display1,3
        btfss   PORTC,0
        goto    main_loop1


main_loop2
        ;LED output cycles for each one lit.
        movf    Display2,w       ;Copy value in Display file register to the w register.
        movwf   PORTC           ;Mask value in W register across all bits of PORTC register.b'00001000'

on_delay_loop2
        ;Delay loop for LED on & off times.
        decfsz  Delay1,f         ;Initial register state b'00000000', decf -1 = 255. Skip if zero = onto 2nd delay.
        goto    on_delay_loop2   ;Go back around.
        decfsz  Delay2,f        ;Initially b'00000000', decf -1 = 255. Skip if zero = onto rotate function.
        goto    on_delay_loop2   ;Go back around.

rotate_left_loop
        ;Rotate bit field right in Display (PORTC).
        bcf     STATUS,C
        rlf     Display1,f
        btfss   PORTC,0
        bsf     Display1,0
        btfss   PORTC,0
        goto    main_loop1


;************************************************************************
;	END
;************************************************************************

        end                     ; directive 'end of program'



;main
;        movlw   b'00000001'
;        movwf   PORTC
;
;on_delay_loop1
;        decfsz  Delay,f
;        goto    on_delay_loop1
;        decfsz  Delay2,f
;        goto    on_delay_loop1
;        movlw   b'00000010'
;        movwf   PORTC
;
;
;on_delay_loop2
;        decfsz  Delay,f
;        goto    on_delay_loop2
;        decfsz  Delay2,f
;        goto    on_delay_loop2
;        movlw   b'00000100'
;        movwf   PORTC
;
;
;on_delay_loop3
;        decfsz  Delay,f
;        goto    on_delay_loop3
;        decfsz  Delay2,f
;        goto    on_delay_loop3
;        movlw   b'00001000'
;        movwf   PORTC
;
;
;on_delay_loop4
;        decfsz  Delay,f
;        goto    on_delay_loop4
;        decfsz  Delay2,f
;        goto    on_delay_loop4
;        movlw   b'00000100'
;        movwf   PORTC
;
;
;on_delay_loop5
;        decfsz  Delay,f
;        goto    on_delay_loop5
;        decfsz  Delay2,f
;        goto    on_delay_loop5
;        movlw   b'00000010'
;        movwf   PORTC
;
;
;on_delay_loop6
;        decfsz  Delay,f
;        goto    on_delay_loop6
;        decfsz  Delay2,f
;        goto    on_delay_loop6
;        movlw   b'00000001'
;        movwf   PORTC
;
;
;        goto    main
;
;        end

