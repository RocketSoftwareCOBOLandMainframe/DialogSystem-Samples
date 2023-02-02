      ****************************************************************
      * Copyright (C) 1993-2003 Micro Focus International Limited.   *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Micro Focus products and may be used, modified and           *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Micro Focus in this    *
      * material.                                                    *
      ****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".
       01 Display-Error-No             PIC 9(4).
       01 Display-Details-1            PIC 9(4).
       01 Display-Details-2            PIC 9(4).

       COPY "DS-CNTRL.MF".
       COPY "iedemo.CPB".
       01 flags                        PIC X(4) COMP-5 VALUE 0.
       01 i                            PIC X(2) COMP-5.
       78 HTMLPage                     VALUE "\app_navigate.htm".

       PROCEDURE DIVISION.

      *---------------------------------------------------------------*

       Main-Process SECTION.
          PERFORM Program-Initialize
          PERFORM Program-Body UNTIL EXIT-FLAG-TRUE
          PERFORM Program-Terminate
          .

      *---------------------------------------------------------------*

       Program-Initialize SECTION.

          INITIALIZE Ds-Control-Block
          INITIALIZE Data-block
          MOVE Data-block-version-no
                                   TO Ds-Data-Block-Version-No
          MOVE Version-no TO Ds-Version-No

          MOVE Ds-New-Set TO Ds-Control
          MOVE "iedemo" TO Ds-Set-Name

          *> Get the directory where the HTML page is stored, here its
          *> in the current directory.
          CALL "CBL_GET_CURRENT_DIR" USING BY VALUE flags
                        BY VALUE LENGTH OF URL SIZE 4
                              BY REFERENCE URL

          *> Now add the page name wanted, & strip off any quotes
          PERFORM VARYING i FROM LENGTH OF URL BY -1
          UNTIL URL(i:1) NOT = SPACE OR i = 0
             CONTINUE
          END-PERFORM

          IF URL(i:1) = '"'
             MOVE URL(2:i) TO URL
             SUBTRACT 1 FROM i
          ELSE
             ADD 1 TO i
          END-IF
          MOVE HTMLPage TO URL(i:LENGTH OF HTMLPage)
          .

      *---------------------------------------------------------------*

       Program-Body SECTION.

          PERFORM Call-Dialog-System
          .

      *---------------------------------------------------------------*

       Program-Terminate SECTION.

          STOP RUN
          .

      *---------------------------------------------------------------*

       Call-Dialog-System SECTION.

          CALL dialog-system USING Ds-Control-Block,
                                   Data-Block
          IF NOT Ds-No-Error
              MOVE Ds-Error-Code TO Display-error-no
              DISPLAY "DS ERROR NO:   "  Display-error-no
              DISPLAY "Error Details(1) :   "  Display-Details-1
              DISPLAY "Error Details(2) :   "  Display-Details-2
              PERFORM Program-Terminate
          END-IF
          .
