      $set mfoo
       program-id. "efdemotxtfld".

       special-names.
           call-convention 66 is WINAPI.

       class-control.
           TextEntry is class "txtentry"
           Window is class "window"
           Dictionary is class "dictinry"
           Association is class "associtn"
           CobolComp5 is class "comp5"
           CharacterArray is class "chararry"
           EntryCallback is class "entrycll"
           Keybrd is class "keyboard"
           Color is class "color"
           Mouse is class "mouse"
           Font is class "font"
           Bitmap is class "bitmap"
           StaticText is class "label"
           StatusBar is class "statbar"
           groupbox is class "group"
           eventmanager is class "p2emgr"
           alarm is class "alarm"
           .

      *   This file provides the initial program section structure
          copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID              value "efdemotxtfld".

       01 CursorPos              pic s9(9) comp-5.
       01 FieldCount             pic x(4) comp-5.
       01 FieldLength            pic x(4) comp-5.

       01 aTextEntry             usage object reference.
       01 anEntryFieldDictionary usage object reference.
       01 aCharacterArray        usage object reference.
       01 aClassObject           usage object reference.
       01 aGadgetHWND            Pic 9(9) comp-5.
       01 aNextFocusHWND        Pic 9(9) comp-5.

       01 EF-X-Border-Offset   pic s9(9) comp-5 value -1.
       01 EF-Y-Border-Offset   pic s9(9) comp-5.
       01 OnePixelX            pic x(4) comp-5 value 1.
       01 OnePixelY            pic x(4) comp-5 value 1.
       01 TwoPixelsX           pic x(4) comp-5 value 2.
       01 TwoPixelsY           pic x(4) comp-5 value 2.
       01 FourPixelsX          pic x(4) comp-5 value 4.
       01 EF-Font-Height       pic s9(9) comp-5 value -1.
      *   Font style to use.
       78 Font-FaceName        value z"MS Sans Serif".
       01 Font-PointSize       pic x(4) comp-5 value 8.
       01 Font-StyleFlags      pic x(4) comp-5 value 0.

      *   Define the following flag if you want the field size
      *   to be fixed to the font height.
      *78 Fit-Font-Height      value 1.

       01 x                    pic s9(9) comp-5.
       01 y                    pic s9(9) comp-5.
       01 aBool                pic 99 comp-5 value 0.
          88 aBool-True        VALUE 1.
       01 aGadget              pic 99 comp-5 value 0.
          88 IsAGadget         VALUE 1.
       01 FocusTest            pic 99 comp-5 value 0.
          88 CanReceiveFocus   VALUE 1.
       01 highlight-chars      pic x(4) comp-5.
      *   Maximum number of Entry fields that can be handled
      *   PER APPLICATION
       78 78-Max-Fields  value 256.

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".
      *   And the Keycodes
          copy "Keys.cpy".
       01 Keystroke            K-KEYDESC.
       01 KeyFlags             pic x(4) comp-5.
       01 keysMask             pic x(4) comp-5.
       01 keysState            pic x(4) comp-5.
       01 Temp-Buffer          pic x(256).
       local-storage section.

      *   Although no local-storage is used, this section is needed to
      *   allow EntryCallback based recursive calls to the entry points
      *   of this program.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined
       01 anEvent              usage object reference.
       01 lnkText              PIC X.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

      *   The generic interface to Win95 Control routines - data
      *   exists in the screenset datablock - passed here as linkage
          copy "efdemo.cpb".


       PROCEDURE DIVISION USING Data-Block.

         SET aTextEntry TO Object-Reference

      *     Convert the Call-Function to Uppercase

          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                          BY VALUE Function-Length

          EVALUATE Call-Function
          WHEN "ENABLE-OBJECT"
      *        Enable the object Instance, this uses the
      *        AbstractWindow Class method for this control
               INVOKE aTextEntry "Enable"


          WHEN "DISABLE-OBJECT"
               INVOKE aTextEntry "Disable"

          WHEN "SET-FOCUS"
      *        setFocus implicitly does a show.
               INVOKE aTextEntry "setFocus"

          WHEN "HIDE-OBJECT"
               INVOKE aTextEntry "hide"

          WHEN "SHOW-OBJECT"
               INVOKE aTextEntry "show"

          WHEN "SET-MOUSE-SHAPE"
               PERFORM MouseShape-Function

          WHEN "SET-COLOR"
               PERFORM Object-Color-Function

          WHEN OTHER
             DISPLAY Invalid-Function, " ", Call-Function
             GO TO Entry-Field-Program-Exit

          END-EVALUATE.

       Entry-Field-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.

      * Data here is linkage passed by DSGRUN

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

          MOVE EntryPanels-Session-ID TO Queue-ID
          MOVE EntryWindow-Data       TO aHwnd
          PERFORM GetWindow-Instance-Routine

          MOVE EntryPosition-X    TO i
          MOVE EntryPosition-Y    TO j
          MOVE EntrySize-Width    TO k
          MOVE EntrySize-Height   TO l

          PERFORM Create-Entry-Field
      ****TO DO: Check out the EntryField object instance methods for
      *   changes you can make to modify Entry field behaviour - e.g.
      *   "numeric", "UpperCase" etc. - Make any changes here, such as:
      *   invoke aTextEntry "Uppercase"

          PERFORM Register-Callbacks

          IF 1stTimeThru
      *     Initial state is derived from Keyboard class, later it
      *     comes from the keyevent class
            INVOKE Keybrd "getKeyStates" RETURNING KeyFlags
            MOVE KEY-INSERT-LOCK to keysMask
            CALL "CBL_AND" USING keysState
                                 keysMask
                        BY VALUE 4
            IF keysMask > 0
               MOVE 0 to highlight-chars
            ELSE
               MOVE 1 to highlight-chars
            END-IF

            INVOKE EventManager "getCurrentManager"
                                                RETURNING wsEventManager
          END-IF
          PERFORM AddEntryFieldToDictionary


      ****TO DO: Entry field / Data block Master field association and length
      *          setting

      *   Set the maximum number of characters for retention in the
      *   entry field depending on the master fields being used

      *   FieldCount has been incremented (AddEntryFieldToDictionary section)
      *   for each field created - based on creation order - see DS
      *   Edit/Controls dialog for create order
      *****************************************************************
          EVALUATE FieldCount
          WHEN 1
            MOVE Length of IO-Field-1 to FieldLength
          WHEN 2
            MOVE Length of IO-Field-2 to FieldLength
            CONTINUE
          WHEN OTHER
            MOVE 10 to FieldLength
          END-EVALUATE

          INVOKE aTextEntry "SetLength" using FieldLength
          INVOKE aTextEntry "wantAllKeys"
          INVOKE aTextEntry "accessSystemEvents".

      *   Update the (User Control) master field with the
      *   object reference for the created field
          SET EntryObject-Reference TO aTextEntry
          EXIT PROGRAM
        .

       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs... the runtime calculates the correct new co-ordinates
      *   following the resize.

          PERFORM Resize-Routine
          EXIT PROGRAM
         .


       Create-Entry-Field section.

      *   Invoke a "new" instance of the EntryField class, as a child
      *   of the Window instance, giving an object reference for
      *   this new instance.

          INVOKE TextEntry "new" USING aWindow
                             RETURNING aTextEntry

      *   Get a font (MS Sans Serif 8 point) and it's height.
      *   The font object is used for the lifetime of the application.

          IF EF-Font-Height < 0
             INVOKE CharacterArray "withValue" USING Font-FaceName
                      RETURNING aCharArray

             INVOKE Font "new" USING aCharArray
                                     Font-PointSize
                                     Font-StyleFlags
                           RETURNING aFont
             INVOKE aCharArray "finalize" RETURNING aCharArray
             INVOKE aFont "getPixelHeight" RETURNING EF-Font-Height

             INVOKE aTextEntry "scaleYUp" USING EF-Font-Height
             INVOKE aTextEntry "scaleXYUp" USING OnePixelX
                                                 OnePixelY

             INVOKE aTextEntry "scaleXYUp" USING TwoPixelsX
                                                 TwoPixelsY
             INVOKE aTextEntry "scaleXUp" USING FourPixelsX
          END-IF

      *   These values relate to panels2 generic units.
      *   X,Y co-ordinates from the top left of the parent

      *   Adjust the X/Y/width/height - we have the external sizes, but
      *   what we want is the internal sizes.

          IF  EF-X-Border-Offset = -1
              INVOKE TextEntry "GetXBorderOffSet"
                       RETURNING EF-X-Border-Offset

              INVOKE TextEntry "GetYBorderOffSet"
                       RETURNING EF-Y-Border-Offset
          END-IF


          SUBTRACT EF-X-Border-Offset FROM k
          SUBTRACT EF-X-Border-Offset FROM k

          SUBTRACT EF-Y-Border-Offset FROM l
          SUBTRACT EF-Y-Border-Offset FROM l

      *    Set the font on the entry field.
          INVOKE aTextEntry "setFont" USING aFont

      $IF Fit-Font-Height DEFINED
          MOVE EF-Font-Height TO l
          SUBTRACT TwoPixelsY FROM l
      $END



      *   Invoke the setRectangle method of the textentry instance to
      *   establish the physical sizes on creation

          INVOKE aTextEntry "setRectangle" USING i j
                                                 k l

      *   Create the control, nothing will be painted until the
      *   class library system event loop is resumed

          INVOKE aTextEntry "create"
          .

       AddEntryFieldToDictionary Section.

           IF 1stTimeThru
              move 0 to FieldCount

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
                                 RETURNING anEntryFieldDictionary
              SET Not1stTimeThru TO TRUE
           END-IF

      *    Insert the entry field / field count association into the
      *    dictionary
           ADD 1 to FieldCount
           INVOKE anEntryFieldDictionary "atPut" USING aTextEntry
                                                       FieldCount
           .

       EfGainFocus Section.
       Entry ProgramID & "EfGainFocus" USING anEvent.

      ******Entry field refresh from current data block value

      *     The Entry Field has gained focus - refresh it from the
      *     data block in case its been changed elsewhere.

      *     Could also do any other GAINFOCUS processing required
      *
      ***************************************************************

            PERFORM GetObjectAndEventData
            PERFORM Setup-Field-Data
            PERFORM SetEntryFieldText
            EXIT PROGRAM
            .


       EfLoseFocus Section.
       Entry ProgramID & "EfLoseFocus" USING anEvent.

      ******Master field refresh from current entry field value

      *     The Entry Field has lost focus, write the contents back
      *     to the data block.

      *     Could also do any other LOSTFOCUS processing required
      *
      *************************************************************

            PERFORM GetObjectAndEventData
            PERFORM Setup-Field-Data
            PERFORM GetEntryFieldText
            EXIT PROGRAM
            .


       EfDataKey Section.
       Entry ProgramID & "EfDataKey" USING anEvent.

            PERFORM GetObjectAndEventData
            PERFORM GetKeystroke

      *     This forces OVR/INS of a character based on insertkey state
            INVOKE aTextEntry "setHighLightArea" USING CursorPos
                                                       highlight-chars

      *     Could validate the keystroke at this stage by examining
      *     K-KeyAsNum.  e.g. the following code accepts "a" through "j"
      *     or could test: IF K-Key of Keystroke IS NUMERIC etc.

      *     if K-Key if Keystroke > 96 and < 107
      *        move K-Key of Keystroke to <master field>(CursorPos:1)
      *     else
      *        invoke anEvent "setprocessed"
      *     end-if

      *     The Datablock value is updated from the field contents
      *     on lost-focus for efficiency but could also be done here,
      *     (as in the above validation code), could also set other
      *     datablock field values to indicate that data has been
      *     updated in a specific field.

      *     Ensure maximum no of chars cannot be exceeded
            invoke aTextEntry "getLength" returning x
            if CursorPos > x
               invoke alarm "warning"
               invoke anEvent "setprocessed"
            end-if

            EXIT PROGRAM
            .

       EfFunctionKey Section.
       Entry ProgramID & "EfFunctionKey" USING anEvent.

            PERFORM GetObjectAndEventData
            PERFORM GetKeystroke

            EVALUATE K-KeyAsNum
            WHEN OVK-INSERT
                 INVOKE anEvent "InsLocked"  RETURNING aBool
      *          just reverse the states to set the no. of chars to
      *          block out when a data key is received
                 IF aBool-True
                    MOVE 0 TO highlight-chars
                 ELSE
                    MOVE 1 TO highlight-chars
                 END-IF
            WHEN OVK-ESCAPE
      *          This event can tell the screenset to exit, code the USER-EVENT
      *          on your window to detect this value & force exit processing
                 MOVE 44446 TO Event-Type
                 PERFORM Post-User-Event-Routine

      *          This will force the Lost-focus to be processed
                 INVOKE wsEventManager "runUntilEmpty"

            WHEN OVK-TAB
                 PERFORM SetNextFocus
                 invoke anEvent "setprocessed"
            WHEN OTHER
                 CONTINUE
            END-EVALUATE

            EXIT PROGRAM
            .

       TheEntryFieldisDestroyed section.
       Entry ProgramID & "DeleteEntryField" USING anEvent.

            INVOKE anEvent "getObject" RETURNING aWindow
            INVOKE aDictionary "removeKey" USING aWindow
            EXIT PROGRAM
            .


       GetObjectAndEventData section.

            INVOKE anEvent "GetObject" RETURNING aTextEntry
            INVOKE aTextEntry "GetAncestor" RETURNING aWindow
            PERFORM GetDataBlockPointer
            INVOKE anEntryFieldDictionary "at" USING aTextEntry
                                       RETURNING FieldCount
            .

       GetKeystroke section.
      *     Get position of cursor within entry field
            INVOKE aTextEntry "getHighlightStart" RETURNING CursorPos
            INVOKE anEvent "getCharacterCode"
                                            RETURNING K-Key of Keystroke
            .

       GetEntryFieldText section.

            INVOKE aTextEntry "GetText" RETURNING aCharacterArray
            INVOKE aCharacterArray "getValueWithSize" USING i
                                                  RETURNING lnkText
            INVOKE aCharacterArray "finalize" RETURNING aCharacterArray
            .

       SetEntryFieldText section.

            INVOKE CharacterArray "fromBuffer" USING i
                                                     lnkText
                                           RETURNING aCharacterArray
            INVOKE aTextEntry "SetText" USING aCharacterArray
            INVOKE aCharacterArray "finalize" RETURNING aCharacterArray
            .


       Setup-Field-Data section.

      ******TO DO: substitute <1st master field> for your datablock field
      *     and uncomment the statements in this EVALUATE

      *     Add to this evaluate statement  for each field in use.
      *
      **********************************************************
            *> defaults
            MOVE 10 TO i
            SET ADDRESS OF lnkText TO ADDRESS OF temp-buffer

            EVALUATE FieldCount
            WHEN 1
                 MOVE LENGTH OF IO-Field-1 TO i
                 SET ADDRESS OF lnkText TO ADDRESS OF IO-Field-1
            WHEN 2
                 MOVE LENGTH OF IO-Field-2 TO i
                 SET ADDRESS OF lnkText TO ADDRESS OF IO-Field-2
                 CONTINUE
            END-EVALUATE
            .

       SetNextFocus section.

           INVOKE anEvent "ShiftDepressed" RETURNING aBool
           MOVE aBool TO i

           INVOKE aWindow "getID" RETURNING aHWND
           INVOKE aTextEntry "getID" RETURNING aGadgetHWND
           CALL WINAPI "GetNextDlgTabItem" USING BY VALUE aHWND
                                                          aGadgetHWND
                                                          i
                                                RETURNING aNextFocusHWND
           INVOKE window "fromHandle" USING aNextFocusHWND
                                  RETURNING anObject
           INVOKE anObject "setFocus"
           .

       Register-Callbacks section.

      *    Registering a callback causes a block of your COBOL code
      *    to be executed when an event occurs on your gadget/control

      *>
           MOVE ProgramID & "EfLoseFocus " TO MessageName
           INVOKE EntryCallback "new"   USING MessageName
                                    RETURNING aCallback
           MOVE p2ce-losefocus TO i
           INVOKE aTextEntry "setEvent"    USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *>
           MOVE ProgramID & "EfGainFocus " TO MessageName
           INVOKE EntryCallback "new"   USING MessageName
                                    RETURNING aCallback
           MOVE p2ce-gainfocus TO i
           INVOKE aTextEntry "setEvent"    USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *>
           MOVE ProgramID & "EfDataKey " TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-dataKey TO i
           INVOKE aTextEntry "setEvent"    USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *>
           MOVE ProgramID & "EfFunctionKey " TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-functionkey TO i
           INVOKE aTextEntry "setEvent"  USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *>
           MOVE ProgramID & z"DeleteEntryField" TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE aWindow "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveDataBlockPointer
          .

       Object-Color-Function section.

      *       Note that this section provides very simple example of
      *       setting colors using named values... you may also set
      *       a full range using RGB values via the class library

      *       1stBuffer is foreground color, invoke the
      *       color class returning an instance of the color required

              MOVE IO-Text-Buffer TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aForeColor

      *       and the background color

              MOVE IO-Text-Buffer2 TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aBackColor

      *       Invoke the setColor method of the AbstractWindow class
              INVOKE Object-Reference "setColor" USING aForeColor
                                                       aBackColor

      *       We wont be using these objects again so destroy
              INVOKE aForeColor "finalize" RETURNING aForeColor
              INVOKE aBackColor "finalize" RETURNING aBackColor
              .


       MouseShape-Function section.

      *       Note that this section provides very simple example of
      *       setting mouse shapes using named system shape values...
      *       You may also set your own pointer shapes using the
      *       fromResource method of the mouseCursor class

      *       1stBuffer is the mouse shape indicator.
      *       Set up a CharacterArray with the name of the pointer
      *       required. Invoke the Mouse setshape method with the
      *       control and pointer required.

      *       Recall this routine to set it normal for this control
              MOVE IO-Text-Buffer TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE CharacterArray "withValue" USING Term-Field
                                             RETURNING aCursor

              INVOKE Mouse "setShape" USING Object-Reference
                                           aCursor

      *       This mouse object reference wont be used again so destroy
              INVOKE aCursor "finalize" RETURNING aCursor
              .

       Clear-Object-Function section.

      *       Delete all Object Instance items
              INVOKE Object-Reference "deleteAll"
              .

       Set-Font-Function section.

      *    This section provides a very simple example of setting
      *    the font of an object.

      *    Note that it is the responsibility of the application
      *    to finalize any new fonts created. These fonts should
      *    be finalized when the objects that reference them
      *    are finalized and when setting new fonts on objects.

      *    Create a character array to hold the facename
      *    specified in IO-Text-Buffer.

           MOVE LENGTH OF IO-Text-Buffer TO i
           INVOKE CharacterArray "fromBuffer" USING i
                                                   IO-Text-Buffer
                                         RETURNING aCharArray

      *    Create a new font using the specified facename, point size
      *    and style.
           INVOKE font "new" USING aCharArray     *> Facename
                                   Numeric-Value  *> Point size
                                   Numeric-Value2 *> Font style
                         RETURNING aFont

           INVOKE aCharArray "finalize" RETURNING aCharArray

      *    Apply the font to the object identified by Object-Reference.
           INVOKE Object-Reference "setFont" USING aFont

      *    Return the font in Object-Reference.
           SET Object-Reference TO aFont
           SET aFont TO NULL
           .



       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd
                                     RETURNING aWindow.

          .

       Resize-Routine Section.

      *   The EntryWindow-Data flag is used in this context, as a value to
      *   indicate whether to get or set the rectangle details.
      *   0 = Get/ 1 = Set

          IF EntryWindow-Data = 0
      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.

             SET aTextEntry TO EntryObject-Reference

             INVOKE aTextEntry "getRectangle"
                          USING EntryPosition-X EntryPosition-Y
                                EntrySize-Width EntrySize-Height

          ELSE

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event

      *      Compute the size of the entry field

      $IF Fit-Font-Height DEFINED
             MOVE EF-Font-Height TO EntrySize-Height
             ADD FourPixelsX TO EntrySize-Height
      $END

             INVOKE aTextEntry "setRectangle"
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

          INVOKE anEvent "getObject" RETURNING aTextEntry
          INVOKE aTextEntry "getAncestor" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .
