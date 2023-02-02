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

       PROCEDURE DIVISION using DSC-Control-Block, Voc-Data-Block.

           PERFORM Fill-Record-From-Screen
           REWRITE customer-record
               INVALID KEY
                   WRITE customer-record
               END-WRITE
           END-REWRITE.
           goback.

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************


       Fill-Record-From-Screen SECTION.

           MOVE VOC-c-code  TO file-c-code
           MOVE VOC-c-name  TO file-c-name
           MOVE VOC-c-addr1 TO file-c-addr1
           MOVE VOC-c-addr2 TO file-c-addr2
           MOVE VOC-c-addr3 TO file-c-addr3
           MOVE VOC-c-addr4 TO file-c-addr4
           MOVE VOC-c-limit TO file-c-limit
           MOVE VOC-c-area  TO file-c-area
           PERFORM VARYING Array-Ind FROM 1 BY 1
                           UNTIL array-ind > no-of-orders
               MOVE VOC-ord-no(array-ind) TO file-ord-no(array-ind)
               MOVE VOC-ord-date(array-ind) TO
                                           file-ord-date(array-ind)
               MOVE VOC-ord-val(array-ind) TO
                                           file-ord-val(array-ind)
               MOVE VOC-pay-val(array-ind) TO
                                           file-pay-val(array-ind)
           END-PERFORM.
           EXIT.
