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

       WORKING-STORAGE SECTION.

           COPY "custvoc.cpy".

       78  no-of-orders                VALUE 10.

       77  array-ind                   PIC 9(4) COMP.

       LINKAGE SECTION.
	    COPY "ds-call.cpy".
           COPY "custvoc.cpb".

      ****************************************************
      *                                                  *
      *                                                  *
      *                                                  *
      ****************************************************

       PROCEDURE DIVISION Using Dsc-Control-Block, Voc-Data-Block.

           MOVE VOC-C-ORD-NO   TO VOC-ORD-NO(VOC-DOLLAR-REGISTER)
           MOVE VOC-C-ORD-DT   TO VOC-ORD-DATE(VOC-DOLLAR-REGISTER)
           MOVE VOC-C-PAY-VL   TO VOC-PAY-VAL(VOC-DOLLAR-REGISTER)
           MOVE VOC-C-ORD-VL   TO VOC-ORD-VAL(VOC-DOLLAR-REGISTER)

           PERFORM Derivations

           REFRESH-OBJECT ORDER-BOX
           REFRESH-OBJECT TOTAL
           DELETE-WINDOW CHANGE-ORDER SYS-NULL
           SET-FOCUS DIALOG-BOX

           goback.


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
