      ****************************************************************
      * (C) 1993-2024 Rocket Software, Inc. or its affiliates.       *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Rocket Software products and may be used, modified and       *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Rocket Software in     *
      * this material.                                               *
      ****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".
       78  ProgressIndicator           VALUE "PROGCTL".
       01 Prog-Call-Count              pic x comp-5 value 0.
       01 Display-Error-No             PIC 9(4).
       01 Display-Details-1            PIC 9(4).
       01 Display-Details-2            PIC 9(4).

       COPY "DS-CNTRL.MF".
       COPY "prgdemo.CPB".


       PROCEDURE DIVISION.

      *---------------------------------------------------------------*

       Main-Process SECTION.
          PERFORM Program-Initialize
          PERFORM Program-Body UNTIL EXIT-FLAG-TRUE
          PERFORM Program-Terminate
          .

      *---------------------------------------------------------------*

       Program-Initialize SECTION.

          INITIALIZE Ds-Control-Block
          INITIALIZE Data-block

          *> Assume record range is already determined
          MOVE 0 TO StartPoint
          MOVE 9999 TO EndPoint

          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No

          MOVE Ds-New-Set TO Ds-Control
          MOVE "prgdemo" TO Ds-Set-Name

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
          EVALUATE Exit-Flag
          WHEN 2  *> Application processing in a loop
             MOVE 20 TO Numeric-Value
             MOVE "SET-STEP-SIZE" TO Call-Function
             CALL ProgressIndicator USING Data-Block

             MOVE 0 TO Numeric-Value2
             MOVE "STEP" TO Call-Function
             PERFORM VARYING Numeric-Value FROM StartPoint BY 1
             UNTIL Numeric-Value = EndPoint
                  IF Numeric-Value2 = 0
                     *> Read file data, process database etc.
                     CONTINUE
                  ELSE
                     *> Tidy up if necessary...
                     EXIT PERFORM
                  END-IF
                  IF Prog-Call-Count = 20
                     *> call progress indicator every 20 iterations
                     MOVE 0 TO Prog-Call-Count
                     CALL ProgressIndicator USING Data-Block
                  END-IF
                  ADD 1 TO Prog-Call-Count
              END-PERFORM

          WHEN OTHER
             CONTINUE

          END-EVALUATE
          .

      *---------------------------------------------------------------*

       Program-Terminate SECTION.

          STOP RUN
          .

      *---------------------------------------------------------------*

       Call-Dialog-System SECTION.

          CALL dialog-system USING Ds-Control-Block,
                                   Data-Block
          IF NOT Ds-No-Error
              MOVE Ds-Error-Code TO Display-error-no
              DISPLAY "DS ERROR NO:   "  Display-error-no
              DISPLAY "Error Details(1) :   "  Display-Details-1
              DISPLAY "Error Details(2) :   "  Display-Details-2
              PERFORM Program-Terminate
          END-IF
          .
