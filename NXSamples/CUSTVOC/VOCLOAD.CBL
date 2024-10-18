      $SET ans85 mfoo
      ****************************************************************
      *                                                              *
      * A version of CUSTOMER.CBL written to use the                 *
      * Dialog Vocabulary, as much as possible                       *
      *                                                              *
      * (C) 1993-2024 Rocket Software, Inc. or its affiliates.       *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Rocket Software products and may be used, modified and       *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Rocket Software in     *
      * this material.                                               *
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

           COPY "custvoc.cpy".

       77  array-ind                   PIC 9(4) COMP.

       LINKAGE SECTION.
	    COPY "ds-call.cpy".
           COPY "custvoc.cpb".

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Procedure division using dsc-control-block, voc-data-block.

           INITIALIZE customer-record

           MOVE VOC-c-code        TO file-c-code
           IF  file-c-code NOT = SPACES
               READ customer-file
                   INVALID KEY
                       INITIALIZE VOC-data-block
                       MOVE file-c-code    TO VOC-c-code
                   NOT INVALID KEY
                       PERFORM Fill-Screen-From-Record
                       PERFORM Derivations
               END-READ
           ELSE
               INITIALIZE VOC-data-block
           END-IF

           REFRESH-OBJECT MAIN-WINDOW

           EVALUATE VOC-C-AREA
           WHEN "N"
               SET-BUTTON-STATE PB-NORTH 1
           WHEN "S"
               SET-BUTTON-STATE PB-SOUTH 1
           WHEN "E"
               SET-BUTTON-STATE PB-EAST 1
           WHEN "W"
               SET-BUTTON-STATE PB-WEST 1
           END-EVALUATE

           goback.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Fill-Screen-From-Record SECTION.

           MOVE file-c-code  TO VOC-c-code
           MOVE file-c-name  TO VOC-c-name
           MOVE file-c-addr1 TO VOC-c-addr1
           MOVE file-c-addr2 TO VOC-c-addr2
           MOVE file-c-addr3 TO VOC-c-addr3
           MOVE file-c-addr4 TO VOC-c-addr4
           MOVE file-c-limit TO VOC-c-limit
           MOVE file-c-area  TO VOC-c-area
           PERFORM VARYING Array-Ind FROM 1 BY 1
                                          UNTIL array-ind > no-of-orders
               MOVE file-ord-no(array-ind) TO VOC-ord-no(array-ind)
               MOVE file-ord-date(array-ind) TO
                                           VOC-ord-date(array-ind)
               MOVE file-ord-val(array-ind) TO
                                           VOC-ord-val(array-ind)
               MOVE file-pay-val(array-ind) TO
                                           VOC-pay-val(array-ind)
           END-PERFORM.
           EXIT.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       Derivations SECTION.

           MOVE 0 TO VOC-c-bal
           PERFORM VARYING Array-Ind
               FROM 1 BY 1 UNTIL array-ind > no-of-orders
               COMPUTE VOC-ord-bal(array-ind) =
                     VOC-ord-val(array-ind) -
                                           VOC-pay-val(array-ind)
               ADD VOC-ord-bal(array-ind) TO VOC-c-bal
           END-PERFORM.
           EXIT.
