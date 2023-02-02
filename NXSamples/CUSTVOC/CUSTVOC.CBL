      $SET ans85 mfoo
      ****************************************************************
      *                                                              *
      * A version of CUSTOMER.CBL written to use the                 *
      * Dialog Vocabulary, as much as possible                       *
      *                                                              *
      * Copyright (C) 1993-2003 Micro Focus International Limited.   *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Micro Focus products and may be used, modified and           *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Micro Focus in this    *
      * material.                                                    *
      *                                                              *
      ****************************************************************

      **************************************************
      *                                                *
      * The vocabulary copybook which must be included *
      * before the main program starts.                *
      *                                                *
      **************************************************

           COPY "dslang.cpy".


       IDENTIFICATION DIVISION.
       PROGRAM-ID. custvoc.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT customer-file ASSIGN "cust.ism"
           ORGANIZATION IS INDEXED
           RECORD KEY IS file-c-code
           ACCESS IS DYNAMIC
           lock MODE IS AUTOMATIC.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       DATA DIVISION.

       FILE SECTION.
       FD  customer-file is external.
       01  customer-record.
           03  file-c-code             PIC X(5).
           03  file-c-name             PIC X(15).
           03  file-c-addr1            PIC X(15).
           03  file-c-addr2            PIC X(15).
           03  file-c-addr3            PIC X(15).
           03  file-c-addr4            PIC X(15).
           03  file-c-limit            PIC 9(4) COMP.
           03  file-c-area             PIC X.
           03  file-c-order.
             78  no-of-orders              VALUE 10.
               05  file-c-order-entry OCCURS no-of-orders.
                   07  file-ord-no     PIC 9(6).
                   07  file-ord-date   PIC 9(6).
                   07  file-ord-val    PIC 9(4)V99 COMP.
                   07  file-pay-val    PIC 9(4)V99 COMP.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       WORKING-STORAGE SECTION.

           COPY "ds-cntrl.mf".
           COPY "custvoc.cpb".
           COPY "custvoc.cpy".

       78  dialog-system                   VALUE "dsrun".

       77  array-ind                   PIC 9(4) COMP.
       77  display-error-no            PIC 9(4).

       77  VAR1                        PIC 9(8) COMP-X.

       LOCAL-STORAGE SECTION.
       01  FILLER                      PIC X.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       PROCEDURE DIVISION.

       Main-Process SECTION.

           PERFORM Program-Initialize

           PERFORM Call-Dialog-System.

           PERFORM Program-Terminate.

           exit.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Program-Initialize SECTION.

           INITIALIZE ds-control-block
           INITIALIZE VOC-data-block
           MOVE VOC-data-block-version-no
               TO ds-data-block-version-no
           MOVE VOC-version-no    TO ds-version-no

           OPEN I-O customer-file

           MOVE ds-new-set TO ds-control
           MOVE "custvoc" TO ds-set-name
           exit.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       init-program section.
       
       ENTRY "Init-Interface".

           SET-BUTTON-STATE PB-NORTH 1
           MOVE "N"                    TO VOC-C-AREA
           SET-FOCUS EF-FIRST-FOCUS

           exit program
           stop run.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Program-Terminate SECTION.

           MOVE ds-quit-set TO ds-control
           PERFORM Call-Dialog-System.

           CLOSE customer-file
           STOP RUN.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Goto-Main-Window SECTION.

       ENTRY "Goto-Main-Window".

           DELETE-WINDOW DIALOG-BOX SYS-NULL
           SET-FOCUS MAIN-WINDOW
           goback.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Call-Dialog-System SECTION.

           CALL dialog-system USING ds-control-block,
                                    VOC-data-block
           END-CALL
           IF  NOT ds-no-error
               DISPLAY "DS ERROR NO:   " DS-ERROR-CODE
               PERFORM Program-Terminate
           END-IF.
           EXIT.
