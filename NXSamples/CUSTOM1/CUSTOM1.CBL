      $SET Ans85
      ******************* IDENTIFICATION DIVISION *********************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. Custom1.

      ******************* ENVIRONMENT DIVISION ************************
       ENVIRONMENT DIVISION.

      *---------------------------------------------------------------*
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT Customer-File ASSIGN "cust.ism"
           ORGANIZATION IS INDEXED
           RECORD KEY IS File-C-Code
           ACCESS IS DYNAMIC
           Lock MODE IS AUTOMATIC.

      ******************* DATA DIVISION *******************************
       DATA DIVISION.

      *---------------------------------------------------------------*
       FILE SECTION.
       FD  Customer-File.
       01  Customer-Record.
           03  File-C-Code             PIC X(5).
           03  File-C-Name             PIC X(15).
           03  File-C-Addr1            PIC X(15).
           03  File-C-Addr2            PIC X(15).
           03  File-C-Addr3            PIC X(15).
           03  File-C-Addr4            PIC X(15).
           03  File-C-Limit            PIC 9(4) COMP.
           03  File-C-Area             PIC X.
           03  File-C-Order.
             78  No-Of-Orders              VALUE 10.
               05  File-C-Order-Entry OCCURS No-Of-Orders.
                   07  File-Ord-No     PIC 9(6).
                   07  File-Ord-Date   PIC 9(6).
                   07  File-Ord-Val    PIC 9(4)V99 COMP.
                   07  File-Pay-Val    PIC 9(4)V99 COMP.

      *---------------------------------------------------------------*
       WORKING-STORAGE SECTION.

       78 Main-SS-Name     VALUE "custom1".
       78 Instance-SS-Name VALUE "custom2".

           COPY "ds-cntrl.mf  ".
           COPY "custom1.cpb ".
           COPY "custom2.cpb ".
           COPY "dssysinf.cpy ".

       01 Instance-Table VALUE ALL X"00".
          03 Group-Record-No           PIC 9(2) COMP-X OCCURS 32.
       01 Group-Index                  PIC 9(2) COMP-X VALUE 0.

       78  Refresh-Text-And-Data-Proc      VALUE "P255".
       78  Dialog-System                   VALUE "dsrun".

       77  Array-Ind                   PIC 9(4) COMP.
       77  Display-Error-No            PIC 9(4).

       01 Main-Screenset-ID            PIC X(8).
       01 Instance-Screenset-ID        PIC X(8).

       01 Temp-Word                    PIC 9(4) COMP-X.
       01 Found-Var                    PIC 9(2) COMP-X.
          88 Not-Found VALUE 0.
          88 Found     VALUE 1.
       01 Data-Store                   PIC X(24) OCCURS 10.
       01 Window-Title.
         03               PIC X(22) VALUE "Change Order Instance".
         03 Win-Inst-No   PIC 99.

       LINKAGE SECTION.
       01 Data-Block-Ptr               PIC X.

       PROCEDURE DIVISION.
       Controlling SECTION.
           PERFORM Program-Initialize
           PERFORM Program-Body UNTIL Customer-Exit-Flg-True
           PERFORM Program-Terminate.
      *---------------------------------------------------------------*
       Program-Initialize SECTION.
           INITIALIZE Ds-Control-Block
           INITIALIZE Customer-Data-Block
           MOVE Customer-Data-Block-Version-No TO
                                         Ds-Data-Block-Version-No
           MOVE Customer-Version-No TO Ds-Version-No
           SET Address OF Data-Block-Ptr
                                    TO Address OF Customer-Data-Block
           OPEN I-O Customer-File
           PERFORM Load-Screenset .
      *---------------------------------------------------------------*
       Program-Body SECTION.
           IF Ds-Exit-Field-True
               PERFORM Derivations
               PERFORM Set-Up-For-Refresh-Screen
           END-IF

           MOVE Data-Block-Ptr(1:2) TO Temp-Word(1:2)
           EVALUATE Temp-Word

               WHEN 1
                  PERFORM Set-Up-For-Ss-Change
                  MOVE X"0000" TO Data-Block-Ptr(1:2)

               WHEN 2
                  PERFORM Poss-Invoke-New-Instance
                  MOVE X"0000" TO Data-Block-Ptr(1:2)

               WHEN 3
                  PERFORM Close-Instance
                  MOVE X"0000" TO Data-Block-Ptr(1:2)

               WHEN 4
                  PERFORM Update-Details
                  MOVE X"0000" TO Data-Block-Ptr(1:2)

               WHEN 5
                  PERFORM Close-All-Instances
                  MOVE X"0000" TO Data-Block-Ptr(1:2)

               WHEN OTHER
                  EVALUATE TRUE
                    WHEN Customer-Del-Flg-True
                        PERFORM Delete-Record
                    WHEN Customer-Load-Flg-True
                        PERFORM Load-Record
                    WHEN Customer-Save-Flg-True
                        PERFORM Save-Record
                    WHEN Customer-Clr-Flg-True
                        PERFORM Clear-Record
                  END-EVALUATE

           END-EVALUATE

           PERFORM Clear-Flags
           PERFORM Call-Dialog-System.

      *---------------------------------------------------------------*
       Program-Terminate SECTION.

           MOVE Ds-Quit-Set TO Ds-Control
           PERFORM Call-Dialog-System
           CLOSE Customer-File
           STOP RUN
       .
      *--------------------------------------------------------------*
       Delete-Record SECTION.

           MOVE Customer-C-Code TO File-C-Code
           DELETE Customer-File
           PERFORM Clear-Record
       .
      *---------------------------------------------------------------*
       Load-Record SECTION.

           INITIALIZE Customer-Record
           MOVE Customer-C-Code TO File-C-Code
           IF File-C-Code NOT = SPACES
               READ Customer-File
                   INVALID KEY
                       INITIALIZE Customer-Data-Block
                       MOVE File-C-Code TO Customer-C-Code
                   NOT INVALID KEY
                       PERFORM Fill-Screen-From-Record
                       PERFORM Derivations
               END-READ
           ELSE
               INITIALIZE Customer-Data-Block
           END-IF
           PERFORM Set-Up-For-Refresh-Screen
       .
      *---------------------------------------------------------------*
       Save-Record SECTION.

           PERFORM Fill-Record-From-Screen
           REWRITE Customer-Record
               INVALID KEY
                   WRITE Customer-Record
               END-WRITE
           END-REWRITE
       .
      *---------------------------------------------------------------*
       Clear-Flags SECTION.

           INITIALIZE Customer-Group-002
       .
      *---------------------------------------------------------------*
       Clear-Record SECTION.

           INITIALIZE Customer-Record
           INITIALIZE Customer-Data-Block
           PERFORM Set-Up-For-Refresh-Screen
       .
      *---------------------------------------------------------------*
       Fill-Record-From-Screen SECTION.

           MOVE Customer-C-Code TO File-C-Code
           MOVE Customer-C-Name TO File-C-Name
           MOVE Customer-C-Addr1 TO File-C-Addr1
           MOVE Customer-C-Addr2 TO File-C-Addr2
           MOVE Customer-C-Addr3 TO File-C-Addr3
           MOVE Customer-C-Addr4 TO File-C-Addr4
           MOVE Customer-C-Limit TO File-C-Limit
           MOVE Customer-C-Area TO File-C-Area
           PERFORM VARYING Array-Ind FROM 1 BY 1
                                          UNTIL Array-Ind > No-Of-Orders
               MOVE Customer-Ord-No(Array-Ind) TO File-Ord-No(Array-Ind)
               MOVE Customer-Ord-Date(Array-Ind) TO
                                           File-Ord-Date(Array-Ind)
               MOVE Customer-Ord-Val(Array-Ind) TO
                                           File-Ord-Val(Array-Ind)
               MOVE Customer-Pay-Val(Array-Ind) TO
                                           File-Pay-Val(Array-Ind)
           END-PERFORM
       .
      *---------------------------------------------------------------*
       Fill-Screen-From-Record SECTION.

           MOVE File-C-Code  TO Customer-C-Code
           MOVE File-C-Name  TO Customer-C-Name
           MOVE File-C-Addr1 TO Customer-C-Addr1
           MOVE File-C-Addr2 TO Customer-C-Addr2
           MOVE File-C-Addr3 TO Customer-C-Addr3
           MOVE File-C-Addr4 TO Customer-C-Addr4
           MOVE File-C-Limit TO Customer-C-Limit
           MOVE File-C-Area  TO Customer-C-Area
           PERFORM VARYING Array-Ind FROM 1 BY 1
                                          UNTIL Array-Ind > No-Of-Orders
               MOVE File-Ord-No(Array-Ind) TO Customer-Ord-No(Array-Ind)
               MOVE File-Ord-Date(Array-Ind) TO
                                           Customer-Ord-Date(Array-Ind)
               MOVE File-Ord-Val(Array-Ind) TO
                                           Customer-Ord-Val(Array-Ind)
               MOVE File-Pay-Val(Array-Ind) TO
                                           Customer-Pay-Val(Array-Ind)
           END-PERFORM
       .
      *---------------------------------------------------------------*
       Set-Up-For-Refresh-Screen SECTION.

           MOVE Refresh-Text-And-Data-Proc TO DS-Procedure
       .
      *---------------------------------------------------------------*
       Derivations SECTION.

           MOVE 0 TO Customer-C-Bal
           PERFORM VARYING Array-Ind
                              FROM 1 BY 1 UNTIL Array-Ind > No-Of-Orders
               COMPUTE Customer-Ord-Bal(Array-Ind) =
                     Customer-Ord-Val(Array-Ind) -
                                           Customer-Pay-Val(Array-Ind)
               ADD Customer-Ord-Bal(Array-Ind) TO Customer-C-Bal
           END-PERFORM
       .
      *---------------------------------------------------------------*
       Load-Screenset SECTION.

           MOVE Ds-New-Set            TO Ds-Control
           MOVE Main-SS-Name          TO Ds-Set-Name
           PERFORM Call-Dialog-System
           MOVE DS-Screenset-ID       TO Main-Screenset-ID
       .
      *---------------------------------------------------------------*


       Call-Dialog-System SECTION.

           CALL Dialog-System USING Ds-Control-Block,
                                    Data-Block-Ptr
                                    Ds-Event-Block

           IF NOT Ds-No-Error
               MOVE Ds-Error-Code TO Display-Error-No
               DISPLAY "DS ERROR NO:   " Display-Error-No
               PERFORM Program-Terminate
           END-IF
       .
      *---------------------------------------------------------------*
       Set-Up-For-Ss-Change SECTION.
      *
          MOVE Ds-Event-Screenset-Id TO Ds-Set-Name
          MOVE Ds-Use-Instance-Set   TO Ds-Control
          MOVE Ds-Event-Screenset-Instance-No TO Ds-Screenset-Instance

          MOVE ReDef-Block TO Data-Store(Group-Index)

          IF Ds-Set-Name = Main-Screenset-ID
             SET Address OF Data-Block-Ptr  TO
                           Address OF Customer-Data-Block
          ELSE
             MOVE Group-Record-No(Ds-Event-Screenset-Instance-No)
                                              TO Group-Index

             MOVE Data-Store(Group-Index) TO Redef-Block
             SET Address OF Data-Block-Ptr TO Address OF Data-Block
          END-IF
       .
      *---------------------------------------------------------------*



       Poss-Invoke-New-Instance SECTION.

          SET Not-Found TO TRUE
          MOVE 0 TO Group-Index
          PERFORM UNTIL Found OR Group-Index = 10
            ADD 1 TO Group-Index
            IF Group-Record-No(Group-Index) = Customer-Index-Of-Interest
              SET Found TO TRUE
            END-IF
          END-PERFORM

          IF Found
             MOVE Ds-Use-Instance-Set   TO Ds-Control
             MOVE Instance-Screenset-ID TO Ds-Set-Name
             MOVE Group-Index           TO Ds-Screenset-Instance
             MOVE Group-Record-No(Ds-Screenset-Instance)
                                              TO Group-Index

             MOVE "SHOW-YOURSELF"       TO Ds-Procedure
             MOVE Customer-Group-001-Item(Group-Index) TO Redef-Block
             SET Address OF Data-Block-Ptr TO Address OF Data-Block

          ELSE

             MOVE Ds-Push-Set           TO Ds-Control
             MOVE Instance-SS-Name      TO Ds-Set-Name
             MOVE Data-Block-Version-No TO Ds-Data-Block-Version-No
             MOVE Version-No            TO Ds-Version-No
             MOVE Ds-Screen-Noclear     TO Ds-Control-Param

             MOVE Customer-Index-Of-Interest TO Win-Inst-No
             MOVE Window-Title          TO Window-Name
             MOVE 1                     TO Ds-Clear-Dialog
             MOVE "INIT-PROC"           TO Ds-Procedure
             MOVE Customer-Index-Of-Interest  TO Group-Index
             MOVE Customer-Group-001-Item(Group-Index) TO Redef-Block
             SET Address OF Data-Block-Ptr TO Address OF Data-Block
             PERFORM Call-Dialog-System
             MOVE DS-Screenset-ID TO Instance-Screenset-ID
             MOVE Group-Index TO Group-Record-No(Ds-Screenset-Instance)
          END-IF
       .
      *---------------------------------------------------------------*
       Close-Instance SECTION.

          MOVE 0 TO Group-Record-No(Ds-Screenset-Instance)
       .
      *---------------------------------------------------------------*
       Update-Details SECTION.

          MOVE Group-Record-No(Ds-Screenset-Instance) TO Group-Index
          MOVE Group-Index  TO Customer-Index-Of-Interest
          MOVE Redef-Block  TO Customer-Group-001-Item(Group-Index)

          MOVE 0            TO Group-Record-No(Ds-Screenset-Instance)

          PERFORM Derivations
          MOVE Ds-Use-Set            TO Ds-Control
          MOVE Main-Screenset-ID     TO Ds-Set-Name
          MOVE "REFRESH-PROC"        TO Ds-Procedure

          SET Address OF Data-Block-Ptr TO
                        Address OF Customer-Data-Block
       .

      *---------------------------------------------------------------*
       Close-All-Instances SECTION.
      *
          MOVE 0 TO Group-Index
          PERFORM 10 TIMES

             ADD 1 TO Group-Index
             IF Group-Record-No(Group-Index) NOT = 0
                MOVE Instance-Screenset-ID TO Ds-Set-Name
                MOVE Group-Index           TO Ds-Screenset-Instance
                MOVE Ds-Use-Instance-Set   TO Ds-Control
                MOVE "TERMINATE-PROC"      TO DS-Procedure
                PERFORM Call-Dialog-System
                MOVE 0 TO Group-Record-No(Group-Index)
             END-IF

          END-PERFORM

          SET Address OF Data-Block-Ptr  TO
                        Address OF Customer-Data-Block
       .

      *****************************************************************
