      $set remove(object-reference)
      ****************************************************************
      * Copyright (C) 1993-2003 Micro Focus International Limited.   *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Micro Focus products and may be used, modified and           *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Micro Focus in this    *
      * material.                                                    *
      ****************************************************************
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT data-file ASSIGN "inventory.dat"
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS FStatus
           .


       DATA DIVISION.

       FILE SECTION.
       FD  data-file.
       01  data-record.
           03  data-type             PIC X(14).
           03  data-code             PIC X(4).
           03  data-desc             PIC X(30).
           03  data-quantity         PIC X(4).
           03  data-unit-price       PIC X(6).
           03  data-order-price      PIC X(6).

       WORKING-STORAGE SECTION.

       01 FStatus.
         03 FStat1                     PIC 9.
         03 FStat2                     PIC 9.
         88 Status-OK value 0.

       01 i                            pic x(4) comp-5.
       01 j                            pic x(4) comp-5 value 0.
       01 stored-code                  pic x value space.
       01 Item-Status                  PIC 9 value 0.
         88 Found-Item value 1.

       78  dialog-system               VALUE "DSGRUN".
       01 Display-Error-No             PIC 9(4).
       01 Display-Details-1            PIC 9(4).
       01 Display-Details-2            PIC 9(4).
       COPY "DS-CNTRL.MF".
       COPY "Splitter.CPB".


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
          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No

          MOVE Ds-New-Set TO Ds-Control
          MOVE "Splitter" TO Ds-Set-Name

          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
          EVALUATE Exit-Flag
          WHEN 2
            PERFORM Build-ListView-Data
          WHEN 3
            PERFORM Populate-ListView
          WHEN OTHER
            CONTINUE
          END-EVALUATE
          .


      *---------------------------------------------------------------*

       Build-ListView-Data SECTION.

           OPEN INPUT data-file
           READ data-file
           AT END
              MOVE 0 TO Numeric-Value2
              EXIT SECTION
           END-READ

           MOVE 999 TO lvData-Max

           PERFORM VARYING i from 1 BY 1 UNTIL NOT Status-OK
           OR i > lvData-Max

             IF Data-Code(1:1) NOT = Stored-Code
                ADD 1 TO j
                MOVE Data-Type(6:) TO Item-Text(j)
                MOVE 0 TO Item-Parent(j)
                MOVE Data-Code(1:1) TO Stored-Code
             END-IF

             READ data-file NEXT RECORD
             AT END
                EXIT PERFORM
             END-READ
          END-PERFORM

      *>  Tree items (index keys) are inserted here...
          MOVE "INSERT-MANY-ITEMS" TO CALL-Function
          SET Object-Reference TO TView-Object
          MOVE j TO Numeric-Value
          call "tviewCtrl" USING Data-Block

          CLOSE data-file
          .

      *---------------------------------------------------------------*

       Populate-ListView SECTION.

       *>  Re-read the file based on an index (or as here) a sequential
       *>  file based on Data-Type

           OPEN INPUT data-file
           READ data-file
           AT END
              MOVE 0 TO Numeric-Value2
              EXIT SECTION
           END-READ

           MOVE 999 TO lvData-Max

           MOVE 0 TO Item-Status
           MOVE 0 TO j

           PERFORM VARYING i from 1 BY 1 UNTIL NOT Status-OK
           OR i > lvData-Max
             IF Data-Type(6:4) = IO-Text-Buffer(1:4)
                ADD 1 TO j
                SET Found-Item TO TRUE
       *>       Column data
                MOVE data-code TO lvData-Column1(j)
                MOVE data-desc TO lvData-Column2(j)
                MOVE Data-Quantity   TO lvData-Column3(j)
                MOVE data-unit-price TO lvData-Column4(j)
             ELSE
                IF Found-Item
                   EXIT PERFORM
                END-IF
             END-IF

             READ data-file NEXT RECORD
             AT END
                EXIT PERFORM
             END-READ
          END-PERFORM

          MOVE j TO lvData-Max
          MOVE "INSERT-MANY-LIST-ITEMS" TO CALL-Function
          SET Object-Reference TO LView-Object
          call "lviewCtrl" USING Data-Block

          CLOSE data-file

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
