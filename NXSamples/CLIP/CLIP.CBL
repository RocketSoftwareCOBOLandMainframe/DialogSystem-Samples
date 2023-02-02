      $SET ANS85 NOIBMCOMP MF
      ******************************************************************
      **
      ** DS DEMO CLIP
      **
      ******************************************************************

       78 Dsrun                         VALUE "dsrun".
       78 Panels2                       VALUE "PANELS2".
       78 Big-Number                    VALUE  65534.

       78 Cut-Func                      VALUE  1.
       78 Copy-Func                     VALUE  2.
       78 Paste-Func                    VALUE  3.
       78 Exit-Func                     VALUE  4.
       78 Scroll-Func                   VALUE  5.

      ******************************************************************

       Copy "ds-cntrl.mf".
       Copy "pan2link.cpy".
       Copy "clip.cpb".

      ******************************************************************

       01                                   VALUE X"000305070A0D10131A".
         03 Offset             PIC X COMP-X OCCURS 9.

       01 Generic-Character-Y  PIC X COMP-X VALUE 64.
       01 Clipboard-Was-Empty  Pic 9 Value 1.

      ******************************************************************

       01 Clip-Buffer                   PIC X(Big-Number).

      ******************************************************************

       01 Message-Box-Details REDEFINES Clip-Buffer.
         03 Message-Box-Heading         PIC X(15).
         03 Message-Box-Text.
           05 MBT-1                     PIC X(17).
           05 MBT-Error                 PIC 9999.
           05 MBT-2                     PIC X(25).
           05 MBT-Function              PIC 9999.
           05 MBT-3                     PIC X.

       78 MBH  VALUE "Panels2 Error".
       78 MBT1 VALUE "A Panels2 Error".
       78 MBT2 VALUE " has occured on function".
       78 MBT3 VALUE ".".

      ******************************************************************

       PROCEDURE DIVISION.
           PERFORM Initialise-Ds-P2
           PERFORM UNTIL DS-Function = Exit-Func
               PERFORM Call-Dialog-System
               EVALUATE DS-Function
                   WHEN Cut-Func    PERFORM DS-Cut
                   WHEN Copy-Func   PERFORM DS-Copy
                   WHEN Paste-Func  PERFORM DS-Paste
                   WHEN Exit-Func   CONTINUE
                   WHEN Scroll-Func PERFORM DS-Scroll-Window
               END-EVALUATE
           END-PERFORM
           EXIT PROGRAM
           STOP RUN
           .

      ******************************************************************

       Initialise-Ds-P2 SECTION.
           INITIALIZE Ds-Control-Block
           INITIALIZE Data-Block
           MOVE Ds-New-Set            TO Ds-Control
           MOVE "clip"                TO Ds-Set-Name
           MOVE 4                     TO Ds-Set-Name-Length
           MOVE Version-No            TO Ds-Version-No
           MOVE Data-Block-Version-No TO Ds-Data-Block-Version-No
           PERFORM Call-Dialog-System
           MOVE Ds-Session-Id         TO P2-Mf-Reserved
           EXIT
           .

      ******************************************************************

       DS-Copy SECTION.
           MOVE MLE-Handle                  TO P2-Descendant
           PERFORM P2-Get-Entry-Field-Text
           MOVE Pf-Write-Clipboard          TO P2-Function
           MOVE P2G-Entry-Field-Text-Length TO P2C-Clipboard-Text-Length
           PERFORM P2-Write-Clipboard
           EXIT
           .

      ******************************************************************

       DS-Cut SECTION.
           PERFORM DS-Copy
           MOVE 0          TO P2G-Entry-Field-Text-Length
           MOVE MLE-Handle TO P2-Descendant
           PERFORM P2-Set-Entry-Field-Text
           EXIT
           .

      ******************************************************************

       DS-Paste SECTION.
           PERFORM P2-Clipboard-Read
           If (Clipboard-Was-Empty = 0)
              MOVE MLE-Handle                TO P2-Descendant
              MOVE P2C-Clipboard-Text-Length TO 
                   P2G-Entry-Field-Text-Length
              PERFORM P2-Set-Entry-Field-Text
           End-If
           EXIT
           .

      ******************************************************************

       DS-Scroll-Window SECTION.
           MOVE VW-Handle               TO P2-Descendant
           PERFORM P2-Get-Window-Info
           MOVE Offset(Step)            TO P2P-Virtual-Y
           MULTIPLY Generic-Character-Y BY P2P-Virtual-Y
           PERFORM P2-Shift-Window
           EXIT
           .

      ******************************************************************

       Call-Dialog-System SECTION.
           CALL Dsrun  USING Ds-Control-Block
                             Data-Block
           IF Ds-Error-Code NOT = 0
                 DISPLAY "Dsrun error code"
                         Ds-Error-Code        ", "
                         Ds-Error-Details-1   ", "
                         Ds-Error-Details-2
                 STOP RUN
           END-IF
           EXIT
           .

       P2-Clipboard-Read SECTION.
           MOVE CFMT-Text                  TO P2C-Clipboard-Format
           MOVE Pf-Clipboard-Initiate-Read TO P2-Function
           CALL Panels2 USING P2-Parameter-Block
                              P2C-Clipboard-Record
           IF P2-Status = 0
               Move 0 To Clipboard-Was-Empty
               ADD 1                  TO P2C-Clipboard-Text-Length
               MOVE PF-Clipboard-Read TO P2-Function
               CALL Panels2 USING P2-Parameter-Block
                                  P2C-Clipboard-Record
                                  Clip-Buffer
               IF P2-Status NOT = 0
                   PERFORM P2-Error
               END-IF
           ELSE
               Move 1 To Clipboard-Was-Empty
               MOVE "Clipboard is empty"  TO Message-Box-Text
               MOVE MBF-Ok                TO P2X-Message-Box-Flags
               ADD  MBF-MOVEABLE          TO P2X-Message-Box-Flags
               ADD  MBF-CRITICAL          TO P2X-Message-Box-Flags
               MOVE 14                    TO P2X-Heading-Size
               MOVE 18                    TO P2X-Message-Size
               MOVE VW-Handle             TO P2-Ancestor
               MOVE Pf-Invoke-Message-Box TO P2-Function
               CALL Panels2 USING P2-Parameter-Block
                                  P2X-Message-Box-Record
                                  Message-Box-Heading
                                  Message-Box-Text
           END-IF
           EXIT
           .

       P2-Write-Clipboard SECTION.
           MOVE PF-Write-Clipboard TO P2-Function
           MOVE CFMT-Text          TO P2C-Clipboard-Format
           CALL Panels2 USING P2-Parameter-Block
                              P2C-Clipboard-Record
                              Clip-Buffer
           IF P2-Status NOT = 0
               PERFORM P2-Error
           END-IF
           EXIT
           .

       P2-Set-Entry-Field-Text SECTION.
           MOVE PF-Set-Entry-Field-Text   TO P2-Function
           CALL Panels2 USING P2-Parameter-Block
                              P2G-Entry-Field-Record
                              Clip-Buffer
           IF P2-Status NOT = 0
               PERFORM P2-Error
           END-IF
           EXIT
           .

       P2-Get-Entry-Field-Text SECTION.
           MOVE PF-Get-Entry-Field-Text TO P2-Function
           MOVE Big-Number              TO P2G-Entry-Field-Text-Length
           CALL Panels2 USING P2-Parameter-Block
                              P2G-Entry-Field-Record
                              Clip-Buffer
           IF P2-Status NOT = 0
               PERFORM P2-Error
           END-IF
           EXIT
           .

       P2-Get-Window-Info SECTION.
           MOVE PF-Get-Window-Info TO P2-Function
           CALL Panels2 USING P2-Parameter-Block P2P-Parameter-Block
           IF P2-Status NOT = 0
               PERFORM P2-Error
           END-IF
           EXIT
           .

       P2-Shift-Window SECTION.
           MOVE PF-Shift-Window TO P2-Function
           CALL Panels2 USING P2-Parameter-Block P2P-Parameter-Block
           IF P2-Status NOT = 0
               PERFORM P2-Error
           END-IF
           EXIT
           .

       P2-Error SECTION.
           MOVE MBH                   TO Message-Box-Heading
           MOVE MBT1                  TO MBT-1
           MOVE MBT2                  TO MBT-2
           MOVE MBT3                  TO MBT-3
           MOVE P2-Function           TO MBT-Function
           MOVE P2-Status             TO MBT-Error
           MOVE MBF-Ok                TO P2X-Message-Box-Flags
           ADD  MBF-MOVEABLE          TO P2X-Message-Box-Flags
           ADD  MBF-CRITICAL          TO P2X-Message-Box-Flags
           MOVE 14                    TO P2X-Heading-Size
           MOVE 51                    TO P2X-Message-Size
           MOVE VW-Handle             TO P2-Ancestor
           MOVE Pf-Invoke-Message-Box TO P2-Function
           CALL Panels2 USING P2-Parameter-Block
                              P2X-Message-Box-Record
                              Message-Box-Heading
                              Message-Box-Text
           EXIT
           .

      ******************************************************************
