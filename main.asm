;********************************************************************************
;* main.asm: Demonstration av enkelt assemblerprogram f�r mikrodator ATmega328P. 
;*           En lysdiod ansluts till pin 8 (PORTB0) och en tryckknapp ansluts 
;*           till pin 13 (PORTB). Vid nedtryckning av tryckknappen t�nds 
;*           lysdioden, annars h�lls den sl�ckt.
;*
;*           Noteringar: 
;*              Subrutin �r samma som som en funktion.
;*              All data m�ste lagras i ett CPU-register vid anv�ndning.    
;*
;*           Assemblerdirektiv:
;*              .ORG (origin): Anv�nds f�r att specificera en adress.
;*              .EQU (equal): Anv�nds f�r att definiera makron.
;*
;*           Instruktioner:
;*              RJMP (Relative jump)      : Hoppar till angiven adress.
;*              CALL (Call subroutine)    : Anropar subrutin (t�nk funktionsanrop).
;*              RET (Return)              : Genomf�r �terhopp fr�n subrutin.
;*              LDI (Load Immediate)      : L�ser in konstant i CPU-register.
;*              OUT                       : Skriver till I/O-register.
;*              IN                        : L�ser inneh�ll fr�n I/O-register.
;*              ANDI (And Immediate)      : Bitvis multiplikation med en konstant.
;*              ORI (Or Immediate)        : Bitvis addition med en konstant.
;*              CPI (Compare Immediate)   : J�mf�r inneh�llet i ett CPU-register
;*                                          med en konstant.
;*              BRNE (Branch If Not Equal): Hoppar till angiven adress om
;*                                          operanderna i f�reg�ende j�mf�relse
;*                                          inte matchade.
;********************************************************************************

; Makrodefinitioner:
.EQU LED1 = PORTB0    ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU BUTTON1 = PORTB5 ; Tryckknapp 1 ansluten till pin 13 (PORTB5).

;********************************************************************************
;* .CSEG: Kodsegmentet (programminnet). H�r lagras programkoden.
;*        Programmet b�rjar alltid p� adress 0x00 i programminnet. I detta
;*        fall hoppar vi till subrutinen main f�r att starta programmet.
;********************************************************************************
.CSEG
.ORG 0x00    ; Startadress 0x00 - H�r b�rjar programmet.
   RJMP main ; Hoppar till subrutinen main.

;********************************************************************************
;* main: Initierar I/O-portarna vid start. Programmet h�lls sedan ig�ng
;*       kontinuerligt s� l�nge matningssp�nning tillf�rs. Vid nedtryckning
;*       av tryckknappen t�nds lysdioden, annars h�lls den sl�ckt.
;********************************************************************************
main:
   CALL setup               ; Anropar funktionen setup f�r att initiera I/O-portarna.
main_loop:                  ; Kontinuerlig loop.
   IN R16, PINB             ; L�ser insignaler fr�n PINB till CPU-register R16.
   ANDI R16, (1 << BUTTON1) ; Nollst�ller alla bitar f�rutom tryckknappens.
   CPI R16, 0x00            ; J�mf�r kvarvarande v�rde med 0x00.
   BRNE led1_on             ; Om v�rdet ej �r noll t�nds lysdioden.
   RJMP led1_off            ; Annars sl�cks lysdioden.

;********************************************************************************
;* led1_on: T�nder lysdiod 1, hoppar sedan tillbaka till loopen i main.
;********************************************************************************
led1_on:
   IN R16, PORTB        ; L�ser in data fr�n PORTB.
   ORI R16, (1 << LED1) ; Ettst�ller lysdiodens bit, �vriga bitar op�verkade.
   OUT PORTB, R16       ; Skriver tillbaka det uppdaterade inneh�llet.
   RJMP main_loop       ; Hoppar tillbaka till loopen i main.

;********************************************************************************
;* led1_off: Sl�cker lysdiod 1, hoppar sedan tillbaka till loopen i main.
;********************************************************************************
led1_off:
   IN R16, PORTB          ; L�ser in data fr�n PORTB.
   ANDI R16, ~(1 << LED1) ; Nollst�ller lysdiodens bit, �vriga bitar op�verkade.
   OUT PORTB, R16         ; Skriver tillbaka det uppdaterade inneh�llet.
   RJMP main_loop         ; Hoppar tillbaka till loopen i main.

;********************************************************************************
;* setup: Initierar mikrodatorns I/O-portar.
;********************************************************************************
setup:
   LDI R16, (1 << LED1)    ; L�ser in (1 << LED1) = 0000 0001 i CPU-register R16.
   OUT DDRB, R16           ; Skriver inneh�llet till datariktningsregister DDRB.
   LDI R16, (1 << BUTTON1) ; L�ser in (1 << BUTTON1) = 0010 0000 i CPU-register R16.
   OUT PORTB, R16          ; Skriver inneh�llet till dataregister PORTB.
   RET                     ; Genomf�r �terhopp.

