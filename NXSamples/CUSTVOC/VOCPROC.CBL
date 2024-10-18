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

           SET-LIST-ITEM-STATE ORDER-BOX 1 1
           REFRESH-OBJECT DIALOG-BOX
           SET-FOCUS DIALOG-BOX
           
           goback.
