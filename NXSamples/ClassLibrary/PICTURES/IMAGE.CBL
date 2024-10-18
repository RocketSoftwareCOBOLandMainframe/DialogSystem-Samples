      ****************************************************************
      * (C) 1993-2024 Rocket Software, Inc. or its affiliates.       *
      * All rights reserved.                                         *
      * This demonstration program is provided for use by users of   *
      * Rocket Software products and may be used, modified and       *
      * distributed as part of your application provided that you    *
      * properly acknowledge the copyright of Rocket Software in     *
      * this material.                                               *
      ****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       78  dialog-system               VALUE "DSGRUN".
       01 Display-Error-No             PIC 9(4).
       01 Display-Details-1            PIC 9(4).
       01 Display-Details-2            PIC 9(4).

       COPY "DS-CNTRL.MF".
       COPY "image.CPB".
       01 flags                        PIC X(4) COMP-5 VALUE 0.
       01 i                            PIC X(2) COMP-5.
       78 InitialImage                 VALUE "\MF_LOGO.GIF".


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
          MOVE "image" TO Ds-Set-Name

          *> Get the directory where the image is stored, here its
          *> in the current directory.
          CALL "CBL_GET_CURRENT_DIR" USING BY VALUE flags
                        BY VALUE LENGTH OF IO-Text-Buffer SIZE 4
                              BY REFERENCE IO-Text-Buffer

          *> Now add the page name wanted, & strip off any quotes
          PERFORM VARYING i FROM LENGTH OF IO-Text-Buffer BY -1
          UNTIL IO-Text-Buffer(i:1) NOT = SPACE OR i = 0
             CONTINUE
          END-PERFORM

          IF IO-Text-Buffer(i:1) NOT = '"'
             ADD 1 TO i
          END-IF
          MOVE InitialImage TO IO-Text-Buffer(i:LENGTH OF InitialImage)

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
