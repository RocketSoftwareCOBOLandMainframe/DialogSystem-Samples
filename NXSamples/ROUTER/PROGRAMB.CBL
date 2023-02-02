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

           COPY "DS-CNTRL.MF".
           COPY "PROGRAMB.CPB".
           COPY "DSSYSINF.CPY".

      *    Flags specific to this program           
           01 Program-Flags   PIC 9(2) COMP-5 VALUE 1.
              88 New-Instance VALUE 1 FALSE 0.    

      *    Our name - checked to see if we should be active
           01 This-Program-Name PIC X(8) VALUE "PROGRAMB". 
           
       LINKAGE SECTION.

      *    Common linkage area - controls dispatching
           COPY "ROUTER.CPY".

       PROCEDURE DIVISION USING Program-Control.

       Main-Section.
           IF New-Instance
      *    First time in we push a new screenset onto the stack	        
	        PERFORM New-Set-Instance
           ELSE
      *    Once we've initialized use existing screenset
                PERFORM Use-Set-Instance
           END-IF
      *    Call Dialog System as long as we should be active
           PERFORM UNTIL Program-Name NOT = This-Program-Name
		PERFORM Call-DS
           EXIT PROGRAM.

       New-Set-Instance.
      *    Make sure we don't create a new instance again
           SET New-Instance TO FALSE
      *    Standard DS initialization 
           INITIALIZE ProgramB-Data-Block
           INITIALIZE DS-Control-Block
           MOVE ProgramB-Data-Block-Version-No TO
                   DS-Data-Block-Version-No
           MOVE ProgramB-Version-No TO
                   DS-Version-No
      *    We need to use DSSYSINF.CPY to track events for other screensets      
           MOVE 3 TO DS-Parameter-Count
      *    Push a new screenset onto the stack
           MOVE DS-PUSH-SET TO DS-CONTROL
           MOVE This-Program-Name TO DS-SET-NAME.
       
       Use-Set-Instance.   
      *    Use existing screenset on the stack
           MOVE DS-USE-SET TO DS-CONTROL
      *    This is what we're called
           MOVE This-Program-Name TO DS-SET-NAME.
       
       Call-DS. 
      *    Standard initialization and call
           INITIALIZE ProgramB-Flags
           CALL "DSRUN" USING DS-Control-Block
                              ProgramB-Data-Block
                              DS-Event-Block
           IF DS-No-Error

               INITIALIZE DS-PROCEDURE
               EVALUATE TRUE
      *    When this Screenset flag is set we tell router to exit
                   WHEN ProgramB-Terminate-True
                       SET Cancel-On-Return TO TRUE
      *    When we get an event for another screenset
      *    The global dialog in PROGRAMB's screenset traps the
      *    OTHER-SCREENSET event, re-stacks the event, sets this flag
      *    and returns to this calling program.
      *    We get hold of the right screenset name from DSSYSINF.CPY
      *    and place its name in Program-Name. This will cause our main loop
      *    to exit back to router and router will run the right application.
      *    Once the right program is running that will call Dialog System
      *    with the right screenset. The event will then be repeated in that
      *    screenset, because we re-stacked it in our global dialog.
                   WHEN ProgramB-Other-Set-True
                       MOVE DS-Event-Screenset-ID TO Program-Name
      *    Its an event for us
                   WHEN OTHER
                       MOVE "HELLO B" TO ProgramB-Field1
               END-EVALUATE

           ELSE
               SET Exit-On-Return TO TRUE
           END-IF.

