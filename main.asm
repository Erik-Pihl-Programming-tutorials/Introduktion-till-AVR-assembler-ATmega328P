;********************************************************************************
;* main.asm: Demonstration av enkelt assemblerprogram för mikrodator ATmega328P. 
;*           En lysdiod ansluts till pin 8 (PORTB0) och en tryckknapp ansluts 
;*           till pin 13 (PORTB). Vid nedtryckning av tryckknappen tänds 
;*           lysdioden, annars hålls den släckt.
;*
;*           Noteringar: 
;*              Subrutin är samma som som en funktion.
;*              All data måste lagras i ett CPU-register vid användning.    
;*
;*           Assemblerdirektiv:
;*              .ORG (origin): Används för att specificera en adress.
;*              .EQU (equal): Används för att definiera makron.
;*
;*           Instruktioner:
;*              RJMP (Relative jump)      : Hoppar till angiven adress.
;*              CALL (Call subroutine)    : Anropar subrutin (tänk funktionsanrop).
;*              RET (Return)              : Genomför återhopp från subrutin.
;*              LDI (Load Immediate)      : Läser in konstant i CPU-register.
;*              OUT                       : Skriver till I/O-register.
;*              IN                        : Läser innehåll från I/O-register.
;*              ANDI (And Immediate)      : Bitvis multiplikation med en konstant.
;*              ORI (Or Immediate)        : Bitvis addition med en konstant.
;*              CPI (Compare Immediate)   : Jämför innehållet i ett CPU-register
;*                                          med en konstant.
;*              BRNE (Branch If Not Equal): Hoppar till angiven adress om
;*                                          operanderna i föregående jämförelse
;*                                          inte matchade.
;********************************************************************************

; Makrodefinitioner:
.EQU LED1 = PORTB0    ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU BUTTON1 = PORTB5 ; Tryckknapp 1 ansluten till pin 13 (PORTB5).

;********************************************************************************
;* .CSEG: Kodsegmentet (programminnet). Här lagras programkoden.
;*        Programmet börjar alltid på adress 0x00 i programminnet. I detta
;*        fall hoppar vi till subrutinen main för att starta programmet.
;********************************************************************************
.CSEG
.ORG 0x00    ; Startadress 0x00 - Här börjar programmet.
   RJMP main ; Hoppar till subrutinen main.

;********************************************************************************
;* main: Initierar I/O-portarna vid start. Programmet hålls sedan igång
;*       kontinuerligt så länge matningsspänning tillförs. Vid nedtryckning
;*       av tryckknappen tänds lysdioden, annars hålls den släckt.
;********************************************************************************
main:
   CALL setup               ; Anropar funktionen setup för att initiera I/O-portarna.
main_loop:                  ; Kontinuerlig loop.
   IN R16, PINB             ; Läser insignaler från PINB till CPU-register R16.
   ANDI R16, (1 << BUTTON1) ; Nollställer alla bitar förutom tryckknappens.
   CPI R16, 0x00            ; Jämför kvarvarande värde med 0x00.
   BRNE led1_on             ; Om värdet ej är noll tänds lysdioden.
   RJMP led1_off            ; Annars släcks lysdioden.

;********************************************************************************
;* led1_on: Tänder lysdiod 1, hoppar sedan tillbaka till loopen i main.
;********************************************************************************
led1_on:
   IN R16, PORTB        ; Läser in data från PORTB.
   ORI R16, (1 << LED1) ; Ettställer lysdiodens bit, övriga bitar opåverkade.
   OUT PORTB, R16       ; Skriver tillbaka det uppdaterade innehållet.
   RJMP main_loop       ; Hoppar tillbaka till loopen i main.

;********************************************************************************
;* led1_off: Släcker lysdiod 1, hoppar sedan tillbaka till loopen i main.
;********************************************************************************
led1_off:
   IN R16, PORTB          ; Läser in data från PORTB.
   ANDI R16, ~(1 << LED1) ; Nollställer lysdiodens bit, övriga bitar opåverkade.
   OUT PORTB, R16         ; Skriver tillbaka det uppdaterade innehållet.
   RJMP main_loop         ; Hoppar tillbaka till loopen i main.

;********************************************************************************
;* setup: Initierar mikrodatorns I/O-portar.
;********************************************************************************
setup:
   LDI R16, (1 << LED1)    ; Läser in (1 << LED1) = 0000 0001 i CPU-register R16.
   OUT DDRB, R16           ; Skriver innehållet till datariktningsregister DDRB.
   LDI R16, (1 << BUTTON1) ; Läser in (1 << BUTTON1) = 0010 0000 i CPU-register R16.
   OUT PORTB, R16          ; Skriver innehållet till dataregister PORTB.
   RET                     ; Genomför återhopp.

