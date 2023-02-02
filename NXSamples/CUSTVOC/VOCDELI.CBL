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

           MOVE 0  TO VOC-ORD-NO(VOC-DOLLAR-REGISTER)    
                      VOC-ORD-DATE(VOC-DOLLAR-REGISTER)   
                      VOC-ORD-VAL(VOC-DOLLAR-REGISTER)   
                      VOC-PAY-VAL(VOC-DOLLAR-REGISTER)   
                      VOC-ORD-BAL(VOC-DOLLAR-REGISTER).

           PERFORM derivations

           REFRESH-OBJECT ORDER-BOX
           REFRESH-OBJECT TOTAL

           goback.

      **************************************************
      *                                                *
      *                                                *
      *                                                *
      **************************************************

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
