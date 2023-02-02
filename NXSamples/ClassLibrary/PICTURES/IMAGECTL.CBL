      $set mfoo
       program-id. "imagectl".

       class-control.
          Window is class "dswindow"
          CharacterArray is class "chararry"
          OrderedCollection is class "ordrdcll"
          Association is class "associtn"
          Dictionary is class "dictinry"
          CobolComp5 is class "comp5"
          KeyBrd is class "keyboard"
          MessageBox is class "msgbox"
          EntryCallback is class "entrycll"
          Color is class "color"
          Mouse is class "mouse"
          Font is class "font"
          eventmanager is class "p2emgr"
          olepicture is class "olepict"
          .

      * This file provides the initial program section structure
        copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "imagectl".

       01 aControl                 object reference value null.
       01 aDrawingSurface          object reference value null.
       01 anOLEPicture              object reference value null.

       copy "mfole.cpy".
       01 rcBounds                 RECTL.

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

       local-storage section.

      *   Although no local-storage is used, this section is needed to
      *   allow EntryCallback based recursive calls to the entry points
      *   of this program.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined
        01 anEvent              usage object reference.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

          copy "image.cpb".

       PROCEDURE DIVISION USING DSC-Control-Block
                                Data-Block
                                .
      *   Convert the Call-Function to Uppercase
          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

          EVALUATE Call-Function
          WHEN "SET-PICTURE"
             PERFORM Setup-Picture
             invoke aWindow "setPicture" USING rcBounds
                                          anOLEPicture
             invoke aWindow "invalidate"
          WHEN OTHER

              DISPLAY Invalid-Function, " ", Call-Function
              GO TO Image-Program-Exit

          END-EVALUATE
          .

       Image-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

         MOVE EntryPanels-Session-ID TO Queue-ID
         MOVE EntryWindow-Data     TO aHwnd
         PERFORM GetWindow-Instance-Routine
         PERFORM Register-Callbacks

         invoke eventmanager "getCurrentManager" RETURNING
                                                          wsEventManager
         invoke wsEventManager "initializeOLE"

         PERFORM Setup-Picture
         *> convert p2 co-ordinates to native
         MOVE EntryPosition-X TO 1Left OF rcBounds
         MOVE EntryPosition-Y TO 1Top OF rcBounds
         MOVE EntrySize-Width TO 1Right OF rcBounds
         MOVE EntrySize-Height TO 1Bottom OF rcBounds

         PERFORM ScaleAndShowPicture

      *  Finalize the characterarray as its done its job
         INVOKE aCharArray "finalize" RETURNING aCharArray

      *  Update the master field with the object reference for the
      *  created olePicture
         SET EntryObject-Reference TO anOLEPicture
         EXIT PROGRAM
         .


       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs.

      *   The Dialog System runtime calls this entry point setting
      *   EntryWindow-Data to 0 and then calls it again with
      *   EntryWindow-Data set to 1.

          SET aControl TO EntryObject-Reference
          PERFORM Resize-Routine
          EXIT PROGRAM
          .

       Setup-Picture section.

      *  Setting the picture requires an OLEPICTURE object to be
      *  created, we'll do that here

         IF anOLEPicture NOT = NULL
            invoke anOLEPicture "finalize" RETURNING anOLEPicture
         END-IF

      *  First get an characterarray instance for the file name
         move IO-Text-Buffer TO Term-Field
         PERFORM Null-Terminate-Routine
         INVOKE characterarray "withValue" USING Term-Field
                                        RETURNING aChararray
      *
      *  We need to get the Internal filename of this to
      *  cater for long and spacey filenames
         INVOKE aCharArray "asInternalFileName" RETURNING anObject

      *  Now invoke the OLEPict Class returning an instance of
      *  an olepicture object
         INVOKE olepicture "fromFile" USING anObject
                                  RETURNING anOLEPicture
         .

       ScaleAndShowPicture section.

         INVOKE aWindow "scaleXYDown" USING 1Left OF rcBounds
                                            1Top OF rcBounds
         INVOKE aWindow "scaleXYDown" USING 1Right OF rcBounds
                                            1Bottom OF rcBounds
         invoke aWindow "setPicture" USING rcBounds
                                           anOLEPicture
         invoke aWindow "invalidate"
         .

       Register-Callbacks section.

       *> Always register a callback to delete the dictionary item
       *> when the containing window is deleted.
          MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
          INVOKE EntryCallBack "new" USING MessageName
                                 RETURNING aCallback
          MOVE P2Ce-Destroyed TO i
          INVOKE aWindow "SetEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback

          PERFORM SaveDataBlockPointer
          .


       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandlewithClass" USING aHwnd
                                                    window
                                          RETURNING aWindow
          .

       Resize-Routine Section.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   code is called by DSGRUN when a Window resized event occurs...
      *   the runtime calculates the correct new co-ordinates
      *   following the resize

      *   The EntryWindow-Data flag is used in this context, as a value to
      *   indicate whether to get or set the rectangle details.
      *   0 = Get/ 1 = Set


         IF EntryWindow-Data = 1
            MOVE EntryPosition-X TO 1Left OF rcBounds
            MOVE EntryPosition-Y TO 1Top OF rcBounds
            MOVE EntrySize-Width TO 1Right OF rcBounds
            MOVE EntrySize-Height TO 1Bottom OF rcBounds
            PERFORM ScaleAndShowPicture
         END-IF
         .

       Post-User-Event-Routine section.

      * The EntryCallback class has an extended method to enable
      * the posting of a user event to the panels2 module. The Dialog System
      * USER-EVENT dialog table may then act on this event

            INVOKE EntryCallback "PostP2Event" USING Queue-ID
                                                     aHwnd
                                                     Event-Type
            .


       Null-Terminate-Routine Section.

      *   This section loops back from the end of the field until it
      *   encounters a non space - & puts a null in the right place
      *---The buffer sizes used may require user defined values

          MOVE LENGTH OF Term-Field TO j
          PERFORM VARYING i FROM j BY -1 UNTIL i = 0
               IF Term-Field(i:1) NOT = Spaces
                AND NOT = X"00"
                  ADD 1      TO i
                  MOVE x"00" TO Term-Field(i:1)
                  EXIT SECTION
               END-IF
          END-PERFORM
          MOVE x"00" TO Term-Field(j:1).


       SaveDataBlockPointer Section.

      *    Save a pointer to the datablock in a dictionary. This is
      *    so we can get at the correct datablock in the callback code.

      *    I.E. The datablock thats associated with the window on
      *    which an event occurs.

           IF 1stTimeThru

      *       First establish a class for creation of our Association
      *       template. Now PIC X(4) Comp-5 is a class instance
              MOVE 4 TO i
              INVOKE CobolComp5 "newClass" USING i
                                         RETURNING aStorageClass
      *       Now Create an association template using an object
      *       reference and a Pic X(4) Comp-5 data item.
              SET anObject TO NULL
              INVOKE Association "newClass" USING anObject aStorageClass
                                        RETURNING anAssocTemplate

      *       Now create our dictionary (upto 32 items) of associations
              MOVE 32 TO i
              INVOKE Dictionary "ofAssociations" USING anAssocTemplate
                                                       i
                                             RETURNING aDictionary
              SET Not1stTimeThru TO TRUE
            END-IF

      *    Insert the Window/datablock Pointer association into the
      *    dictionary

           SET DataBlock-Pointer TO EntryDatablock-pointer
           SET ADDRESS OF Data-Block TO DataBlock-Pointer
           INVOKE aDictionary "atPut" USING aWindow DataBlock-Pointer
           .


       GetDataBlockPointer section.

      *     This re-sets this entry point program Datablock variable
      *     to the memory location where we know it exists - the
      *     original location identified by the pointer, retrieved from
      *     our dictionary
            INVOKE aDictionary "at" USING aWindow
                                RETURNING DataBlock-Pointer

            SET ADDRESS OF Data-Block TO DataBlock-Pointer
            .


       The-Object-is-Destroyed section.
       Entry ProgramID & "OnDestroyed" USING anEvent.

          INVOKE anEvent "getObject" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          IF anOLEPicture NOT = NULL
             INVOKE anOLEPicture "finalize" RETURNING anOLEPicture
          END-IF

          SET aWindow TO NULL
          EXIT PROGRAM
          .

