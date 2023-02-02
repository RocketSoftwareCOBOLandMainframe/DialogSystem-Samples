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
       01 Heap-Pos                     PIC 9(9) COMP-5.
       01 Heap-Len                     PIC 9(8) COMP-5.
       01 Heap-Stat.
         03 Heap-Stat-1                PIC X.
         03 Heap-Stat-2                PIC X.

       01 i                            pic x comp-5.
       01 j                            pic x comp-5.

       78  dialog-system               VALUE "DSGRUN".
       01 Display-Error-No             PIC 9(4).
       01 Display-Details-1            PIC 9(4).
       01 Display-Details-2            PIC 9(4).


       COPY "DS-CNTRL.MF".
       COPY "lvdemo.CPB".

       LINKAGE section.
       01 Temp-Data                    PIC X.

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
          MOVE "lvdemo" TO Ds-Set-Name
          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
          EVALUATE Exit-Flag
          WHEN 2
            PERFORM Build-ListView-Data
            CLOSE data-file
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

             PERFORM Determine-Icon

       *>    Column data
             MOVE data-code TO lvData-Column1(i)
             MOVE data-desc TO lvData-Column2(i)
             MOVE Data-Quantity   TO lvData-Column3(i)
             MOVE data-unit-price TO lvData-Column4(i)

             READ data-file NEXT RECORD
             AT END
                EXIT PERFORM
             END-READ
          END-PERFORM

          MOVE i TO lvData-Max
          MOVE "INSERT-MANY-LIST-ITEMS" TO Call-Function
          SET Object-Reference TO LView-01-ObjRef

          CALL "LVIEWCTL" USING Data-Block
          .

      *---------------------------------------------------------------*

       Determine-Icon SECTION.

          *> (If required)
          EVALUATE Data-Code(1:1)
          WHEN "A"
              MOVE 11 TO lvData-Icon(i)
          WHEN "B"
              MOVE 3 TO lvData-Icon(i)
          WHEN "C"
              MOVE 4 TO lvData-Icon(i)
          WHEN "D"
              MOVE 10 TO lvData-Icon(i)
          WHEN "E"
              MOVE 5 TO lvData-Icon(i)
          WHEN "F"
              MOVE 12 TO lvData-Icon(i)
          WHEN "G"
              MOVE 1 TO lvData-Icon(i)
          WHEN "H"
              MOVE 2 TO lvData-Icon(i)
          WHEN "I"
              MOVE 6 TO lvData-Icon(i)
          WHEN "J"
              MOVE 7 TO lvData-Icon(i)
          WHEN "K"
              MOVE 8 TO lvData-Icon(i)
          WHEN "L"
              MOVE 12 TO lvData-Icon(i)
          WHEN OTHER
              MOVE 0 TO lvData-Icon(i)
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
