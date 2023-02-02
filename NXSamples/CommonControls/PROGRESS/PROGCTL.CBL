      $set mfoo
       program-id. "progctl".

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
          progress is class "progress"
          EventManager is class "p2emgr"
          .

      * This file provides the initial program section structure
        copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
        78 ProgramID                value "progctl".

        01 aControl                 object reference value null.
        01 thePosition              pic x(4) comp-5.
        01 MinValue                 pic x(4) comp-5.
        01 MaxValue                 pic x(4) comp-5.
        01 Step-Size                pic x(4) comp-5.
      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

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

          copy "prgdemo.cpb".

       PROCEDURE DIVISION USING Data-Block.


      *   This program should be called at the start of application
      *   loop processing where a progress indicator is required.

      *   On start of the loop the first call should register a "Cancel"
      *   button callback (if required) AND set the Minimum and
      *   Maximum values that the progress indicator is to represent.

      *   Subsequent calls to this module can be made using SetPosition,
      *   or Step (having previously executed SetStepSize).
      *   See the DS demonstration of using this functionality.

      *   Note use of the "runUntilEmpty" method which enables events
      *   to continue to be processed whilst in an application loop

      *   Convert the Call-Function to Uppercase
          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

          EVALUATE Call-Function
          WHEN "INITIALIZE"
               PERFORM Register-Callbacks
               PERFORM SetStartAndEndPositions

          WHEN "SET-RANGE"
               PERFORM SetStartAndEndPositions

          WHEN "SET-STEP-SIZE"
               MOVE Numeric-Value TO Step-Size
               INVOKE aControl "SetStepSize" USING Step-Size

          WHEN "STEP"
               IF (Numeric-Value + Step-Size) NOT > MaxValue
                  INVOKE aControl "Step" USING Numeric-Value
               END-IF
               INVOKE wsEventManager "runUntilEmpty"

          WHEN "INCREASE-BY-VALUE"
               INVOKE aControl "DeltaPos" USING Numeric-Value
               INVOKE wsEventManager "runUntilEmpty"

          WHEN "SET-POSITION"
               INVOKE aControl "SetPosition" USING Numeric-Value
               INVOKE wsEventManager "runUntilEmpty"

          WHEN OTHER
              DISPLAY Invalid-Function, " ", Call-Function
              GO TO Progress-Program-Exit
          END-EVALUATE
          .

       Progress-Program-Exit.

          EXIT PROGRAM.

       Create-Entry-Point Section.

       Entry "C" & ProgramID USING EntryPoint-Data.

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

          MOVE EntryPanels-Session-ID TO Queue-ID
          MOVE EntryWindow-Data     TO aHwnd
          PERFORM GetWindow-Instance-Routine


          INVOKE progress "new" USING aWindow
                            RETURNING aControl
          INVOKE aControl "setRectangle" USING EntryPosition-X
                                               EntryPosition-Y
                                               EntrySize-Width
                                               EntrySize-Height
          MOVE 0 TO thePosition
          INVOKE aControl "show"
          INVOKE aControl "setPosition" USING thePosition

      *   Update the master field with the object reference for the
      *   created control
          SET EntryObject-Reference TO aControl
          INVOKE EventManager "getCurrentManager" RETURNING
                                                          wsEventManager

          IF aControl NOT = NULL
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

      *   This registers a callback for a cancel button on the
      *   Progress window

      *** TO DO: In dialog, set up WINDOW-HANDLE with the handle of the
      *   button (e.g. Cancel) using MOVE-OBJECT-HANDLE

      *   This code should be called (via the INITIALIZE) function
      *   of this program, following the WINDOW-CREATED event

          INVOKE Window "fromHandle" USING Window-Handle
                                 RETURNING anObject
          MOVE '"' & ProgramID & z'ButtonClicked"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-Clicked TO i
          INVOKE anObject "setEvent" USING i aCallback
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


       SetStartAndEndPositions section.

          MOVE Numeric-Value  TO MinValue
          MOVE Numeric-Value2 TO MaxValue

          *> Note that the default implementation of the Win32 Progress
          *> Common control uses a signed 16bit number to set the range.
          *> Maximum value indicating 100% is therefore 32767.

          *> Note that you could set the range based on your percentage
          *> calculation which allows the maximum value to be expressed
          *> as 100.
          INVOKE aControl "SetRange" USING MinValue
                                           MaxValue
          .


       Cancel-Requested section.
       Entry ProgramID & "ButtonClicked" USING anEvent.

      *   Find out which object the event occured on
          INVOKE anEvent "getObject" RETURNING anObject

      *   Determine the window handle that will be used to post the
      *   panels2 events to. GetAncestor returns an object ref for the
      *   window, & we can then get its handle using GetID.

          INVOKE anObject "getAncestor" RETURNING aWindow
          INVOKE aWindow "GetID" RETURNING aHwnd

          PERFORM GetDataBlockPointer

      *   Here Object-Reference is set to the object that the
      *   event occured on. You can then invoke its methods if required.
      *   See the NetExpress help for the Object Class in use.
          SET Object-Reference TO anObject

      ****TO DO: This sets a flag in the data block indicating a
      *   cancel request has occurred. You need to check for this value
      *   changing in your application loop. This uses Numeric-Value2.

          MOVE 1 TO Numeric-Value2

      *   Your loop should terminate early.  You should re-call DS
      *   asap to allow event processing to continue.

      *   Note that the DS BUTTON-SELECTED event will also occur

          EXIT PROGRAM
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

           SET DataBlock-Pointer TO ADDRESS OF Data-Block
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


