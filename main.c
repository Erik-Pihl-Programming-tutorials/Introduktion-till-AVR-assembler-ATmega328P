/********************************************************************************
* main.c: Demonstration av enkelt C-program f�r att demonstrera motsvarande
*         assemblerkod. En lysdiod ansluts till pin 8 (PORTB0) och en
*         tryckknapp ansluts till pin 13 (PORTB). Vid nedtryckning av 
*         tryckknappen t�nds lysdioden, annars h�lls den sl�ckt.
********************************************************************************/
#include <avr/io.h> 

/* Makrodefinitioner: */
#define LED1 PORTB0    /* Lysdiod 1 ansluten till pin 8 (PORTB0). */
#define BUTTON1 PORTB5 /* Tryckknapp 1 ansluten till pin 13 (PORTB5). */

#define LED1_ON PORTB |= (1 << LED1)               /* T�nder lysdiod 1. */
#define LED1_OFF PORTB &= ~(1 << LED1)             /* Sl�cker lysdiod 1. */
#define BUTTON1_IS_PRESSED (PINB & (1 << BUTTON1)) /* Indikerar nedtryckning. */

/********************************************************************************
* setup: Initierar mikrodatorns I/O-portar.
********************************************************************************/
static inline void setup(void)
{
   DDRB = (1 << LED1);
   PORTB = (1 << BUTTON1);
   return;
}

/********************************************************************************
* main: Initierar I/O-portarna vid start. Programmet h�lls ig�ng kontinuerligt
*       s� l�nge matningssp�nning tillf�rs. Om tryckknappen trycks ned t�nds
*       lysdioden, annars h�lls den sl�ckt.
********************************************************************************/
int main(void)
{
   setup();

   while (1)
   {
      if (BUTTON1_IS_PRESSED)
      {
         LED1_ON;
      }
      else
      {
         LED1_OFF;
      }
   }

   return 0;
}

