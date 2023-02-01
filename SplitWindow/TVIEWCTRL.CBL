      $set mfoo
      $set remove(object-reference)
       program-id. "tviewctrl".

       class-control.
           TreeView is class "treeview"
           TreeViewItem is class "treeitem"
           Window is class "window"
           Dictionary is class "dictinry"
           Association is class "associtn"
           CobolComp5 is class "comp5"
           CharacterArray is class "chararry"
           EntryCallback is class "entrycll"
           SelectionEvent is class "selectev"
           Color is class "color"
           font is class "font"
           Mouse is class "mouse"
           iconData is class "icondata"
           MaskedImageList is class "mskimglt"
           Module is class "module"
           .

      *   This file provides the initial program section structure
          copy "strcture.cpy".
      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "tviewctrl".
      * if wanted - set to 1, initial generated version is 0
       01 TreeViewIcons            PIC X comp-5 value 1.
          88 IconsWanted           value 1.
       01 ResourceDLL              PIC X(20)
                                            value "lvicons.dll" & X"00".
       78 numberOfImages           value 12.
       78 BaseResID                value 200.


       01 aResource                object reference value null.
       01 anIcon                   object reference value null.
       01 normalImageList          object reference value null.
       01 smallImageList           object reference value null.
       01 ResourceID               pic x(4) comp-5.

      *   TreeView specific data items
       01 aTreeview            usage object reference.
       01 aLevel               usage object reference.
       01 aNextLevel           usage object reference.
       01 aPrevLevel           usage object reference.


      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

       local-storage section.
      *   Although no local-storage is used, this section is needed to
      *   allow Entrycallback based recursive calls to the entry points
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
          copy "Splitter.cpb".


       PROCEDURE DIVISION USING Data-Block.

      *   Convert the Call-Function to Uppercase

          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

          EVALUATE Call-Function

          WHEN "INSERT-MANY-ITEMS"

               PERFORM Populate-The-Tree

          WHEN "REFRESH-OBJECT"

      *        Reset the TreeView, this deletes all & re-inserts
      *        items - from the second linkage area.
      *        Provided to avoid the need for two CALLOUTs

               PERFORM Clear-Object-Function
               PERFORM Populate-The-Tree

      *   Note that the following functions work using a TreeviewItem
      *   with the Numeric-Value specifying which object element
      *   in the item array is to be affected

          WHEN "DELETE-ITEM"

      *        Delete the TreeViewItem Instance, note this will delete
      *        all its children also

      *        You should be careful when deleting Treeview items that
      *        your item group array maintains the same structure as
      *        the displayed tree, to avoid possible later problems

               INVOKE Item-Reference(Numeric-Value) "delete"

               INVOKE Item-Reference(Numeric-Value) "finalize" RETURNING
                                          Item-Reference(Numeric-Value)

          WHEN "UPDATE-ITEM"

      *        Update the TreeViewItem Instance -
      *        Null Terminate the supplied new text then setLabelz on
      *        the TreeView item with the supplied object reference

               MOVE Item-Text(Numeric-Value) TO Term-Field
               PERFORM Null-Terminate-Routine
               INVOKE Item-Reference(Numeric-Value)
                                      "setLabelZ" USING Term-Field


          WHEN "SET-ITEM-STATE"

      *        Set the state of the TreeViewitem Instance, first remove
      *        any selection, TreeViews are single selection

      *        The first item in the treeViewItem group array
      *        will always have the treeview itself as a parent
               INVOKE Item-Reference(1) "getAncestor"
                                              RETURNING aTreeView

      *        removeSelection is a TreeView instance method
               INVOKE aTreeView "removeSelection"

      *        If we want the state on set it
               IF Numeric-Value NOT = 0
                  INVOKE Item-Reference(Numeric-Value) "setSelected"

               END-IF

         WHEN "CLEAR-OBJECT"

             PERFORM Clear-Object-Function

         WHEN "ENABLE-OBJECT"

      *        Enable the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "Enable"

         WHEN "DISABLE-OBJECT"

      *        Disable the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "Disable"

         WHEN "SET-FOCUS"

      *        setFocus on the object Instance, this uses the
      *        AbstractWindow Class method for this control


              INVOKE Object-Reference "setFocus"

         WHEN "HIDE-OBJECT"

      *        Hide the Object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "hide"

         WHEN "SHOW-OBJECT"

      *        show the object Instance, this uses the
      *        AbstractWindow Class method for this control

              INVOKE Object-Reference "show"


         WHEN "SET-MOUSE-SHAPE"

      *        Set the mouse shape of the pointer when
      *        over this object Instance

              PERFORM MouseShape-Function

         WHEN "SET-COLOR"

      *        Set the color of the object Instance

              PERFORM Object-Color-Function

         WHEN "SET-FONT"

      *        Set the font of the object Instance

              PERFORM Set-Font-Function


          WHEN OTHER

              DISPLAY Invalid-Function, " ", Call-Function
              GO TO Tree-View-Program-Exit

          END-EVALUATE

          INVOKE aTreeview "accessSystemEvents".


       Tree-View-Program-Exit.

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
          PERFORM Create-Tree-Instance

          IF IconsWanted
             PERFORM SetupImages
          END-IF

      * Update the master field with the object reference for the created
      * treeview

          SET EntryObject-Reference TO aTreeView
          PERFORM Register-Callbacks
          INVOKE aTreeview "accessSystemEvents".
          EXIT PROGRAM
        .

       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs... the runtime calculates the correct new co-ordinates
      *   following the resize

      *   PERFORM Resize-Routine
          EXIT PROGRAM

        .

       Create-Tree-Instance section.

      *   Invoke an "new" instance of the Treeview class, as a child
      *   of the Window instance, giving an object reference for
      *   this new instance, this object reference is returned in the
      *   datablock for later use.

          INVOKE Treeview "new" USING aWindow
                   RETURNING aTreeView

      *---Sizes/Positions are retrieved from linkage, either from the
      *   "User Control" create (called by DSGRUN) or by dialog CALLOUT
      *   to this programs CREATE function

      *   These values relate to panels2 generic units
      *   X,Y co-ordinates from the top left of the parent

      *   Invoke the setRectangle method of the treeview instance to
      *   establish the physical sizes on creation

           INVOKE aTreeView "setRectangle" USING i
                                                 j
                                                 k
                                                 l

      *   Create the control, nothing will be painted until the
      *   class library system event loop is resumed

          INVOKE aTreeview "create"

          .

       Populate-The-Tree section.

      *   Insert some Tree hierarchy levels passed in linkage
      *   The TreeView instance required is held in Object-Reference

          SET aTreeView TO Object-Reference

          PERFORM VARYING k FROM 1 BY 1 UNTIL k > Numeric-Value

             MOVE Item-Text(k) TO Term-Field

      *      Inserting a TreeViewItem requires a null terminated field

             PERFORM Null-Terminate-Routine


      *      Top Level = TreeView is the object reference to use
             IF Item-Parent(k) = 0
                SET aLevel TO Object-Reference

      *      Use the same object reference as stored by previous insert
             ELSE
                MOVE Item-Parent(k) TO J
                SET aLevel TO Item-Reference(J)
             END-IF

      *      When inserting an item, if the TreeView instance object
      *      itself is the first parameter, the item is inserted at the
      *      topmost level. An object reference for the inserted item is
      *      returned

             INVOKE aTreeview "addItemZ" USING aLevel Term-Field
                                     RETURNING aNextLevel

      *******Implementation specific code follows>
             EVALUATE Item-Text(k)(1:4)
             WHEN "SYST"
                 MOVE 11 to Numeric-Value2
             WHEN "PCBO"
                 MOVE 3 to Numeric-Value2
             WHEN "DISK"
                 MOVE 4 to Numeric-Value2
             WHEN "DISP"
                 MOVE 10 to Numeric-Value2
             WHEN "KEYB"
                 MOVE 5 to Numeric-Value2
             WHEN "PRIN"
                 MOVE 12 to Numeric-Value2
             WHEN "FDIS"
                 MOVE 1 to Numeric-Value2
             WHEN "CABL"
                 MOVE 2 to Numeric-Value2
             WHEN "MOUS"
                 MOVE 6 to Numeric-Value2
             WHEN "BOOK"
                 MOVE 7 to Numeric-Value2
             WHEN "SOFT"
                 MOVE 8 to Numeric-Value2
             WHEN OTHER
                 MOVE 11 to Numeric-Value2
             END-EVALUATE
             IF IconsWanted
                INVOKE aNextLevel "setNormalImage" USING Numeric-Value2
             END-IF

      *      So its available in the DataBLock
             SET Item-Reference(k) TO aNextLevel

          END-PERFORM.

       Object-Color-Function section.

      *        Note that this section provides very simple example of
      *        setting colors using named values... you may also set
      *        a full range using RGB values via the class library

      *        1stBuffer is foreground color, invoke the
      *        color class returning an instance of the color required

              MOVE IO-Text-Buffer TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aForeColor

      *        and the background color

              MOVE IO-Text-Buffer2 TO Term-Field
              PERFORM Null-Terminate-Routine
              INVOKE color Term-Field RETURNING aBackColor

      *        Invoke the setColor method of the AbstractWindow class
              INVOKE Object-Reference "setColor" USING aForeColor
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
               MOVE IO-Text-Buffer TO Term-Field
               PERFORM Null-Terminate-Routine
               INVOKE CharacterArray "withValue" USING Term-Field
                                             RETURNING aCursor

               INVOKE Mouse "setShape" USING Object-Reference
                                         aCursor

      *        This mouse object reference wont be used again so destroy

               INVOKE aCursor "finalize" RETURNING aCursor
               .

       Clear-Object-Function section.

      *        Delete all Object Instance items

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


      ******
      *     EntryCallBack entry point sections follow. Three callbacks
      *     have been fully implemented here...
      *
      *     TreeViewItem selection, Acceptance and right mouse click
      *
      *     Other CallBacks have been registered - no extra code has
      *     been implemented for these however - you may choose to create
      *     this yourself.


       Selected-Item Section.
       Entry ProgramID & "Select" USING anEvent.

      *     An Item has been selected/deselected in the TreeView

      *     Here, anEvent is the SelectedItem class instance object
      *     reference, so invoke its getObject method to give
      *     us the treeview on which it occurred

            INVOKE anEvent "getObject" RETURNING aTreeView

      *     Now get the selected item in this treeview
            INVOKE anEvent "getSelectedItem" RETURNING aLevel

      *     Invoke the "getLabel" method of this instance of this
      *     TreeViewItem returning an object reference for an instance
      *     of the CharacterArray class. If the object reference is null
      *     no items are currently selected.

            IF aLevel NOT = NULL
               INVOKE aLevel "getLabel" RETURNING aCharArray
            ELSE
               GO TO Select-Exit
            END-IF

      *     Invoke the CharacterArray instance method returning
      *     10 bytes of text from the selected item

            MOVE 10 TO wsSize
            INVOKE aCharArray "getValueWithSize" USING wsSize
                                             RETURNING Term-Field

      *     This object has done its job, so destroy it
            INVOKE aCharArray "finalize" RETURNING aCharArray

      *     Determine the window handle that will be used to post the
      *     panels2 events to. GetAncestor returns an object ref for the
      *     window, & we can then get its handle using GetID.

            INVOKE aTreeView "getAncestor" RETURNING aWindow
            INVOKE aWindow "GetID" RETURNING aHwnd

            PERFORM GetDataBlockPointer

      *-----User Defined functionality: Null terminate it, so we know
      *     how long it is - then append some text, for demonstration

            PERFORM Null-Terminate-Routine
            MOVE Term-Field TO  IO-Text-Buffer

      *-----34567 is a user defined event number that the DS screenset
      *     responds to - see DS/PanelsV2 documentation for further
      *     details

            MOVE 34567  TO Event-Type
            PERFORM Post-User-Event-Routine.

       Select-Exit.

            EXIT PROGRAM.


       Accepted-Item Section.
       Entry ProgramID & "Accept" USING anEvent.

      *     An Item has been selected

      *     This section does the same as the Select entry point
      *     it is implemented here as a demonstration and so we can
      *     differentiate between the two events, and update the
      *     datablock field correctly

      *     The only difference in this section is that we need to query
      *     the event for the object that it occurred on, and see which
      *     item is selected on that object

            INVOKE anEvent "getObject" RETURNING aTreeView

            INVOKE anEvent "getSelectedItem" RETURNING aLevel

      *     Now we know the item, get its associated text
            INVOKE aLevel "getLabel" RETURNING aCharArray
            MOVE 10 TO wsSize
            INVOKE aCharArray "getValueWithSize" USING wsSize
                                             RETURNING Term-Field

      *     This object has done its job, so destroy it
            INVOKE aCharArray "finalize" RETURNING aCharArray

      *     Determine the window handle that will be used to post the
      *     panels2 events to. GetAncestor returns an object ref for the
      *     window, & we can then get its handle using GetID.

            INVOKE aTreeView "getAncestor" RETURNING aWindow
            INVOKE aWindow "GetID" RETURNING aHwnd

            PERFORM GetDataBlockPointer

            PERFORM Null-Terminate-Routine
            MOVE Term-Field TO  IO-Text-Buffer
            MOVE " Accepted" TO IO-Text-Buffer(i:9)

            MOVE 34567  TO Event-Type
            PERFORM Post-User-Event-Routine

            EXIT PROGRAM.


       RightClick-On-Item Section.
       Entry ProgramID & "RightClick" USING anEvent.

      *     An Item has been clicked on with the 3rd MouseButton

      *     This section will retrieve the item concerned and post
      *     a user event so Dialog Script can invoke a context menu for
      *     this item

      *     We need to query the event for the object that it occurred
      *     on,and see which item on the tree the select event refers to

            INVOKE anEvent "getObject" RETURNING aTreeView

            INVOKE anEvent "getSelectedItem" RETURNING aLevel

      *     Now we know the item, get its associated text
            INVOKE aLevel "getLabel" RETURNING aCharArray
            MOVE 10 TO wsSize
            INVOKE aCharArray "getValueWithSize" USING wsSize
                                             RETURNING Term-Field

      *     This object has done its job, so destroy it
            INVOKE aCharArray "finalize" RETURNING aCharArray

            INVOKE aTreeView "SetSelected" USING aLevel

      *     Determine the window handle that will be used to post the
      *     panels2 events to. GetAncestor returns an object ref for the
      *     window, & we can then get its handle using GetID.

            INVOKE aTreeView "getAncestor" RETURNING aWindow
            INVOKE aWindow "GetID" RETURNING aHwnd

            PERFORM GetDataBlockPointer

            PERFORM Null-Terminate-Routine
            MOVE Term-Field TO  IO-Text-Buffer
            MOVE " RightClick" TO IO-Text-Buffer(i:11)

      *-----34568 is a user defined event number that the DS screenset
      *     responds to - see DS/PanelsV2 documentation for further
      *     details

            MOVE 34568  TO Event-Type
            PERFORM Post-User-Event-Routine

            EXIT PROGRAM.

       Expanded-Item Section.
       Entry ProgramID & "Expanded" USING anEvent.


      *---Insert any Item expanded code required here...
      *   Note that an Item selected event will occur also
          EXIT PROGRAM.


       Collapsed-Item Section.
       Entry ProgramID & "Collapsed" USING anEvent.

      *---Insert any Item collapsed code required here...
      *   Note that an Item selected event will occur also

          EXIT PROGRAM.


       Register-Callbacks section.

      *    Registering a callback causes a block of your COBOL code
      *    to be executed when an event occurs on your gadget/control

      *    Here, when an item is collapsed by clicking
      *    on the -ve button, call the program entry point detailed
      *    in MessageName... the entry point code exists in the control
      *    root source file

      *    The Entry point name

           MOVE '"' & ProgramID & z'Collapsed"' TO MessageName

      *    Invoke the "new" method of the EntryCallback class,
      *    detailing the Entry codeblock to be executed, returning an
      *    object reference for the instance of the EntryCallback class

           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback

      *    Establish the event that you want this EntryCallback
      *    instance to respond to

           MOVE p2ce-itemcollapsed TO i

      *    Invoke the control instance object, (its setEvent method)
      *    to register the event on which a call back should occur
      *    the second parameter specifies the Entry
      *    callback object reference previously established

           INVOKE aTreeView "setEvent" USING i aCallback

      *    Destroy the Entry callback object as it is no longer needed

           INVOKE aCallback "finalize" RETURNING aCallback

      *    The above five statements are now replicated so that we can
      *    enable a response to the system events we are interested in

      *    i.e. When a branch is Expanded

           MOVE '"' & ProgramID & z'Expanded"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-itemexpanded TO i
           INVOKE aTreeView  "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    When an item is selected

           MOVE '"' & ProgramID & z'Select"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-select TO i
           INVOKE aTreeView  "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    When an item is Accepted

           MOVE '"' & ProgramID & z'Accept"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-accept TO i
           INVOKE aTreeView  "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    When the right (3rd) mousebutton is clicked

           MOVE '"' & ProgramID & z'RightClick"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-button3ClkOnItem  TO i
           INVOKE aTreeView  "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Always register a callback to delete the dictionary item
      *    when the containing window is deleted.
           MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE aTreeview "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveDataBlockPointer
           .


       SetUpImages section.

          *> Load the bitmap DLL
          INVOKE CharacterArray "withValue" USING resourceDLL
                                        RETURNING aCharArray
          INVOKE module "new" USING aCharArray
                          RETURNING aResource

          *> Normal images - first set up an ImageList 16*16 in size
          MOVE 16 TO i j
          INVOKE MaskedImageList "new" USING i j
                                   RETURNING normalImageList

          *> add the icons to the imagelist
          MOVE BaseResID TO ResourceID
          PERFORM NumberOfImages TIMES
             ADD 1 TO ResourceID
             INVOKE iconData "fromResource" USING aResource
                                                  ResourceID
                                        RETURNING anIcon
             INVOKE normalImageList "addIcon" USING anIcon
                                          RETURNING i
             INVOKE anIcon "finalize" RETURNING anIcon
          END-PERFORM
          INVOKE aTreeView "setNormalImageList" USING normalImageList
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

            SET ADDRESS OF Data-Block TO DataBlock-Pointer
            .


       The-Object-is-Destroyed section.
       Entry ProgramID & "OnDestroyed" USING anEvent.

          IF normalImageList NOT = NULL
             INVOKE normalImageList "finalize"
                                     RETURNING normalImageList
          END-IF

          INVOKE anEvent "getObject" RETURNING aTreeview
          INVOKE aTreeview "getAncestor" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .



