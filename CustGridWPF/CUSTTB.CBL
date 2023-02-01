      $SET mfoo
       program-id. custtb.

       class-control.
           Window              is class "window"
           EventManager        is class "p2emgr"
           CharacterArray      is class "chararry"
           OrderedCollection   is class "ordrdcll"
           Association         is class "associtn"
           Dictionary          is class "dictinry"
           CobolComp5          is class "comp5"
           KeyBrd              is class "keyboard"
           MessageBox          is class "msgbox"
           EntryCallback       is class "entrycll"
           Color               is class "color"
           Mouse               is class "mouse"
           Font                is class "font"
           Module              is class "module"
           Toolbar             is class "toolbar"
           MaskedImageList     is class "mskimglt"
           BitmapData          is class "bitmapd"
           .

      *   This file provides the initial program section structure.
          copy "strcture.cpy".

      *   ToolBar specific data items.

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
       78 ProgramID                value "custtb".

          copy "keys.cpy". *> Accelerator key constants
                           *> This file is provided as part of the
                           *> class library.

          copy "custtbDefn.cpy". *> Definition of menu and tool bar.

       01 ws-EventManager          object reference.
       01 theDesktop               object reference.
       01 aResource                object reference.
       01 aToolbar                 object reference.
       01 buttonImageList          object reference.
       01 aBitmap                  object reference.
       01 aString                  object reference.
       01 aMenuBar                 object reference.
       01 subMenuReference         object reference.
       01 menuItem                 object reference.

       01 resourceID               pic x(4) comp-5.
       01 Width                    pic x(4) comp-5.
       01 Height                   pic x(4) comp-5.
       01 numberOfImages           pic x(4) comp-5.
       01 buttonIndex              pic x(4) comp-5.

       01 wsBool                   pic x comp-5.
          88 isTrue                value 1.
          88 isFalse               value 0.

       78 processMenu              value ProgramID & "processMenu".
       01 newMenuType              pic x comp-5.
          88 addBefore             value 1 3 5.
          88 addSeparator          value 2 3.
          88 addSubMenu            value 4 5.
       01 tempBuffer               pic x(256).
       01 menuItemText redefines tempBuffer.
          03 filler                pic x(5).
          03 windowNumber          pic 9.
       01 displayNumber            pic 9(3).
       01 displayNumber2           pic 9(3).

       01 wsIndex                  pic s9(9) comp-5.

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

       local-storage section.

      * Local-Storage is needed to allow EntryCallback based
      * recursive calls to the entry points of this program and also
      * needed when making recursive calls to the processMenu entry
      * point used to build the menu structure.

       01 lsParent                 object reference.
       01 lsIndex                  pic x(4) comp-5.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined
       01 anEvent              usage object reference.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".


      *   Datablock for screenset
         copy "custgrid.cpb".

       01 lnkParent                object reference.

       PROCEDURE DIVISION USING DSC-Control-Block
                                CUSTOMER-Data-Block.

      *   Convert the Call-Function to Uppercase

          MOVE LENGTH OF CUSTOMER-Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING CUSTOMER-Call-Function
                           BY VALUE Function-Length

          EVALUATE CUSTOMER-Call-Function

          WHEN "ADD-MENU-ITEM"

              PERFORM Add-Menu-Item

          WHEN "DELETE-MENU-ITEM"

              PERFORM Delete-Menu-Item

          WHEN "UPDATE-MENU-TEXT"

              PERFORM Update-Menu-Text

          WHEN "TOGGLE-CHECKMARK"

              PERFORM Toggle-CheckMark

          WHEN "ENABLE-OBJECT"

              PERFORM Enable-Object

          WHEN "DISABLE-OBJECT"

              PERFORM Disable-Object

          WHEN "ADD-TOOLBAR-BUTTON"

              PERFORM Add-Toolbar-Button

          WHEN OTHER

               DISPLAY Invalid-Function, " ", CUSTOMER-Call-Function
               GO TO Tool-Bar-Program-Exit

          END-EVALUATE

          .


       Tool-Bar-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point SECTION.
       Entry "C" & ProgramID USING EntryPoint-Data.

      * Data here is linkage passed by DSGRUN

      * Check to make sure this toolbar control template is not
      * currently being used by another user control.
          IF aWindow = NULL

      * Do the create having been passed the Panels2 Session ID, the
      * parent window handle, and the datablock master field associated
      * with this control.

               MOVE EntryPanels-Session-ID TO Queue-ID
               MOVE EntryWindow-Data     TO aHwnd
               PERFORM GetWindow-Instance-Routine

      * Allthough the co-ordinates for this control have been passed
      * they will not be used on creation of the menu bar as the
      * initial size and position of the menu bar are determined
      * by the dimensions of it's parent window.

               PERFORM Create-Menu-And-Tool-Bar

      * Return the object reference of the created toolbar.

               PERFORM Register-Callbacks
               SET EntryObject-Reference TO aToolbar

          ELSE
               MOVE SPACES TO tempBuffer
               MOVE "The toolbar template " & programID
                    &" is already being used by another user control."
                    &x"0A" & "A toolbar control template cannot be "
                    &"used by more than one user control."
                                                       TO tempBuffer
               PERFORM Display-Warning-Message

               SET EntryObject-Reference TO NULL

          END-IF

          EXIT PROGRAM
          .

       Resize-Entry-Point SECTION.
       Entry "R" & ProgramID USING EntryPoint-Data.

      *   When screenset Dynamic resizing is enabled, this entry point
      *   is called by Dialog System runtime when a Window resized event
      *   occurs.


      *   Menus and toolbars resize automatically, so this entry
      *   point does nothing.

          EXIT PROGRAM
          .

       String-From-tempBuffer SECTION.
           MOVE LENGTH of tempBuffer TO i
           INVOKE CharacterArray "fromBuffer" USING i
                                                    tempBuffer
                                          RETURNING aString
           .

       Create-Menu-And-Tool-Bar SECTION.

      * Initialize the data structures
           PERFORM Init-Data-Structure

      *   Add a menu bar to the window instance created from
      *   the handle of the Dialog System window.
           PERFORM Create-Menu-Bar

      * Add a tool bar, associating buttons with menu items.
           PERFORM Create-Tool-Bar

      * Redraw the menu bar.
           INVOKE aWindow "getMenubar" RETURNING aMenubar
           INVOKE aMenubar "reDraw"

      * Hide the toolbar for now. It should be explicitly shown
      * using dialog in the screenset once its parent window
      * has been created. Please see tbards.gs for an example of
      * how to show a toolbar using the dialog INVOKE function.
           INVOKE aToolbar "hide"
           .

       Init-Data-Structure SECTION.
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > maxMenuItems
               SET mReference(i) TO NULL
           END-PERFORM
           MOVE defaultMenuItems   TO numberOfMenuItems
           MOVE defaultButtons     TO numberOfButtons
           .

       Create-Menu-Bar SECTION.
           MOVE 0 TO wsIndex
           SET lsParent TO aWindow

      * Add the menu structure defined in mData (in tbardefn.cpy)
      * to the window aWindow.
           PERFORM UNTIL wsIndex >= defaultMenuItems
               ADD 1 TO wsIndex
               CALL processMenu using lsParent
           END-PERFORM
           .

       Process-Menu-Entry SECTION.
       ENTRY processMenu USING lnkParent.
      * Recursively build the menu structure as a set of top level
      * menu items and/or sub menus.
           SET lsParent TO lnkParent
           MOVE wsIndex TO lsIndex

           PERFORM Add-A-Menu-Item
           ADD 1 TO lsIndex

           PERFORM UNTIL lsIndex > defaultMenuItems
               IF hasChildren(lsIndex)
      *Build the sub menu and all its siblings (including any sub menus)
                   MOVE lsIndex TO wsIndex
                   CALL processMenu USING lsParent

                   IF lastSibling(lsIndex)
                       EXIT PROGRAM
                   END-IF
                   MOVE wsIndex TO lsIndex

               ELSE
      * Add a menu item or separator.
                   PERFORM Add-A-Menu-Item
                   IF lastSibling(lsIndex)
                       EXIT PERFORM
                   END-IF

               END-IF

               ADD 1 TO lsIndex
           END-PERFORM

           MOVE lsIndex TO wsIndex
           EXIT PROGRAM
           .

       Create-Tool-Bar SECTION.

           PERFORM Add-Tool-Bar
           PERFORM Process-Bitmaps
           PERFORM Process-Buttons
           .

       Add-Tool-Bar SECTION.
      * Add the tool bar to the window
           INVOKE toolbar "new" USING aWindow
                            RETURNING aToolbar

      *    set the flat  style.
           INVOKE aToolbar "flat"
      * Set tool bar width and height
           MOVE 16 TO height
           INVOKE aToolbar "setHeight" USING height
           INVOKE aWindow "getWidth" RETURNING width
           INVOKE aToolbar "setWidth" USING width

      * Make the tool bar resizable
           INVOKE aToolbar "resizable"

      * Set the width and height of the buttons
           MOVE 16 TO width
           MOVE 16 TO height
           INVOKE aToolbar "setBitmapWidthHeight" USING width height
           .

       Process-Bitmaps SECTION.

      * Load bitmap resources from resource file
           INVOKE module "newZ" USING resourceDllName
                            RETURNING aResource

      * Add button bitmaps
           PERFORM Add-Button-Bitmaps
           .

       Add-Button-Bitmaps SECTION.
           MOVE 16 TO width
           MOVE 16 TO height
           INVOKE maskedImageList "new" USING width
                                              height
                                    RETURNING buttonImageList

           MOVE 1 TO i
           PERFORM Add-Button-Bitmap until i > numberOfButtons
           INVOKE aToolBar "setImageList" USING buttonImageList
           .

       Add-Button-Bitmap SECTION.
           IF bMenuIndex(i) NOT = 0
              and bBitmapID(i) NOT = 0
               MOVE bBitmapID(i) TO resourceID
               INVOKE bitmapData "fromResource" USING aResource
                                                      resourceID
                                            RETURNING aBitmap
               INVOKE buttonImageList "addDefaultMaskedBitmap"
                                                       USING aBitmap
                                                       RETURNING wsIndex
               INVOKE aBitmap "finalize" RETURNING aBitmap
           END-IF
           add 1 TO i
           .

       Process-Buttons SECTION.
      * Associate toolbar buttons with menu items and add them
      * to the toolbar
           MOVE 1 TO buttonIndex
           PERFORM varying wsIndex from 1 by 1
                           until wsIndex > defaultButtons

               PERFORM Check-Prev-Menu-Indexes

      * Only add this button if it's a separator or if its related
      * menu index has not been used before for this toolbar
               IF i = 0
                   PERFORM Add-Indexed-Button
               ELSE
                   MOVE bMenuIndex(wsIndex) TO displayNumber
                   MOVE wsIndex             TO displayNumber2
                   MOVE SPACES TO tempBuffer
                   STRING "Menu index "        DELIMITED BY SIZE
                          displayNumber        DELIMITED BY SIZE
                     " already has an associated toolbar button,"&x"0A"
                                               DELIMITED BY SIZE
                          "therefore button index "
                                               DELIMITED BY SIZE
                          displayNumber2       DELIMITED BY SIZE
                          " was not added."    DELIMITED BY SIZE

                       INTO tempBuffer
                   END-STRING
                   PERFORM Display-Warning-Message

               END-IF

           END-PERFORM
           .

       Check-Prev-Menu-Indexes SECTION.
      * Loop back through button table to see if the current menu index
      * already has an associated toolbar button.
           IF bMenuIndex(wsIndex) NOT = 0 *> Only check non-separators
               MOVE wsIndex TO j
               SUBTRACT 1 FROM j
               PERFORM VARYING i FROM j BY -1 UNTIL i < 1
                   IF bMenuIndex(wsIndex) = bMenuIndex(i)
                       *> Menu index bMenuIndex(wsIndex) already has
                       *> an associated toolbar button.
                       EXIT PERFORM
                   END-IF
               END-PERFORM
           ELSE
               MOVE 0 TO i *> Make separator buttons get added
           END-IF
           .

       Add-Indexed-Button SECTION.

      * Get associated menu item reference
           MOVE bMenuIndex(wsIndex) TO i

           IF i = 0
      * Add separator
               INVOKE aToolBar "addSeparator"
                                     RETURNING bReference(wsIndex)

           ELSE
      * Add button
               INVOKE aToolbar "addTool" USING buttonIndex
                                               mReference(i)
                                     RETURNING bReference(wsIndex)
               add 1 TO buttonIndex

      * Set tool tip (if specified)
               IF bString(wsIndex) NOT = SPACES
                   INVOKE bReference(wsIndex) "setTipZ"
                                             USING bString(wsIndex)
               END-IF

           END-IF
           .

       Add-A-Menu-Item SECTION.
      * Get the menu item text
           INVOKE CharacterArray "withValue" USING mString(lsIndex)
                                         RETURNING aString
           IF aString NOT = NULL
               IF hasChildren(lsIndex)
                   INVOKE lsParent "addSubMenu"
                                       USING aString
                                   RETURNING mReference(lsIndex)
                   SET lsParent TO mReference(lsIndex)

               ELSE
                   IF isSeparator(lsIndex)
                       INVOKE lsParent "addSeparator"
                                       RETURNING mReference(lsIndex)
                   ELSE
                       INVOKE lsParent "addItem"
                                           USING aString
                                       RETURNING mReference(lsIndex)
                   END-IF

               END-IF

      * Find out if any menu item hint text was specified
               INVOKE aString "sizeInBytes" RETURNING i
               INVOKE aString "finalize" RETURNING aString
               add 2 TO i
               IF mString(lsIndex)(i:1) NOT = x"00"
      * Menu item hint text was specified, so set it up
                   INVOKE CharacterArray "withValue"
                                   USING mString(lsIndex)(i:1)
                               RETURNING aString
                   IF aString NOT = NULL
                       INVOKE mReference(lsIndex) "setStatusText"
                                                        USING aString
                       INVOKE aString "finalize" RETURNING aString
                   END-IF
               END-IF

      * Setup accelerator key (if specified)
               IF K-keyAsNum of mAccelKey(lsIndex) NOT = 0
                   INVOKE mReference(lsIndex) "setAccelerator"
                                                USING mAccelKey(lsIndex)
               END-IF

           END-IF
           .

       Display-Warning-Message SECTION.
           INVOKE eventmanager "getCurrentManager"
                               RETURNING ws-EventManager
           INVOKE ws-EventManager "getDesktop"
                               RETURNING theDesktop
           INVOKE MessageBox "new" USING theDesktop
                               RETURNING aMessageBox

           INVOKE aMessageBox "setTitleZ"
                       USING z"Dialog System Toolbar Template"

           PERFORM String-From-tempBuffer
           INVOKE aMessageBox "setMessage" USING aString
           INVOKE aString "finalize" RETURNING aString

           INVOKE aMessageBox "setTypeWarning"

           INVOKE aMessageBox "show"

           INVOKE aMessageBox "finalize" RETURNING aMessageBox
           .

       GetEventHwnd SECTION.
      * Get the handle of the window the event occured on
           INVOKE anEvent "getObject" RETURNING menuItem
           INVOKE menuItem "rootObject" RETURNING aWindow
           INVOKE aWindow "getID" RETURNING aHwnd
           .

       Register-Callbacks SECTION.
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > defaultMenuItems
               PERFORM Register-Callback
           END-PERFORM

      *    Always register a callback to delete the dictionary item
      *    when the containing window is deleted.
           MOVE ProgramID & z"OnDestroyed" TO MessageName
           INVOKE EntryCallBack "new" USING MessageName
                                  RETURNING aCallback
           MOVE P2Ce-Destroyed TO i
           INVOKE aWindow "SetEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

           PERFORM SaveDataBlockPointer
           .

       Register-Callback SECTION.
           IF mCallback(i) NOT = SPACES
               INVOKE EntryCallback "new" USING mCallback(i)
                                      RETURNING aCallback
               MOVE p2ce-menuSelect TO j
               INVOKE mReference(i) "setEvent" USING j aCallback
               INVOKE aCallback "finalize" RETURNING aCallback
           END-IF
           .


       Update-Menu-Text SECTION.

      * Update the menu text of the menu item index numeric-value
      * using the text in menu-text.
           IF mReference(CUSTOMER-Numeric-Value) NOT = NULL
               MOVE CUSTOMER-Menu-Text TO tempBuffer
               PERFORM String-From-tempBuffer
               INVOKE mReference(CUSTOMER-Numeric-Value) "setLabel"
                                                   USING aString

      * Update the menu text stored in the menu item table.
               INVOKE aString "sizeInBytes" RETURNING i
               INVOKE aString "finalize" RETURNING aString
               MOVE CUSTOMER-Menu-Text TO
                                         mString(CUSTOMER-Numeric-Value)
               MOVE x"0000"   TO
                                mString(CUSTOMER-Numeric-Value)(i + 1:2)
           END-IF
           .

       Toggle-CheckMark SECTION..
           IF mReference(CUSTOMER-Numeric-Value) NOT = NULL
               INVOKE mReference(CUSTOMER-Numeric-Value) "toggle"
           END-IF
           .

       Enable-Object SECTION.
           IF mReference(CUSTOMER-Numeric-Value) NOT = NULL
               INVOKE mReference(CUSTOMER-Numeric-Value) "enable"
           END-IF
           .

       Disable-Object SECTION.
           IF mReference(CUSTOMER-Numeric-Value) NOT = NULL
               INVOKE mReference(CUSTOMER-Numeric-Value) "disable"
           END-IF
           .

       Delete-Menu-Item SECTION.
           IF mReference(CUSTOMER-Numeric-Value) NOT = NULL
              AND CUSTOMER-Numeric-Value > 0
              AND CUSTOMER-Numeric-Value <= numberOfMenuItems

      * Get hold of the menu bar reference
               SET aMenuBar TO mReference(CUSTOMER-Numeric-Value)
               MOVE 0 TO wsBool
               PERFORM UNTIL isTrue
                   INVOKE aMenuBar "getAncestor" RETURNING aMenuBar
                   INVOKE aMenuBar "isMenuBar" RETURNING wsBool
               END-PERFORM

      * Delete any associated tool bar button.
      * Note: This code assumes each menu item has no more than
      *       one associated button.
               PERFORM VARYING i FROM 1 BY 1 UNTIL i > numberOfButtons
                   IF bMenuIndex(i) = CUSTOMER-Numeric-Value
                       IF bReference(i) NOT = NULL
                           INVOKE bReference(i) "finalize"
                                               RETURNING bReference(i)
                           SET bReference(i) TO NULL
                           EXIT PERFORM
                       END-IF
                   END-IF
               END-PERFORM

      * Delete the menu item
               INVOKE mReference(CUSTOMER-Numeric-Value) "destroy"

      * Re-draw the menu bar just in case the item deleted
      * was visible
               INVOKE aMenuBar "reDraw"

               SET mReference(CUSTOMER-Numeric-Value) TO NULL
           END-IF
           .

       Add-Menu-Item SECTION.
           IF numberOfMenuItems < maxMenuItems

      * If an invalid menu index was specified, don't add the menu item.
           IF CUSTOMER-Numeric-Value < 1
              OR CUSTOMER-Numeric-Value > numberOfMenuItems
               MOVE 1                  TO displayNumber
               MOVE numberOfMenuItems  TO displayNumber2
               MOVE SPACES TO tempBuffer
               STRING "Please specify a menu index in the range "
                                               DELIMITED BY SIZE
                      displayNumber            DELIMITED BY SIZE
                      " to "                   DELIMITED BY SIZE
                      displayNumber2           DELIMITED BY SIZE
                      "."                      DELIMITED BY SIZE
                   INTO tempBuffer
               END-STRING
               PERFORM Display-Warning-Message

               EXIT SECTION
           END-IF

      * If an invalid menu item was specified, don't add the menu item.
           IF mReference(CUSTOMER-Numeric-Value) = NULL
               MOVE CUSTOMER-Numeric-Value TO displayNumber
               MOVE SPACES TO tempBuffer
               STRING "The object reference stored for menu index "
                                               DELIMITED BY SIZE
                      displayNumber            DELIMITED BY SIZE
                      " was null,"&x"0A"
                      &"therefore a menu item cannot be added."
                                               DELIMITED BY SIZE
                   INTO tempBuffer
               END-STRING
               PERFORM Display-Warning-Message

               EXIT SECTION
           END-IF

           MOVE CUSTOMER-Menu-Text TO tempBuffer
           PERFORM String-From-tempBuffer
           ADD 1 TO numberOfMenuItems

      * Flag indicating type of menu item to add
           MOVE CUSTOMER-Numeric-Value2 TO newMenuType

      * Add the menu item

           IF addBefore
      * CUSTOMER-Numeric-Value is the menu index to insert before
               INVOKE mReference(CUSTOMER-Numeric-Value) "getAncestor"
                                       RETURNING subMenuReference
               IF addSubMenu
                   INVOKE subMenuReference "addSubMenuBefore"
                                    USING aString
                                      mReference(CUSTOMER-Numeric-Value)
                                RETURNING mReference(numberOfMenuItems)

               ELSE
                   IF addSeparator
                       INVOKE subMenuReference "addSeparatorBefore"
                                USING mReference(CUSTOMER-Numeric-Value)
                                RETURNING mReference(numberOfMenuItems)
                   ELSE
                       INVOKE subMenuReference "addItemBefore"
                                    USING aString
                                      mReference(CUSTOMER-Numeric-Value)
                                RETURNING mReference(numberOfMenuItems)
                   END-IF

               END-IF


           ELSE
      * CUSTOMER-Numeric-Value is the menu index of the sub menu or a menu item
      * on the sub menu to add to the end of.
               INVOKE mReference(CUSTOMER-Numeric-Value) "isSubMenu"
                                           RETURNING wsBool
               IF isFalse
                 INVOKE mReference(CUSTOMER-Numeric-Value) "getAncestor"
                                           RETURNING subMenuReference
               ELSE
                   SET subMenuReference
                               TO mReference(CUSTOMER-Numeric-Value)
               END-IF


               IF addSubMenu
                   INVOKE subMenuReference "addSubMenu"
                                     USING aString
                                 RETURNING mReference(numberOfMenuItems)

               ELSE
                   IF addSeparator
                       INVOKE subMenuReference "addSeparator"
                                 RETURNING mReference(numberOfMenuItems)
                   ELSE
                       INVOKE subMenuReference "addItem"
                                     USING aString
                                 RETURNING mReference(numberOfMenuItems)
                   END-IF

               END-IF

           END-IF

           *> Store the menu text in the table
           INVOKE aString "getValue"
                               RETURNING mString(numberOfMenuItems)

           *> NULL terminate the stored menu text
           INVOKE aString "sizeInBytes" RETURNING i
           MOVE x"0000" TO mString(numberOfMenuItems)(i + 1:2)

           INVOKE aString "finalize" RETURNING aString

      * Return index of new menu item. This will be displayed
      * in the "Menu index" entry field once the new menu item
      * has been added.
           MOVE numberOfMenuItems TO CUSTOMER-Numeric-Value

      * Add hint text (if specified)
           IF CUSTOMER-Menu-Hint-Text NOT = spaces
               MOVE CUSTOMER-Menu-Hint-Text TO tempBuffer
               PERFORM String-From-tempBuffer
               INVOKE mReference(numberOfMenuItems) "setStatusText"
                                               USING aString
               INVOKE aString "finalize" RETURNING aString
           END-IF

      * Setup callback (if specified)
           MOVE CUSTOMER-Callback-Entry-Name TO
                                       mCallback(numberOfMenuItems)
           MOVE numberOfMenuItems TO i
           PERFORM Register-Callback

      * Setup accelerator key (if specified)
           IF CUSTOMER-Accel-Key NOT = 0
               MOVE CUSTOMER-Accel-Flags
                       TO K-keyFlags of mAccelKey(numberOfMenuItems)
               MOVE CUSTOMER-Accel-Key
                       TO K-keyAsNum of mAccelKey(numberOfMenuItems)
               INVOKE mReference(numberOfMenuItems) "setAccelerator"
                                      USING mAccelKey(numberOfMenuItems)
           END-IF

           ELSE
               MOVE maxMenuItems TO displayNumber
               MOVE SPACES TO tempBuffer
               STRING "Cannot add more than "        DELIMITED BY SIZE
                      displayNumber                  DELIMITED BY SIZE
                      " menu items."                 DELIMITED BY SIZE
                       INTO tempBuffer
                   END-STRING
               PERFORM Display-Warning-Message

           END-IF
           .

       Add-Toolbar-Button SECTION.

           IF numberOfButtons < maxButtons

      * Check that a valid menu reference has been supplied, if not
      * then don't add the toolbar button.
           IF CUSTOMER-Numeric-Value NOT = 0 *> Not adding a separator
               IF CUSTOMER-Numeric-Value <= numberOfMenuItems
                   IF mReference(CUSTOMER-Numeric-Value) = NULL
                    MOVE CUSTOMER-Numeric-Value TO displayNumber
                    MOVE SPACES TO tempBuffer
                    STRING "The object reference stored for menu index "
                                                DELIMITED BY SIZE
                       displayNumber            DELIMITED BY SIZE
                       " was null."&x"0A"
                       &"A button must be associated with a menu item,"
                       &x"0A"&"therefore a button cannot be added."
                                               DELIMITED BY SIZE
                       INTO tempBuffer
                    END-STRING
                    PERFORM Display-Warning-Message

                    EXIT SECTION
                   END-IF
               ELSE
                   MOVE 1                  TO displayNumber
                   MOVE numberOfMenuItems  TO displayNumber2
                   MOVE SPACES TO tempBuffer
                   STRING "Please specify a menu index in the range "
                                                   DELIMITED BY SIZE
                          displayNumber            DELIMITED BY SIZE
                          " to "                   DELIMITED BY SIZE
                          displayNumber2           DELIMITED BY SIZE
                          "."                      DELIMITED BY SIZE
                       INTO tempBuffer
                   END-STRING
                   PERFORM Display-Warning-Message

                   EXIT SECTION
               END-IF

      * Only allow one button per menu item on this toolbar
      * (this is a restriction imposed by the Win32 API)
               PERFORM VARYING i FROM 1 BY 1 UNTIL i > numberOfButtons
                   IF bMenuIndex(i) = CUSTOMER-Numeric-Value
                      AND bReference(i) NOT = NULL
                       MOVE CUSTOMER-Numeric-Value TO displayNumber
                       MOVE SPACES TO tempBuffer
                       STRING "Menu index "        DELIMITED BY SIZE
                              displayNumber        DELIMITED BY SIZE
                            " already has an associated toolbar button,"
                            &x"0A"&"therefore a button cannot be added."
                                                   DELIMITED BY SIZE
                           INTO tempBuffer
                       END-STRING
                       PERFORM Display-Warning-Message

                       EXIT SECTION
                   END-IF
               END-PERFORM

           END-IF

           ADD  1 TO numberOfButtons

      * Setup menu item index associated with this tool bar button
           MOVE CUSTOMER-Numeric-Value TO bMenuIndex(numberOfButtons)

           MOVE CUSTOMER-Resource-File TO tempBuffer
           PERFORM String-From-tempBuffer

      * Load bitmap resource file
           INVOKE module "new" USING aString
                           RETURNING aResource

      * Add button bitmap
           MOVE 1 TO numberOfImages

           MOVE CUSTOMER-Resource-ID TO bBitmapID(numberOfButtons)
           MOVE numberOfButtons TO i
           PERFORM Add-Button-Bitmap
           INVOKE aToolBar "setImageList" USING buttonImageList

      * Add tool bar button and set tool tip (if specified)
           MOVE CUSTOMER-Tool-Tip-Text TO bString(numberOfButtons)
           MOVE numberOfButtons TO wsIndex
           PERFORM Add-Indexed-Button

      * If CUSTOMER-Numeric-Value is non-zero then insert button before
      * button index CUSTOMER-Numeric-Value2, otherwise add button to end
      * of tool bar.
           IF CUSTOMER-Numeric-Value2 > 0
              AND CUSTOMER-Numeric-Value2 < numberOfButtons
               INVOKE bReference(numberOfButtons) "insertAt"
                                            USING CUSTOMER-Numeric-Value2
           END-IF

      * Create and show the new button
           INVOKE bReference(numberOfButtons) "create"
           INVOKE bReference(numberOfButtons) "show"

           ELSE
               MOVE maxButtons TO displayNumber
               MOVE SPACES TO tempBuffer
               STRING "Cannot add more than "        DELIMITED BY SIZE
                      displayNumber                  DELIMITED BY SIZE
                      " buttons."                    DELIMITED BY SIZE
                   INTO tempBuffer
               END-STRING
               PERFORM Display-Warning-Message

           END-IF
           .

      *>----------------------------------------------
      *> Callback entry point for menu items defined
      *>----------------------------------------------

      *
       On-Item-Selected SECTION.
       Entry ProgramID & "OnItemSelected" USING anEvent.

          INVOKE aToolbar "setInputFocus"
          PERFORM GetEventHwnd
          PERFORM GetDataBlockPointer

           *> Build text string containing name of menu item selected
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > numberOfMenuItems
               IF mReference(i) = menuItem
                   ADD i TO 40000 GIVING Event-Type
                   SUBTRACT 1 FROM Event-Type
                   EXIT PERFORM
               END-IF
           END-PERFORM

          *> Post a Panels2 User Event to the Dialog System window
          *> to execute the correct dialog
          PERFORM Post-User-Event-Routine

          EXIT PROGRAM.
          .

       On-Set-Win-Focus SECTION.
       ENTRY ProgramID & "OnSetWinFocus" USING anEvent.
           PERFORM GetEventHwnd
      * Get the menu text of the selected item
           INVOKE menuItem "getLabel" RETURNING aString
           MOVE SPACES TO tempBuffer
           INVOKE aString "getValue" RETURNING tempBuffer
           INVOKE aString "finalize" RETURNING aString


      * Return the index of the window to set focus on in Numeric-Value
           PERFORM GetDataBlockPointer
           MOVE windowNumber TO Customer-Numeric-Value

           MOVE 34655  TO Event-Type
           PERFORM Post-User-Event-Routine

           EXIT PROGRAM.


       GetWindow-Instance-Routine section.

      *   Use the Correct handle Storage format for getting
      *   the object reference... This is not a new window, just
      *   obtaining an object reference for an existing window

          INVOKE Window "fromHandle" USING aHwnd
                                     RETURNING aWindow
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

          IF buttonImageList NOT = NULL
             INVOKE buttonImageList "finalize"
                                     RETURNING buttonImageList
          END-IF

          INVOKE anEvent "getObject" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL
          EXIT PROGRAM
          .
          .

