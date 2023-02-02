      $set ans85 comp
       IDENTIFICATION DIVISION.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      * File select entries here

       DATA DIVISION.
       FILE SECTION.
      * File FD's here

       WORKING-STORAGE SECTION.
      
      * Name of the program last called is placed in here
           01 Dispatched-Program PIC X(8) VALUE SPACES.       
      
      * Name of the main  program
           01 Main-Program       PIC x(8) VALUE "PROGRAMA".
           
      * Shared area common to all programs (copied
      * into the LINKAGE SECTIONs of other programs
           COPY "ROUTER.CPY".

       LINKAGE SECTION.

       PROCEDURE DIVISION.

       Main-Section.
       
      *    Make sure we don't exit straight away
           INITIALIZE Exit-Flag
       
      *    Start by calling the main program
           MOVE Main-Program TO Program-Name
       
      *    Call program in Program-Name until exit is requested
           PERFORM UNTIL Exit-On-Return
       
      *        Remember who we've called
               MOVE Program-Name TO Dispatched-Program
       
      *        Dispatch program in Program-Name
               CALL Program-Name USING Program-Control
               IF Cancel-On-Return
      *            If last program requested cancel - do cancel
                   SET Cancel-On-Return TO FALSE
                   CANCEL Dispatched-Program
                   IF Dispatched-Program NOT = Main-Program
      *                Re-load main program if sub-program cancelled
                       MOVE Main-Program TO Program-Name 
                   ELSE 
      *                If main program requested cancel, request exit
		       SET Exit-On-Return TO TRUE
                   END-IF           
               END-IF
           END-PERFORM

           STOP RUN.
