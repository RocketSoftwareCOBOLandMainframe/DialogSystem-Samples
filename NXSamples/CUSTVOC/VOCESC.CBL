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


       ID DIVISION.

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

           DELETE-WINDOW CHANGE-ORDER SYS-NULL
           SET-FOCUS DIALOG-BOX
           GOBACK.
