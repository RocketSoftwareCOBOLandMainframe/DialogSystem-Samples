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

           MOVE VOC-ORD-NO(VOC-DOLLAR-REGISTER)    
               TO VOC-C-ORD-NO
           MOVE VOC-ORD-VAL(VOC-DOLLAR-REGISTER)   
               TO VOC-C-ORD-VL
           MOVE VOC-PAY-VAL(VOC-DOLLAR-REGISTER)   
               TO VOC-C-PAY-VL
           MOVE VOC-ORD-DATE(VOC-DOLLAR-REGISTER)  
               TO VOC-C-ORD-DT

           REFRESH-OBJECT CHANGE-ORDER
           SET-FOCUS CHANGE-ORDER

           goback.
