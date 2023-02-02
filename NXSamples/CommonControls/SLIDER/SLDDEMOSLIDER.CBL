      $set mfoo
       program-id. "sldDemoSlider".

       class-control.
          Window is class "window"
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
          slider is class "slider"
          .

      * This file provides the initial program section structure
        copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
        78 ProgramID                value "sldDemoSlider".

        01 aControl                 object reference value null.

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

          copy "SldDemo.cpb".

       PROCEDURE DIVISION USING DSC-Control-Block
                                Data-Block
                                .

      *   Convert the Call-Function to Uppercase

          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

      *   All the following INVOKE statements could be coded directly
      *   using the dialog script INVOKE function

          EVALUATE Call-Function
          WHEN "SET-SLIDER-POSITION"
             INVOKE Object-Reference "setPosition" USING Numeric-Value

          WHEN "GET-SLIDER-POSITION"
             INVOKE Object-Reference "getPosition" RETURNING
                                                          Numeric-Value

          WHEN "SET-SLIDER-RANGE"
             INVOKE Object-Reference "setRange" USING Numeric-Value
                                                      Numeric-Value2

          WHEN "SET-SELECT-RANGE"
             INVOKE Object-Reference "setSelection" USING Numeric-Value
                                                          Numeric-Value2

          WHEN "SET-LINE-VALUE"
             INVOKE Object-Reference "setLineSize" USING Numeric-Value

          WHEN "SET-PAGE-VALUE"
             INVOKE Object-Reference "setPageSize" USING Numeric-Value

          WHEN "ENABLE-OBJECT"
             INVOKE Object-Reference "Enable"

          WHEN "DISABLE-OBJECT"
             INVOKE Object-Reference "Disable"

          WHEN "SET-FOCUS"
             INVOKE Object-Reference "setFocus"

          WHEN "HIDE-OBJECT"
             INVOKE Object-Reference "hide"

          WHEN "SHOW-OBJECT"
             INVOKE Object-Reference "show"

          WHEN "SET-MOUSE-SHAPE"
             PERFORM MouseShape-Function

          WHEN "SET-COLOR"
             PERFORM Object-Color-Function

          WHEN OTHER
            DISPLAY Invalid-Function, " ", Call-Function
            GO TO Slider-Program-Exit
         END-EVALUATE
         .

       Slider-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.

       Entry "C" & ProgramID USING EntryPoint-Data.

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

         MOVE EntryPanels-Session-ID TO Queue-ID
         MOVE EntryWindow-Data     TO aHwnd
         PERFORM GetWindow-Instance-Routine

         INVOKE slider "new" USING aWindow
                         RETURNING aControl

      ***TO DO: Change these default values to suit your needs...
         MOVE 0   TO i
         MOVE 100 TO j
         MOVE 10  TO k
         INVOKE aControl "setRange" USING i j
         INVOKE aControl "setPosition" USING i
         INVOKE aControl "setTickFreq" USING k

         INVOKE aControl "setRectangle" USING EntryPosition-X
                                              EntryPosition-Y
                                              EntrySize-Width
                                              EntrySize-Height
         INVOKE aControl "show"

      * Update the master field with the object reference for the
      * created control
         SET EntryObject-Reference TO aControl

         IF aControl NOT = NULL
            PERFORM Register-Callbacks
            INVOKE aControl "accessSystemEvents"
         END-IF
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


       Register-Callbacks section.

      *   Pick up on slider value changes
          MOVE '"' & ProgramID & z'ValChanged"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-valuechanged TO i
          INVOKE aControl "setEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback


      *   Always register a callback to delete the dictionary item
      *   when the containing window is deleted.
          MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
          INVOKE EntryCallBack "new" USING MessageName
                                 RETURNING aCallback
          MOVE P2Ce-Destroyed TO i
          INVOKE aControl "SetEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback

          PERFORM SaveDataBlockPointer
          .

       The-Slider-Has-Moved section.
       Entry ProgramID & "ValChanged" USING anEvent.

      *   Find out which object the event occured on
          INVOKE anEvent "getObject" RETURNING aControl

      *   Determine the window handle that will be used to post the
      *   panels2 events to. GetAncestor returns an object ref for the
      *   window, & we can then get its handle using GetID.

          INVOKE aControl "getAncestor" RETURNING aWindow
          INVOKE aWindow "GetID" RETURNING aHwnd

          PERFORM GetDataBlockPointer

      *   Here Object-Reference is set to the object that the
      *   event event occured on. You can then invoke its methods if required.
      *   See the NetExpress help for the Object Class you use.

          SET Object-Reference TO aControl

          INVOKE aControl "getPosition" RETURNING Numeric-Value

      *----38000 is a user defined event number that your DS screenset
      *    could respond to - see DS/PanelsV2 documentation for further
      *    details

          MOVE 38000  TO Event-Type
          PERFORM Post-User-Event-Routine

          EXIT PROGRAM
          .

       MouseShape-Function section.

      *   Note that this section provides very simple example of
      *   setting mouse shapes using named system shape values...
      *   You may also set your own pointer shapes using the
      *   fromResource method of the mouseCursor class

      *   1stBuffer is the mouse shape indicator.
      *   Set up a CharacterArray with the name of the pointer
      *   required. Invoke the Mouse setshape method with the
      *   control and pointer required.

      *   Recall this routine to set it normal for this control
          MOVE IO-Text-Buffer TO Term-Field
          PERFORM Null-Terminate-Routine
          INVOKE CharacterArray "withValue" USING Term-Field
                                             RETURNING aCursor

          INVOKE Mouse "setShape" USING Object-Reference
                                            aCursor.

      *   This mouse object reference wont be used again so destroy
          INVOKE aCursor "finalize" RETURNING aCursor
               .

       Object-Color-Function section.

      *   Note that this section provides very simple example of
      *   setting colors using named values... you may also set
      *   a full range using RGB values via the class library

      *   1stBuffer is background color, invoke the
      *   color class returning an instance of the color required

          MOVE IO-Text-Buffer TO Term-Field
          PERFORM Null-Terminate-Routine
          INVOKE color Term-Field RETURNING aBackColor

      *   Foreground color changes are not supported on Slider controls
      *   Invoke the setColor method of the AbstractWindow class
          INVOKE Object-Reference "setBackgroundColor" USING aBackColor

      *   We wont be using these objects again so destroy
          INVOKE aBackColor "finalize" RETURNING aBackColor
          .


       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd
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

          IF EntryWindow-Data = 0

      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.
             INVOKE EntryObject-Reference "getRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height

          ELSE

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event
             INVOKE EntryObject-Reference "setRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height
             INVOKE EntryObject-Reference "invalidate"
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

          INVOKE anEvent "getObject" RETURNING aControl
          INVOKE aControl "getAncestor" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .

