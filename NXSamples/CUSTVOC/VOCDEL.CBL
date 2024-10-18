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

       LINKAGE SECTION.

	    COPY "ds-call.cpy".
           COPY "custvoc.cpb".

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       PROCEDURE DIVISION Using Dsc-Control-Block, Voc-Data-Block.

           MOVE VOC-c-code        TO file-c-code
           DELETE customer-file

           INITIALIZE customer-record
           INITIALIZE VOC-data-block

           SET-BUTTON-STATE PB-NORTH 1
           REFRESH-OBJECT MAIN-WINDOW

           goback.

