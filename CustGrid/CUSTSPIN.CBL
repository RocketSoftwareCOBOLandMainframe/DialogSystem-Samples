      $set mfoo
       program-id. custspin.

       class-control.
           UpDown is class "updown"
           TextEntry is class "txtentry"
           Window is class "window"
           Dictionary is class "dictinry"
           Association is class "associtn"
           CobolComp5 is class "comp5"
           CharacterArray is class "chararry"
           EntryCallback is class "entrycll"
           Color is class "color"
           Mouse is class "mouse"
           Font is class "font"
           .

      *   This file provides the initial program section structure
          copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "custspin".

      *   SpinBtn specific data items
       01 anUpDown             usage object reference.
       01 aTextEntry           usage object reference.
       01 aSpinAssocTemplate   usage object reference.
       01 aSpinDictionary      usage object reference.

       01 EF-X-Border-Offset   pic s9(9) comp-5 value -1.
       01 EF-Y-Border-Offset   pic s9(9) comp-5.

       01 OnePixelX            pic x(4) comp-5 value 1.
       01 OnePixelY            pic x(4) comp-5 value 1.

       01 TwoPixelsX           pic x(4) comp-5 value 2.
       01 TwoPixelsY           pic x(4) comp-5 value 2.

       01 FourPixelsX          pic x(4) comp-5 value 4.

       01 EF-Font-Height       pic s9(9) comp-5 value -1.

      *   Font style to use for spin buttons.
       78 Font-FaceName        value z"MS Sans Serif".
       01 Font-PointSize       pic x(4) comp-5 value 8.
       01 Font-StyleFlags      pic x(4) comp-5 value 0.

      *   Define the following flag if you want the spin button size
      *   to be fixed to the font height.
       78 Fit-Font-Height      value 1.

       01 x                    pic s9(9) comp-5.
       01 y                    pic s9(9) comp-5.

       01 SpinPos              pic X(4) comp-5.

      *   Maximum number of spin buttons that can be handled
      *   PER APPLICATION (the demo uses 4).
       78 78-Max-Spin-Buttons  value 256.

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

      *   The Callout control block - We need the DSC-Session-ID
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

      *   The generic interface to Win95 Control routines - data
      *   exists in the screenset datablock - passed here as linkage
          copy "custgrid.cpb".


       PROCEDURE DIVISION USING DSC-Control-Block
                                Customer-Data-Block.

      *     Convert the Call-Function to Uppercase

          MOVE LENGTH OF CUSTOMER-Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING CUSTOMER-Call-Function
                          BY VALUE Function-Length

          EVALUATE CUSTOMER-Call-Function
          WHEN "REFRESH-OBJECT"

      *        Reset the SpinBtn, this sets the value in the spin
      *        button entry field

               PERFORM Set-Spin-Position

          WHEN "SET-SPIN-POSITION"

      *        Set the value in the spin button entry field.

               PERFORM Set-Spin-Position

          WHEN "SET-SPIN-RANGE"

      *        Set the range of values for the spin button.

               PERFORM Set-Spin-Range

          WHEN "GET-SPIN-POSITION"

      *        Get the value in the spin button entry field.

               PERFORM Get-Spin-Position

          WHEN "GET-SPIN-RANGE"

      *        Get the range of values for the spin button.

               PERFORM Get-Spin-Range

          WHEN "ENABLE-OBJECT"

      *        Enable the object Instance, this uses the
      *        AbstractWindow Class method for this control

               INVOKE CUSTOMER-Object-Reference "Enable"

      *        Get the 'buddy' (associated object) of the spin button,
      *        and enable that too.

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               INVOKE aTextEntry "Enable"

          WHEN "DISABLE-OBJECT"

      *        Disable the object Instance, this uses the
      *        AbstractWindow Class method for this control

               INVOKE CUSTOMER-Object-Reference "Disable"

      *        Get the 'buddy' (associated object) of the spin button,
      *        and disable that too.

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               INVOKE aTextEntry "Disable"

          WHEN "SET-FOCUS"

      *        setFocus on the object Instance, this uses the
      *        AbstractWindow Class method for this control

      *        setFocus implicitly does a show.

      *        Note that invoking this method, and having this program
      *        with an entryCallback for this event requires existence
      *        of a a local-storage section to allow recursion, even
      *        though no data may be used.

               INVOKE CUSTOMER-Object-Reference "setFocus"

      *        Get the 'buddy' (associated object) of the spin button,
      *        and set focus on that.

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               INVOKE aTextEntry "setFocus"

          WHEN "HIDE-OBJECT"

      *        Hide the Object Instance, this uses the
      *        AbstractWindow Class method for this control

               INVOKE CUSTOMER-Object-Reference "hide"

      *        Get the 'buddy' (associated object) of the spin button,
      *        and hide that too.

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               INVOKE aTextEntry "hide"

          WHEN "SHOW-OBJECT"

      *        show the object Instance, this uses the
      *        AbstractWindow Class method for this control

               INVOKE CUSTOMER-Object-Reference "show"

      *        Get the 'buddy' (associated object) of the spin button,
      *        and show that too.

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               INVOKE aTextEntry "show"


          WHEN "SET-MOUSE-SHAPE"

      *        Set the mouse shape of the pointer when
      *        over this object Instance

               PERFORM MouseShape-Function

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               SET CUSTOMER-Object-Reference TO aTextEntry

               PERFORM MouseShape-Function

          WHEN "SET-COLOR"

      *        Set the color of the object Instance

               PERFORM Object-Color-Function

               INVOKE CUSTOMER-Object-Reference "getBuddyControl"
                      RETURNING aTextEntry

               SET CUSTOMER-Object-Reference TO aTextEntry

               PERFORM Object-Color-Function

          WHEN OTHER

               DISPLAY Invalid-Function, " ", CUSTOMER-Call-Function
               GO TO Spin-Button-Program-Exit

          END-EVALUATE

          INVOKE anUpDown "accessSystemEvents".


       Spin-Button-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.

      * This is the same code as the CREATE function, but made available
      * via an entry point so that the control may be integrated with
      * the Dialog System runtime. Data here is linkage passed by DSGRUN

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

          PERFORM Create-Spin-Button

      * Update the master field with the object reference for the created
      * spin button

          SET EntryObject-Reference TO anUpDown
          PERFORM Register-Callbacks

          INVOKE anUpDown "accessSystemEvents".
          EXIT PROGRAM
        .

       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs... the runtime calculates the correct new co-ordinates
      *   following the resize.

          IF EntryWindow-Data = 0

      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.

      *      This code has to compensate for the fact that two objects
      *      are resized.

      *      Get the two object references

             SET anUpDown TO EntryObject-Reference

             INVOKE anUpDown "getBuddyControl" RETURNING aTextEntry

             INVOKE aTextEntry "getRectangle"
                          USING EntryPosition-X EntryPosition-Y
                                i j

             INVOKE anUpDown   "getRectangle"
                          USING x y
                                k l

      *      Compute the total width/height of the two controls
      *      together.

             ADD k TO x
             ADD l TO y

             SUBTRACT EntryPosition-X FROM x
             SUBTRACT EntryPosition-Y FROM y

             SUBTRACT EF-X-Border-Offset FROM EntryPosition-X
             SUBTRACT EF-Y-Border-Offset FROM EntryPosition-Y

             ADD EF-X-Border-Offset TO x
             ADD EF-X-Border-Offset TO x

             ADD EF-Y-Border-Offset TO y
             ADD EF-Y-Border-Offset TO y

             MOVE x TO EntrySize-Width
             MOVE y TO EntrySize-Height
          ELSE

      *      Remove any rounding discrepancies from the co-ordinates
      *      (need this because errors get compounded by this code)

             INVOKE aTextEntry "scaleXYDown" USING EntryPosition-X
                                                   EntryPosition-Y

             INVOKE aTextEntry "scaleXYDown" USING EntrySize-Width
                                                   EntrySize-Height

             INVOKE aTextEntry "scaleXYUp" USING EntrySize-Width
                                                 EntrySize-Height

             INVOKE aTextEntry "scaleXYUp" USING EntryPosition-X
                                                 EntryPosition-Y

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event

      *      Compute the size of the entry field

             IF EntrySize-Width > EF-X-Border-Offset
                SUBTRACT EF-X-Border-Offset FROM EntrySize-Width
             END-IF

             IF EntrySize-Width > EF-X-Border-Offset
                SUBTRACT EF-X-Border-Offset FROM EntrySize-Width
             ELSE
                MOVE 1 TO EntrySize-Width
             END-IF

             ADD 32 TO EntryPosition-Y

      $IF Fit-Font-Height DEFINED
             MOVE EF-Font-Height TO EntrySize-Height
             ADD TwoPixelsY TO EntrySize-Height

      *      ADD EF-Y-Border-Offset TO EntrySize-Height

             MOVE EntrySize-Height TO j

             ADD EF-Y-Border-Offset TO j
      $ELSE
             SUBTRACT EF-Y-Border-Offset FROM EntrySize-Height

             MOVE EntrySize-Height TO j

             SUBTRACT EF-Y-Border-Offset FROM EntrySize-Height
      $END

             MOVE EntrySize-Width TO i

      * Make sure the width does not go negative.

             IF i > k
                SUBTRACT k FROM i
             ELSE
                MOVE 1 TO i
             END-IF

             ADD EF-X-Border-Offset TO EntryPosition-X

             INVOKE aTextEntry "setRectangle"
                          USING EntryPosition-X EntryPosition-Y
                                i EntrySize-Height

      * Now the up/down buttons.

             ADD i TO EntryPosition-X
             ADD TwoPixelsX TO EntryPosition-X

             INVOKE anUpDown   "setRectangle"
                          USING EntryPosition-X EntryPosition-Y
                                k j
          END-IF

          EXIT PROGRAM
         .


       Create-Spin-Button section.

      *   Get the size of the borders around an entry field.

          IF  EF-X-Border-Offset = -1
              INVOKE TextEntry "GetXBorderOffSet"
                       RETURNING EF-X-Border-Offset

              INVOKE TextEntry "GetYBorderOffSet"
                       RETURNING EF-Y-Border-Offset
          END-IF

      *   Invoke a "new" instance of the EntryField class, as a child
      *   of the Window instance, giving an object reference for
      *   this new instance.

          INVOKE TextEntry "new" USING aWindow
                   RETURNING aTextEntry

      *   Get a font (MS Sans Serif 8 point) and it's height.
      *
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

      *---Sizes/Positions retrieved from linkage, either from the
      *   "User Control" create (called by DSGRUN) or by dialog CALLOUT
      *   to this program's CREATE function.
      *
      *   These values relate to panels2 generic units.
      *   X,Y co-ordinates from the top left of the parent

      *   Adjust the X/Y/width/height - we have the external sizes, but
      *   what we want is the internal sizes.

          ADD EF-X-Border-Offset TO i

          SUBTRACT EF-X-Border-Offset FROM k
          SUBTRACT EF-X-Border-Offset FROM k

          SUBTRACT EF-Y-Border-Offset FROM l
          SUBTRACT EF-Y-Border-Offset FROM l

          INVOKE aTextEntry "scaleYDown" USING j
          ADD 2 TO j
          INVOKE aTextEntry "scaleYUp" USING j

      *   Set the font on the entry field.

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

          INVOKE aTextEntry "accessSystemEvents".

      *   Invoke a "new" instance of the UpDown class, as a child
      *   of the Window instance, giving an object reference for
      *   this new instance, this object reference is returned in the
      *   datablock for later use.

          INVOKE UpDown "new" USING aWindow
                   RETURNING anUpDown

      *   If you want horizontal (left/right) buttons, uncomment the
      *   following line.

      *   INVOKE anUpDown "horizontal"

      *   Remove the UpDown control from the tabbing order (it's grouped
      *   with the entry field).

          INVOKE anUpDown "NoKeyboardGroup"

      *   Associate the UpDown (Spin Button) control with the entry
      *   field.

          INVOKE anUpDown "setBuddyControl" USING aTextEntry

      *   Create the control, nothing will be painted until the
      *   class library system event loop is resumed

          INVOKE anUpDown "create".


       Set-Spin-Position Section.

      *   Set the current position of the spin button.

          INVOKE CUSTOMER-Object-Reference "setPosition"
                                        USING CUSTOMER-Numeric-Value.


       Set-Spin-Range Section.

      *   Set the current range of the spin button.

          INVOKE CUSTOMER-Object-Reference "setMinimumRange"
                                    USING CUSTOMER-Numeric-Value
          INVOKE CUSTOMER-Object-Reference "setMaximumRange"
                                    USING CUSTOMER-Numeric-Value2
          .


       Get-Spin-Position Section.

      *   Get the current position of the spin button.

          INVOKE CUSTOMER-Object-Reference "getPosition" RETURNING
                                               CUSTOMER-Numeric-Value.


       Get-Spin-Range Section.

      *   Get the current range of the spin button.

          INVOKE CUSTOMER-Object-Reference "getMinimumRange" RETURNING
                                                  CUSTOMER-Numeric-Value
          INVOKE CUSTOMER-Object-Reference "getMaximumRange" RETURNING
                                                CUSTOMER-Numeric-Value2.


       Object-Color-Function section.

      *        Note that this section provides very simple example of
      *        setting colors using named values... you may also set
      *        a full range using RGB values via the class library

      *        1stBuffer is foreground color, invoke the
      *        color class returning an instance of the color required

              MOVE CUSTOMER-IO-Text-Buffer TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aForeColor

      *        and the background color

              MOVE CUSTOMER-IO-Text-Buffer2 TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aBackColor

      *        Invoke the setColor method of the AbstractWindow class
              INVOKE CUSTOMER-Object-Reference "setColor" USING
                                                              aForeColor
                                                             aBackColor

      *        We wont be using these objects again so destroy
              INVOKE aForeColor "finalize" RETURNING aForeColor
              INVOKE aBackColor "finalize" RETURNING aBackColor
              .


       MouseShape-Function section.

      *        Note that this section provides very simple example of
      *        setting mouse shapes using named system shape values...
      *        You may also set your own pointer shapes using the
      *        fromResource method of the mouseCursor class

      *        1stBuffer is the mouse shape indicator.
      *        Set up a CharacterArray with the name of the pointer
      *        required. Invoke the Mouse setshape method with the
      *        control and pointer required.

      *        Recall this routine to set it normal for this control
               MOVE CUSTOMER-IO-Text-Buffer TO Term-Field
               PERFORM Null-Terminate-Routine
               INVOKE CharacterArray "withValue" USING Term-Field
                                             RETURNING aCursor

               INVOKE Mouse "setShape" USING CUSTOMER-Object-Reference
                                            aCursor.

      *        This mouse object reference wont be used again so destroy

               INVOKE aCursor "finalize" RETURNING aCursor
               .

       Clear-Object-Function section.

      *        Delete all Object Instance items

              INVOKE CUSTOMER-Object-Reference "deleteAll"
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

           MOVE LENGTH OF CUSTOMER-IO-Text-Buffer TO i
           INVOKE CharacterArray "fromBuffer" USING i
                                                 CUSTOMER-IO-Text-Buffer
                                         RETURNING aCharArray

      *    Create a new font using the specified facename, point size
      *    and style.

           INVOKE font "new" USING aCharArray     *> Facename
                                   CUSTOMER-Numeric-Value  *> Point size
                                   CUSTOMER-Numeric-Value2 *> Font style
                         RETURNING aFont

           INVOKE aCharArray "finalize" RETURNING aCharArray

      *    Apply the font to the object identified by Object-Reference.

           INVOKE CUSTOMER-Object-Reference "setFont" USING aFont

      *    Return the font in Object-Reference.

           SET CUSTOMER-Object-Reference TO aFont
           SET aFont TO NULL
           .


      ******
      *     EntryCallBack entry point sections follow. Four callbacks
      *     have been implemented here...
      *
      *     UpDown value changed, accept, lose focus, EF lose focus.


       Value-Changed Section.
       Entry ProgramID & "SpinValueChanged" USING anEvent.

      *     The value has changed in the Spin Button.

      *     This section will retrieve the new value for the spin button.

      *     We need to query the event for the object that it occurred
      *     on, and see which item is selected on that object

            INVOKE anEvent "getObject" RETURNING anUpDown

      *     Note: don't use the getPosition method of UpDown here, as
      *           the UpDown position is not updated until AFTER
      *           the callback.

            INVOKE anEvent "getPosition" RETURNING SpinPos

            PERFORM Update-Value
            EXIT PROGRAM.

       Accept-Item Section.
       Entry ProgramID & "SpinAccept" USING anEvent.

      *     The Spin Button has been accepted.

      *     This section will retrieve the value for the spin button.

      *     We need to query the event for the object that it occurred
      *     on, and see which item is selected on that object

            INVOKE anEvent "getObject" RETURNING anUpDown

            INVOKE anUpDown "getPosition" RETURNING SpinPos

            PERFORM Update-Value
            EXIT PROGRAM.

       LoseFocus Section.
       Entry ProgramID & "SpinLoseFocus" USING anEvent.

      *     The Spin Button has lost focus.

      *     This section will retrieve the value for the spin button.

      *     We need to query the event for the object that it occurred
      *     on, and see which item is selected on that object

            INVOKE anEvent "getObject" RETURNING anUpDown

            INVOKE anUpDown "getPosition" RETURNING SpinPos

            PERFORM Update-Value
            EXIT PROGRAM.

       EfLoseFocus Section.
       Entry ProgramID & "SpinEfLoseFocus" USING anEvent.

      *     The Spin Button buddy (text entry) has lost focus.

      *     This section will retrieve the value for the spin button.

      *     Query the event for the object that it occurred on.

            INVOKE anEvent "getObject" RETURNING aTextEntry

      *     Get the spin button associated with the entry field.
      *
      *     This information is stored in a dictionary.

      *     Get the spin button associated with the entry field.

            INVOKE aSpinDictionary "at" USING aTextEntry
                                    RETURNING anUpDown

      *     Get the position of the spin button. This should
      *     automatically scan the contents of the text entry field.

            INVOKE anUpDown "getPosition" RETURNING SpinPos

      *     Re-set the spin button position (this will remove any
      *     invalid data from the entry field).

            INVOKE anUpDown "setPosition" USING SpinPos

            PERFORM Update-Value
            EXIT PROGRAM.


       Update-Value SECTION.

      *     Determine the window handle that will be used to post the
      *     panels2 events to. GetAncestor returns an object ref for the
      *     window, & we can then get its handle using GetID.

            INVOKE anUpDown "getAncestor" RETURNING aWindow
            INVOKE aWindow "GetID" RETURNING aHwnd

            PERFORM GetDataBlockPointer

            SET CUSTOMER-Object-Reference TO anUpDown
            MOVE SpinPos TO CUSTOMER-Numeric-Value

      *     This will trigger dialog in the screenset to handle changes
      *     in the value of the spin buttons. See the Dialog for window
      *     SPIN-BUTTON-SAMPLE.

      *     Posting events to peform any DS function is possible.

      *-----34580 is a user defined event number that the DS screenset
      *     responds to - see DS/PanelsV2 documentation for further
      *     details

            MOVE 34580  TO Event-Type
            PERFORM Post-User-Event-Routine.

       Register-Callbacks section.

      *    Registering a callback causes a block of your COBOL code
      *    to be executed when an event occurs on your gadget/control

      *    Here, when the value of the spin button changed, call the
      *    call the program entry point detailed in MessageName... the
      *    entry point code exists in the control root source file.

      *    The Entry point name

           MOVE ProgramID & z"SpinValueChanged " TO MessageName

      *    Invoke the "new" method of the EntryCallback class,
      *    detailing the Entry codeblock to be executed, returning an
      *    object reference for the instance of the EntryCallback class

           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback

      *    Establish the event that you want this EntryCallback
      *    instance to respond to

           MOVE p2ce-valueChanged TO i

      *    Invoke the control instance object, (its setEvent method)
      *    to register the event on which a call back should occur
      *    the second parameter specifies the Entry
      *    callback object reference previously established

           INVOKE anUpDown "setEvent" USING i aCallback

      *    Destroy the Entry callback object as it is no longer needed

           INVOKE aCallback "finalize" RETURNING aCallback

      *    When an item is Accepted
           MOVE ProgramID & z"SpinAccept" TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-accept TO i
           INVOKE anUpDown "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    When the control loses focus
           MOVE ProgramID & z"SpinLoseFocus" TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-losefocus TO i
           INVOKE anUpDown "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    When the text entry control loses focus
           MOVE ProgramID & z"SpinEfLoseFocus" TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-losefocus TO i
           INVOKE anUpDown "getBuddyControl" RETURNING
                  aTextEntry
           INVOKE aTextEntry "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Always register a callback to delete the dictionary item
      *    when the containing window is deleted.
           MOVE ProgramID & z"OnDestroyed" TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE aTextEntry "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveControlAssociation

           PERFORM SaveDataBlockPointer
           .

       SaveControlAssociation Section.

      *    Save the association between an entry field and it's spin
      *    button (we can get the reverse association using the
      *    UpDown control's getBuddyControl method).

           IF 1stTimeThru

      *       Now Create an association template using two object
      *       references.
              SET anObject TO NULL
              INVOKE Association "newClass" USING anObject anObject
                                        RETURNING aSpinAssocTemplate

      *       Now create our dictionary of associations
              MOVE 78-Max-Spin-Buttons TO i
              INVOKE Dictionary "ofAssociations"
                                             USING aSpinAssocTemplate
                                                   i
                                         RETURNING aSpinDictionary
           END-IF

      *    Insert the EntryField/SpinButton association into the
      *    dictionary

           INVOKE aSpinDictionary "atPut" USING aTextEntry
                                                anUpdown
           .

       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd
                                     RETURNING aWindow.

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

            SET ADDRESS OF CUSTOMER-Data-Block TO DataBlock-Pointer
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

