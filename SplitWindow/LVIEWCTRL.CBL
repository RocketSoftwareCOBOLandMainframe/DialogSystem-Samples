      $set mfoo
      $set remove(object-reference)
       program-id. "lviewctrl".
          copy "callconv.cpy".
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
          EventManager is class "p2emgr"
          Color is class "color"
          Mouse is class "mouse"
          Font is class "font"
          ListView is class "listview"
          ListViewItem is class "lstvitem"
          iconData is class "icondata"
          MaskedImageList is class "mskimglt"
          Module is class "module"
          .

      * This file provides the initial program section structure
        copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "lviewctrl".
       78 ProcessItem              value '"' & ProgramID
                                             & 'ProcessItem"'.
       78 ScrollingList            value '"' & ProgramID
                                             & 'VerticalScroll"'.

      * if wanted - set to 1, initial generated version is 0
       01 ListViewIcons            PIC X comp-5 value 0.
          88 IconsWanted           value 1.
      * if wanted - set to 1, initial generated version is 0
       01 ItemCheckBoxes           PIC X comp-5 value 1.
          88 CheckBoxesWanted           value 1.
       01 ResourceDLL              PIC X(20)
                                            value "lvicons.dll" & X"00".
       78 numberOfImages           value 12.
       78 BaseResID                value 200.

       01 aControl                 object reference value null.
       01 aListViewItem            object reference value null.
       01 aListView                object reference value null.
       01 aCollection              object reference value null.
       01 aResource                object reference value null.
       01 anIcon                   object reference value null.
       01 normalImageList          object reference value null.
       01 smallImageList           object reference value null.

      * TO DO: If all data is placed in group at outset set this to zero
      * A value of 1 enables tracking of scroll position in the list
       01 Data-state               PIC X comp-5 value 0.
          88 Paging-Data           value 1.

      * The Keycodes
        copy "Keys.cpy".
       01 Keystroke                K-KEYDESC.
       01 KeyFlags                 pic x(4) comp-5.
       01 keysMask                 pic x(4) comp-5.
       01 keysState                pic x(4) comp-5.

       01 aGadgetHWND              Pic 9(9) comp-5.
       01 aNextFocusHWND           Pic 9(9) comp-5.
       01 aBool                    pic 99 comp-5 value 0.
          88 aBool-True            VALUE 1.
       01 x                        pic x(4) comp-5.
       01 y                        pic x(4) comp-5.
       01 w                        pic x(4) comp-5.
       01 h                        pic x(4) comp-5.

       01 text-Width               pic x(4) comp-5.
       01 text-height              pic x(4) comp-5.
       01 pointSize                pic x(4) comp-5.
       01 AttributeFlags           pic x(4) comp-5.
       01 ResourceID               pic x(4) comp-5.

       01 itemCBState              PIC X comp-5.
       01 NumColumns               PIC X comp-5.
       01 NumColumns-x4            PIC X(4) comp-5.
       01 aClass                   object reference.
      * This file details the GUI class library event codes
        copy "p2cevent.cpy".

      * The Callout control block - We need the P2-MF-reserved
      * value that this gives us
        copy "ds-call.cpy".

       local-storage section.

      * Although no local-storage is used, this section is needed to
      * allow EntryCallback based recursive calls to the entry points
      * of this program.

       linkage section.

      * The object reference of the object receiving an event for
      * which a callback will be defined
       01 anEvent              usage object reference.

      * This file defines the interface for integration of this
      * control with the Dialog System runtime
        copy "userctrl.cpy".
        copy "splitter.cpb".

       PROCEDURE DIVISION USING Data-Block.

      *   Convert the Call-Function to Uppercase
          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

          SET aControl TO Object-Reference

          EVALUATE Call-Function
          WHEN "ADD-HEADER"
               *> Input: The datablock lview-item group containing each
               *>        columns header text and its length
               PERFORM Add-List-Header

          WHEN "CLEAR-OBJECT"
               *> Input: Object-Reference set to the ListView itself
               INVOKE aControl "deleteAll"

          WHEN "DELETE-LIST-ITEM"
               *> Input : See GetOrValidateObject section
               PERFORM GetOrValidateObject
               INVOKE object-reference "finalize"
                                              RETURNING object-reference

          WHEN "GET-CHECK-BOX-STATE"
               *> Input : See GetOrValidateObject section
               *> Output: Numeric-Value2 = 0/1 unselected/selected
               PERFORM GetOrValidateObject
               INVOKE Object-Reference "getCheckBoxValue"
                                                         RETURNING aBool
               MOVE aBool TO Numeric-Value2

          WHEN "SET-CHECK-BOX-STATE"
               *> Input : See GetOrValidateObject section
               PERFORM GetOrValidateObject
               IF Numeric-Value2 = 0
                  INVOKE Object-Reference "unselectCheckBox"
               ELSE
                  INVOKE Object-Reference "selectCheckBox"
                  INVOKE Object-reference "makeVisible"
               END-IF

          WHEN "GET-LIST-ITEM-STATE"
               *> Input : See GetOrValidateObject section
               *> Output: Numeric-Value2 = 0/1 unselected/selected
               PERFORM GetOrValidateObject
               INVOKE Object-Reference "isSelected" RETURNING aBool
               MOVE aBool TO Numeric-Value2

          WHEN "SET-LIST-ITEM-STATE"
               *> Input : See GetOrValidateObject section
               PERFORM GetOrValidateObject
               IF Numeric-Value2 = 0
                  INVOKE Object-Reference "setUnselected"
               ELSE
                  *> Item Focus Not always required For multiple
                  *> selection lists, in which case use:
                  *> INVOKE Object-Reference "setSelected"
                  INVOKE Object-Reference "setSelectedWithFocus"
                  INVOKE Object-reference "makeVisible"
               END-IF

          WHEN "GET-SELECTED-LIST-ITEM"
               *> Input : Object-Reference = ListView itself
               *>         Numeric-Value = Search startpoint
               *> Output: Object-Reference = next selected ListViewItem
               *>         Numeric-Value2 = index of next selected ListViewItem
               INVOKE aControl "nextSelectedItem" USING Numeric-Value
                                              RETURNING Object-Reference
               INVOKE aControl "indexOf" USING Object-Reference
                                     RETURNING Numeric-Value2

          WHEN "GET-TOP-LIST-ITEM"
               *> Input : Object-Reference = ListView itself
               *> Output: Object-Reference = Top visible ListViewItem
               *>         Numeric-Value = index of that item
               INVOKE aControl "getListViewTopItem"
                                                 RETURNING Numeric-Value
               PERFORM GetOrValidateObject

          WHEN "SET-TOP-LIST-ITEM"
               *> Input : See GetOrValidateObject section
               PERFORM GetOrValidateObject
               INVOKE aControl "setListViewTopItem" USING Numeric-Value

          WHEN "INSERT-LIST-ITEM"
               *> Input: Object-Reference = ListView itself
               *>        The datablock lview-item group containing a
               *>        single rows columns text
               *>        Numeric-Value = optional item icon index
               PERFORM Insert-Item

          WHEN "INSERT-MANY-LIST-ITEMS"
               *> Input: Object-Reference = ListView itself
               *>        The datablock lview-data group containing
               *>        multiple row and columns text
               *>        lvData-Max = the number of items to insert
               PERFORM Insert-Many-Items

          WHEN "MOVE-DOWN-LIST"
               *> Input : Object-Reference = ListView itself
               *>         Numeric-Value = Number of items to scroll down
               INVOKE aControl "moveDownList" USING Numeric-Value

          WHEN "MOVE-UP-LIST"
               *> Input : Object-Reference = ListView itself
               *>         Numeric-Value = Number of items to scroll up
               INVOKE aControl "moveUpList"   USING Numeric-Value

          WHEN "RETRIEVE-LIST-ITEM"
               *> Input : See GetOrValidateObject section
               *> Output: LVIEW-ITEM datablock group populated with all
               *>         text in the list columns for this listviewitem
               PERFORM GetOrValidateObject
               INVOKE aControl "numberOfColumns" RETURNING NumColumns
               PERFORM VARYING i FROM 1 BY 1 UNTIL i > NumColumns
                  INVOKE Object-Reference "getColumnValue" USING i
                                                    RETURNING aCharArray
                  INVOKE aCharArray "getValueWithSize"
                                                  USING lvItem-Length(i)
                                              RETURNING lvItem-Text(i)
               END-PERFORM

          WHEN "SET-FONT"
               *> Input : IO-Text-Buffer = the Face Name
               *>         Numeric-Value = font point size
               *>         Numeric-Value2 = Attribute flags (from bit
               *>         settings defined in FONT.CPY)
               MOVE Numeric-Value  TO pointSize
               MOVE Numeric-Value2 TO AttributeFlags
               PERFORM Set-Font-Function

          WHEN "UPDATE-LIST-ITEM"
               *> Input : See GetOrValidateObject section AND
               *>         LVIEW-ITEM datablock group provides new data
               *>         for the columns for this listviewitem
               PERFORM GetOrValidateObject
               INVOKE aControl "numberOfColumns" RETURNING NumColumns
               PERFORM VARYING k FROM 1 BY 1 UNTIL k > NumColumns
                   MOVE lvItem-Text(k) TO Term-Field
                   PERFORM Null-Terminate-Routine
                   INVOKE Object-Reference "setColumnValueZ" USING k
                                                              Term-Field
               END-PERFORM

          WHEN OTHER
              DISPLAY Invalid-Function, " ", Call-Function
              GO TO List-Program-Exit

          END-EVALUATE
          .

       List-Program-Exit.

          EXIT PROGRAM.

      *>----------------------------------------------------------------
       Create-Entry-Point Section.
       Entry "C" & ProgramID USING EntryPoint-Data.


      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, the co-ordinates for the creation of the
      * control and the datablock master field associated with this control.

          MOVE EntryPanels-Session-ID TO Queue-ID
          MOVE EntryWindow-Data     TO aHwnd
          PERFORM GetWindow-Instance-Routine

          INVOKE ListView "new" using aWindow
                           returning aControl

          INVOKE aControl "SortHeader"
      *   Create the control, nothing will be painted until the
      *   class library system event loop is resumed
          INVOKE aControl "create"
          INVOKE aControl "setRectangle" USING EntryPosition-X
                                               EntryPosition-Y
                                               EntrySize-Width
                                               EntrySize-Height

      ****TO DO: Set this to the initial type and settings required,
      *   ReportView gives a column header for the list
          INVOKE aControl "DisplayReportView"
          INVOKE aControl "SingleSelection"
          INVOKE aControl "ShowSelectionAlways"
          INVOKE aControl "FullRowselect"
          INVOKE aControl "HeaderDragDrop"
          INVOKE aControl "allowItemsToBeEdited"
      *   INVOKE aControl "GridLines"
          INVOKE aControl "wantAllKeys" *> allows CR to act as Accepted
          INVOKE aControl "keyboardgroup"
          IF CheckBoxesWanted
             INVOKE aControl "CheckBoxes"
          END-IF
          IF IconsWanted
             PERFORM SetupImages
          END-IF

      *   Update the master field with the object reference for the
      *   created control
          SET EntryObject-Reference TO aControl
          SET aListView TO aControl
          IF aControl NOT = NULL
             PERFORM Register-Callbacks
             INVOKE aControl "accessSystemEvents"
          END-IF

          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Resize-Entry-Point Section.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs.

      *   The Dialog System runtime calls this entry point setting
      *   EntryWindow-Data to 0 and then calls it again with
      *   EntryWindow-Data set to 1.

          SET aControl TO EntryObject-Reference
      *   PERFORM Resize-Routine

          EXIT PROGRAM
          .

       Register-Callbacks section.

          MOVE '"' & ProgramID & z'ItemAccepted"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-Accept TO i
          INVOKE aControl "setEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback
       *>
       *> Functionkeys to pick up CR for Accepted event.
          MOVE '"' & ProgramID & z'ItemFunctionKey"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
          MOVE p2ce-FunctionKey TO i
          INVOKE aControl "setEvent"  USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback
       *>
          MOVE '"' & ProgramID & z'ItemSelected"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-select TO i
          INVOKE aControl "setEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback
       *>
          MOVE '"' & ProgramID & z'RightClick"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-button3ClkonItem  TO i
          INVOKE aControl  "setEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback
       *>
          MOVE '"' & ProgramID & z'BeginDrag"' TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          MOVE p2ce-BeginDrag  TO i
          INVOKE aControl  "setEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback
       *>
          IF CheckBoxesWanted
             MOVE '"' & ProgramID & z'CheckClicked"' TO MessageName
             INVOKE EntryCallback "new" USING MessageName
                                    RETURNING aCallback
             MOVE p2ce-valueChanged TO i
             INVOKE aControl  "setEvent" USING i aCallback
             INVOKE aCallback "finalize" RETURNING aCallback
          END-IF
       *>
          IF Paging-Data
             MOVE ScrollingList TO MessageName
             INVOKE EntryCallback "new" USING MessageName
                                    RETURNING aCallback
             MOVE p2ce-vertTrack  TO i
             INVOKE aControl  "setEvent" USING i aCallback
             INVOKE aCallback "finalize" RETURNING aCallback

             MOVE p2ce-vertEnd   TO i
             INVOKE aControl  "setEvent" USING i aCallback
             INVOKE aCallback "finalize" RETURNING aCallback
          END-IF

       *> Always register a callback to delete the dictionary item
       *> when the containing window is deleted.
          MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
          INVOKE EntryCallBack "new" USING MessageName
                                 RETURNING aCallback
          MOVE P2Ce-Destroyed TO i
          INVOKE aControl "SetEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback

          PERFORM SaveDataBlockPointer
          .

      *>----------------------------------------------------------------
       Item-Selected section.
       Entry ProgramID & "ItemSelected" USING anEvent.

          PERFORM GetDataBlockPointer

          *> Could use aListViewItem returned from the getSelectedItem
          *> method (as in the Item-Accepted code below), but this code
          *> demonstrates compatibility for multiple selection lists.

          *> Setup a callback to process all items in the Collection of
          *> selected listview items
          MOVE ProcessItem TO MessageName
          INVOKE EntryCallback "new" USING MessageName
                                 RETURNING aCallback
          INVOKE aControl "selectedItems" returning aCollection

          MOVE 34591  TO Event-Type

          *> ProcessItem is called for each selected item
          INVOKE aCollection "do" using aCallback
          INVOKE aCallback "Finalize" RETURNING aCallback

          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Item-Accepted section.
       Entry ProgramID & "ItemAccepted" USING anEvent.

          PERFORM GetDataBlockPointer
          INVOKE anEvent "getSelectedItem" RETURNING aListViewItem

          MOVE 34592  TO Event-Type
          CALL ProcessItem USING aListViewItem

          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Item-RightClick section.
       Entry ProgramID & "RightClick" USING anEvent.

          PERFORM GetDataBlockPointer
          INVOKE anEvent "getSelectedItem" RETURNING aListViewItem

          MOVE 34593  TO Event-Type
          CALL ProcessItem USING aListViewItem

          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Item-CheckBoxChanged section.
       Entry ProgramID & "CheckClicked" USING anEvent.

          PERFORM GetDataBlockPointer

          IF CheckBoxesWanted
              INVOKE anEvent "getSelectedItem" RETURNING aListViewItem

              IF aListViewItem NOT = NULL
                 INVOKE aListViewItem "class" RETURNING aClass
                 IF aClass = ListViewItem
                    INVOKE aListViewItem "getCheckBoxValue"
                                                   RETURNING itemCBState
                 END-IF
              END-IF
          END-IF
          *> TO DO: Update processing if required based on itemCBState
          *>        0/1 unselected/selected
          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Function-Key-On-Item section.
       Entry ProgramID & "ItemFunctionKey" USING anEvent.

          PERFORM GetDataBlockPointer
          INVOKE anEvent "getCharacterCode" RETURNING K-Key OF Keystroke

          EVALUATE K-KeyAsNum
          WHEN OVK-RETURN
             *> Is a CR/Enter
             MOVE 34592  TO Event-Type
             CALL ProcessItem USING aListViewItem
          WHEN OVK-TAB
             PERFORM SetNextFocus
          WHEN OVK-UP
          WHEN OVK-DOWN
          WHEN OVK-PRIOR
          WHEN OVK-NEXT
             IF Paging-Data
                CALL ScrollingList USING anEvent
             END-IF
          END-EVALUATE

          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       BeginDrag Section.
       Entry ProgramID & "BeginDrag" USING anEvent.

          INVOKE anEvent "getObject" RETURNING aControl
          INVOKE aControl "getAncestor" RETURNING aWindow

          PERFORM GetDataBlockPointer

       *> Now dragging a ListViewItem object

          INVOKE anEvent "getSelectedItem" RETURNING object-reference

       *> TO DO: Update the Data Block to indicate a DRAG in progress
       *> you should then post a USER-EVENT to the screenset, which
       *> can change the pointer shape to a 'dragging' image. Then,
       *> Using the MOUSE-EVENT, with $EVENT-DATA set to 2, you can
       *> detect the DROP on a GUI item, if the flag is set, and
       *> populate the dropped object as required.

       *> MOVE 1 TO Drag-In-Progress

          MOVE 34570 TO Event-Type
          PERFORM Post-User-Event-Routine
          EXIT PROGRAM
          .

      *>----------------------------------------------------------------
       Scrolling section.
       Entry ProgramID & "VerticalScroll" USING anEvent.

          *> User has scrolled the list, check whether we need to
          *> Change the lview-data group
          PERFORM GetDataBlockPointer

          INVOKE aControl "getListViewTopItem" RETURNING Numeric-Value
          INVOKE aControl "getCountPerPage" RETURNING i

          IF (Numeric-Value + i) > lvData-Max
             *> TO DO: insert code that forces return to input/Output
             *> module to populate more data in the grid
             display "need more data"
          END-IF

          EXIT PROGRAM.

      *>----------------------------------------------------------------
       Process-An-Item section.
       Entry ProgramID & "ProcessItem" USING aListViewItem.

      *   This ListView Item has been selected/accepted/rightclicked

          SET ADDRESS OF Data-Block TO DataBlock-Pointer

          INVOKE aControl "numberOfColumns" RETURNING NumColumns

          *> Get all text from all columns into the datablock
          PERFORM VARYING i FROM 1 BY 1 UNTIL i > NumColumns
             INVOKE aListViewItem "getColumnValue" USING i
                                            RETURNING aCharArray
             MOVE SPACES TO lvItem-Text(i)
             INVOKE aCharArray "getValue" RETURNING lvItem-Text(i)
             INVOKE aCharArray "finalize" RETURNING aCharArray
          END-PERFORM

       *> TO DO: This code posts a USER-EVENT based on the the
       *> Event-Type (Set in the calling sections). You may wish to take
       *> take other actions for the ListItem currently being processed.

          SET Object-Reference  TO aListViewItem
          INVOKE aControl "indexOf" USING aListViewItem
                                RETURNING Numeric-Value
          PERFORM Post-User-Event-Routine

          IF Event-Type = 34592 *> item-accepted - check the checkbox
          AND CheckboxesWanted
             INVOKE aListViewItem "selectCheckBox"
          END-IF

          EXIT PROGRAM
          .

       Insert-Item section.

          INVOKE aControl "numberOfColumns" RETURNING NumColumns

      *   Add a listViewitem (row) using the LView-Item table entries.
          Move NumColumns TO NumColumns-x4
          INVOKE ListViewItem "new" USING NumColumns-x4
                                RETURNING aListViewItem
          PERFORM VARYING k from 1 BY 1 UNTIL k > NumColumns
             MOVE lvItem-Text(k) TO Term-Field
             PERFORM Null-Terminate-Routine
             INVOKE aListViewItem "setColumnValuez" USING k
                                                          Term-Field
          END-PERFORM

          IF IconsWanted
             INVOKE aListViewItem "setImageIndex" USING Numeric-Value
          END-IF
          INVOKE aControl "addItem" USING aListViewItem
          .

       Insert-Many-Items section.

          PERFORM VARYING l FROM 1 BY 1 UNTIL l > lvData-Max
             IF IconsWanted
                *> if using icons, first byte is the imagelist index
                MOVE lvData-Icon(l) TO Numeric-Value
             END-IF

      ******> TO DO: add/amend to suit the number of columns required
             MOVE lvData-Column1(l) TO lvItem-Text(1)
             MOVE lvData-Column2(l) TO lvItem-Text(2)
             MOVE lvData-Column3(l) TO lvItem-Text(3)
             MOVE lvData-Column4(l) TO lvItem-Text(4)
             PERFORM Insert-Item
             SET lvData-Object(l) TO aListViewItem
          END-PERFORM
          .

       GetOrValidateObject section.

          *> All Called functions that use this section have:

          *> Input: Object-Reference set to the ListView itself AND
          *>        Numeric-Value = Index of the item to work with
          *> OR   : Object-Reference set to the ListViewItem to work
          *>        with AND
          *>        Numeric-Value = 0

          IF Numeric-Value = 0
             *> Request to use an object, test its a valid ListViewItem
             INVOKE Object-Reference "class" RETURNING aClass
             IF aClass NOT = ListViewItem
                MOVE h"FFFFFFFF" TO Numeric-Value
                GO TO List-Program-Exit
             ELSE
                *> valid, get the parent object of this listviewitem
                *> and continue with the required function
                INVOKE Object-Reference "getAncestor" RETURNING aControl
                EXIT SECTION
             END-IF
          END-IF

          *> Retrieve the ListViewItem object using supplied index
          INVOKE aControl "itemAtIndex" USING Numeric-Value
                                    RETURNING Object-Reference
          .

       Add-List-Header section.

      *   Note: The Font is used to determine the column width
          MOVE "MS Sans Serif" TO IO-Text-Buffer
          MOVE 10 TO pointSize
          MOVE 0  TO AttributeFlags
          PERFORM Set-Font-Function

          MOVE Numeric-Value TO NumColumns
          PERFORM VARYING k from 1 BY 1 UNTIL k > NumColumns
             MOVE lvItem-Text(k) TO Term-Field
             PERFORM Null-Terminate-Routine

             *> Returns a ListViewHeaderItem object
             INVOKE aControl "addColumnz" USING Term-Field
                                    RETURNING lvItem-Object(k)

      *      Work out the required column width from the supplied data
      *      length and the full text extent using the current font

             *> first ensure always big enough for the header text...
             IF lvItem-Length(k) NOT < i
                MOVE lvItem-Length(k) TO i
             END-IF
             *> If required, impose a maximum # of characters, this aids
             *> readability - the column can be enlarged if user wants
             IF i > 19
                MOVE 19 TO i
             END-IF

             MOVE ALL "W" TO Term-Field(1:i)
             INVOKE CharacterArray "withLengthValue" USING i
                                                           Term-Field
                                                 RETURNING aCharArray
             *> get width of (i * "W")
             INVOKE aFont "ObjectTextExtent" USING aCharArray
                                                   text-Width
                                                   text-Height
             *> to get Panels2Genericcoordinates...
             INVOKE aControl "scaleXYUp" USING text-Width
                                               text-Height
             INVOKE aChararray "finalize" RETURNING aCharArray
             IF IconsWanted
             AND CheckBoxesWanted
             AND k = 1  *> make 1st column a bit bigger
                ADD 50 TO text-Width
             ENd-If
             INVOKE lvItem-Object(k) "setWidth" USING text-Width

             *> TO DO: insert your own criteria for rightjustified column
             IF k > 2
                INVOKE lvItem-Object(k) "rightJustified"
             END-IF

          END-PERFORM
          .

       Set-Font-Function section.

      *   Note that it is the responsibility of the application
      *   to finalize any new fonts created. These fonts should
      *   be finalized when the objects that reference them
      *   are finalized and when setting new fonts on objects.

          *> Create a character array to hold the facename
          *> specified in IO-Text-Buffer.
          MOVE LENGTH OF IO-Text-Buffer TO i
          INVOKE CharacterArray "fromBuffer" USING i
                                                   IO-Text-Buffer
                                         RETURNING aCharArray

          *> Create a new font using the specified facename, point size
          *> and style.
          INVOKE font "new" USING aCharArray     *> Facename
                                  pointSize
                                  AttributeFlags
                        RETURNING aFont
          INVOKE aCharArray "finalize" RETURNING aCharArray

      *   Apply the font to the object
          INVOKE aControl "setFont" USING aFont
          .

       SetUpImages section.

          *> Load the bitmap DLL
          INVOKE CharacterArray "withValue" USING resourceDLL
                                        RETURNING aCharArray
          INVOKE module "new" USING aCharArray
                          RETURNING aResource

          *> Normal images - first set up an ImageList 32*32 in size
          MOVE 32 TO i j
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
          INVOKE aControl "setNormalImages" USING normalImageList

          *> Now repeat for small images - 16 pixels this time
          MOVE 16 TO i j
          INVOKE MaskedImageList "new" USING i j
                             RETURNING smallImageList
          *> add the icons to the imagelist
          MOVE BaseResID TO ResourceID
          PERFORM NumberOfImages TIMES
             ADD 1 TO ResourceID
             INVOKE iconData "fromResource" USING aResource
                                                  ResourceID
                                        RETURNING anIcon
             INVOKE smallImageList "addIcon" USING anIcon
                                         RETURNING i
             INVOKE anIcon "finalize" RETURNING anIcon
          END-PERFORM
          INVOKE aControl "setSmallImages" USING smallImageList
          .

       SetNextFocus section.

          *> This is required because we intercept all functionkeys
          *> for this control, (including TAB) which would
          *> otherwise move focus to the next object in order...
          *> so we must do it ourselves
          INVOKE anEvent "ShiftDepressed" RETURNING aBool
          MOVE aBool TO i

          INVOKE aWindow "getID" RETURNING aHWND
          INVOKE aControl "getID" RETURNING aGadgetHWND
          CALL WAPI "GetNextDlgTabItem" USING BY VALUE aHWND
                                                       aGadgetHWND
                                                       i
                                             RETURNING aNextFocusHWND
          INVOKE window "fromHandle" USING aNextFocusHWND
                                 RETURNING anObject
          INVOKE anObject "setFocus"
          .

       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd RETURNING aWindow
          INVOKE aWindow "panels2genericcoordinates"
          .

       Resize-Routine Section.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   code is called by DSGRUN when a Window resized event occurs...
      *   the runtime calculates the correct new co-ordinates
      *   following the resize

      *   The EntryWindow-Data flag is used in this context, as a value
      *   to indicate whether to get or set the rectangle details.
      *   0 = Get/ 1 = Set

          IF EntryWindow-Data = 0

      *      The Dialog System Runtime needs to know the current
      *      coordinates of the object instance so it can apply an
      *      adjustment factor to the values that need to change.
             INVOKE aControl "getRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height
             MOVE EntryPosition-X  TO X
             MOVE EntryPosition-Y  TO Y
             MOVE EntrySize-Width  TO W
             MOVE EntrySize-Height TO H
          ELSE

      *      Invoke the setRectangle method of the object instance to
      *      reset the physical sizes following a window-sized event
             INVOKE aControl "setRectangle"
                                  USING EntryPosition-X EntryPosition-Y
                                        EntrySize-Width EntrySize-Height

             SET ADDRESS OF Data-Block TO EntryDataBlock-Pointer
             INVOKE aControl "numberOfColumns" RETURNING NumColumns

             *> Reset the columns to reflect the change in rectangle
             PERFORM VARYING i FROM 1 BY 1 UNTIL i > NumColumns
                INVOKE lvItem-Object(i) "getWidth" RETURNING j
                COMPUTE k = ((EntrySize-Width / W) * j)
                INVOKE lvItem-Object(i) "setWidth" USING k
             END-PERFORM
          END-IF
          .


       Post-User-Event-Routine section.

      *   The EntryCallback class has an extended method to enable
      *   the posting of a user event to the panels2 module. The Dialog
      *   System USER-EVENT dialog table may then act on this event

          INVOKE EntryCallback "PostP2Event" USING Queue-ID
                                                   aHwnd
                                                   Event-Type
          .

       Null-Terminate-Routine Section.

      *   This section loops back from the end of the field until it
      *   encounters a non space - & puts a null in the right place
      *---The buffer sizes used may require user defined values

          MOVE LENGTH OF lvItem-Text(1) TO j
          PERFORM VARYING i FROM j BY -1 UNTIL i = 0
               IF Term-Field(i:1) NOT = Spaces
               AND NOT = X"00"
                  ADD 1      TO i
                  MOVE x"00" TO Term-Field(i:1)
                  EXIT SECTION
               END-IF
          END-PERFORM
          MOVE x"00" TO Term-Field(j:1)
          .

       SaveDataBlockPointer Section.

      *   Save a pointer to the datablock in a dictionary. This is
      *   so we can get at the correct datablock in the callback code.

      *   I.E. The datablock thats associated with the window on
      *   which an event occurs.

          IF 1stTimeThru

      *      First establish a class for creation of our Association
      *      template. Now PIC X(4) Comp-5 is a class instance
             MOVE 4 TO i
             INVOKE CobolComp5 "newClass" USING i
                                        RETURNING aStorageClass
      *      Now Create an association template using an object
      *      reference and a Pic X(4) Comp-5 data item.
             SET anObject TO NULL
             INVOKE Association "newClass" USING anObject aStorageClass
                                       RETURNING anAssocTemplate

      *      Now create our dictionary (upto 32 items) of associations
             MOVE 32 TO i
             INVOKE Dictionary "ofAssociations" USING anAssocTemplate
                                                      i
                                            RETURNING aDictionary
             SET Not1stTimeThru TO TRUE
          END-IF

      *   Insert the Window/datablock Pointer association into the
      *   dictionary

          SET DataBlock-Pointer TO EntryDatablock-pointer
          INVOKE aDictionary "atPut" USING aWindow DataBlock-Pointer
          .


       GetDataBlockPointer section.

      *   This re-sets this entry point program Datablock variable
      *   to the memory location where we know it exists - the
      *   original location identified by the pointer, retrieved from
      *   our dictionary

      *   Find out which object the event occured on
          INVOKE anEvent "getObject" RETURNING aControl

      *   Determine the window handle that will be used to post the
      *   panels2 events to. GetAncestor returns an object ref for the
      *   window, & we can then get its handle using GetID.
          INVOKE aControl "getAncestor" RETURNING aWindow
          INVOKE aWindow "GetID" RETURNING aHwnd


          INVOKE aDictionary "at" USING aWindow
                              RETURNING DataBlock-Pointer

          SET ADDRESS OF Data-Block TO DataBlock-Pointer
          .

       The-Object-is-Destroyed section.
       Entry ProgramID & "OnDestroyed" USING anEvent.

          IF aFont           NOT = NULL
             INVOKE aFont           "finalize" RETURNING aFont
          END-IF

          IF normalImageList NOT = NULL
             INVOKE normalImageList "finalize"
                                     RETURNING normalImageList
          END-IF

          IF smallImageList  NOT = NULL
             INVOKE smallImageList  "finalize"
                                     RETURNING smallImageList
          END-IF

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

