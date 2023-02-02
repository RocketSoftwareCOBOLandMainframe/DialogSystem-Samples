      $set mfoo
       copy "windows.cpy".
       program-id. "riched".

       copy "callconv.cpy".

       class-control.
          Window                   is class "window"
          CharacterArray           is class "chararry"
          OrderedCollection        is class "ordrdcll"
          Association              is class "associtn"
          Dictionary               is class "dictinry"
          CobolComp5               is class "comp5"
          KeyBrd                   is class "keyboard"
          MessageBox               is class "msgbox"
          EntryCallback            is class "entrycll"
          Color                    is class "color"
          Mouse                    is class "mouse"
          Font                     is class "font"
          RichEdit                 is class "richedit"
          Module                   is class "module"
          Toolbar                  is class "toolbar"
          MaskedImageList          is class "mskimglt"
          BitmapData               is class "bitmapd"
          OpenDlg                  is class "opendlg"
          SaveDlg                  is class "savedlg"
          FontDlg                  is class "fontdlg"
          MiniWnd                  is class "miniwnd"
          SysInfo                  is class "sysinfo"
          COBOLPicX                is class "picx"
          .

      * This file provides the initial program section structure
        copy "strcture.cpy".

      * Entry point names within this program are prefixed with
      * the program ID to ensure that they are unique across
      * different template programs.
        78 ProgramID                value "riched".

      * Name of resource file containing toolbar button bitmaps.
      * Please refer to the chapter "Using the Control Templates" in the
      * on-line book Dialog System User Guide for information on
      * creating a resource DLL.
       78 resourceDllName          value z"tbar.dll".

          copy "tbresid.cpy". *> Resource IDs for toolbar button bitmaps

      *   This file details the GUI class library event codes
          copy "p2cevent.cpy".

          copy "keys.cpy".

      *   The Callout control block - We need the P2-MF-reserved
      *   value that this gives us
          copy "ds-call.cpy".

      *>----------------------------------------------------------------
      *> Toolbar button definitions.
      *>----------------------------------------------------------------

      * The maximum number of buttons that can be stored within
      * the button data table.
       78 maxButtons               value 30.

      * Maximum length of tool tip text.
       78 bStringSize              value 55.

      * Size of each button record (one record per button).
       78 bRecSize                 value 63. *> 4 + 4 + 55

       78 bCallbackName value '"' & ProgramID & z'OnWindowCommand"'.

       01 bData.
       78 bDataStart               value NEXT.

      ***>>> Start USER BUTTON DATA <<<***
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-OPEN.
          03   pic x(bStringSize)  value z"Open".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-SAVE.
          03   pic x(bStringSize)  value z"Save".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize)  value SPACES.
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-BOLD.
          03   pic x(bStringSize)  value z"Bold".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-ITALIC.
          03   pic x(bStringSize)  value z"Italic".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-ULINE.
          03   pic x(bStringSize)  value z"Underline".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize)  value SPACES.
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-LEFT.
          03   pic x(bStringSize)  value z"Align Left".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-CENTER.
          03   pic x(bStringSize)  value z"Center".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-RIGHT.
          03   pic x(bStringSize)  value z"Align Right".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize)  value SPACES.
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x(4) comp-5     value IDB-FONT.
          03   pic x(bStringSize)  value z"Font".
      *>----------------------------------------------------------------
      ***>>> End USER BUTTON DATA <<<***

       78 defaultButtons           value NEXT - bDataStart / bRecSize.

       01 bTable redefines bData occurs maxButtons.
          03 bReference            object reference.
          03 bBitmapID             pic x(4) comp-5.
          03 bString               pic x(bStringSize).
       01 numberOfButtons          pic x(4) comp-5 value
                                   defaultButtons.

       01 aResource                object reference.
       01 aToolbar                 object reference.
       01 buttonImageList          object reference.
       01 aBitmap                  object reference.
       01 aString                  object reference.

       01 resourceID               pic x(4) comp-5.
       01 Width                    pic x(4) comp-5.
       01 Height                   pic x(4) comp-5.
       01 numberOfImages           pic x(4) comp-5.
       01 buttonIndex              pic x(4) comp-5.

       01 wsIndex                  pic s9(9) comp-5.

       01 aRichEdit                 object reference value null.
       01 aMiniWnd                  object reference.
       01 fntPtSize                 pic x(4) comp-5.
       01 fntFlags                  pic x(4) comp-5.

       01 wsNull                    object reference value null.

       01 filler                   pic x comp-5.
          88 Handle-Event-In-Screenset value 1 false 0.

       78 CharFormatIndex          value 4.
       78 ParaFormatIndex          value 8.

       01 Keystroke                K-KEYDESC.
       01 aGadgetHWND              Pic 9(9) comp-5.
       01 aNextFocusHWND           Pic 9(9) comp-5.
       01 aControl                 object reference.

       01 filler                   pic x comp-5 value 1.
          88 CanHideToolbar value 1 false 0.

       01 REDict                   object reference value null.
       01 aPicX8Class              object reference value null.
       01 objobjAssoc              object reference.

       local-storage section.

       01 lsFontDialog             object reference.
       01 lsFileDialog             object reference.
       01 lsFont                   object reference.
       01 lsForeColor              object reference.
       01 lsToolbarData.
          03 lsTDRichEdit          object reference.
          03 lsTDFilename          object reference.
       01 lsObject                 object reference.
       01 lsString                 object reference.
       01 lsBool                   pic x comp-5.
          88 isTrue value 1.
          88 isFalse value 0.
       01 lsBool2                  pic x comp-5.
          88 isTrue2 value 1.
          88 isFalse2 value 0.
       01 lsRichEdit               object reference.
       01 lsMiniWnd                object reference.
       01 lsToolbar                object reference.
       01 lsButton                 object reference.
       01 lsWindow                 object reference.
       01 lsParent                 object reference.
       01 lsIndex                  pic x(4) comp-5.
       01 lsHwnd                   pic x(4) comp-5.
       01 lsID                     pic x(4) comp-5.
       01 lsCmdID                  pic x(4) comp-5.

       linkage section.

      * Linkage Items:

      *   The object reference of the object receiving an event for
      *   which a callback will be defined
        01 anEvent              usage object reference.

      *   This file defines the interface for integration of this
      *   control with the Dialog System runtime
          copy "userctrl.cpy".

          copy "riched.cpb".

       01 lnkRichEdit          object reference.

       PROCEDURE DIVISION USING DSC-Control-Block
                                Data-Block
                                .

      *   Convert the Call-Function to Uppercase
          MOVE LENGTH OF Call-Function TO Function-Length
          CALL "CBL_TOUPPER" USING Call-Function
                           BY VALUE Function-Length

          EVALUATE Call-Function
          WHEN "OPEN-RTF-FILE"
               INVOKE REDict "atOrNil" USING Object-Reference
                                   RETURNING lsToolbar
               IF lsToolbar NOT = NULL
                   INVOKE Object-Reference "getAncestor"
                                       RETURNING lsWindow
                   SET lsMiniWnd TO lsWindow
                   PERFORM Open-RTF-File
               END-IF

          WHEN "SAVE-RTF-FILE"
               INVOKE REDict "atOrNil" USING Object-Reference
                                   RETURNING lsToolbar
               IF lsToolbar NOT = NULL
                   INVOKE Object-Reference "getAncestor"
                                       RETURNING lsWindow
                   SET lsMiniWnd TO lsWindow
                   PERFORM Save-File
               END-IF

          WHEN OTHER
              DISPLAY Invalid-Function, " ", Call-Function
              GO TO Rich-Edit-Program-Exit

          END-EVALUATE
          .

       Rich-Edit-Program-Exit.

          EXIT PROGRAM.


       Create-Entry-Point Section.

       Entry "C" & ProgramID USING EntryPoint-Data.

           PERFORM RichEdit-Init


           *> Do the create having been passed the Panels2 Session ID,
           *> the parent window handle, the co-ordinates for the
           *> creation of the control and the datablock master field
           *> associated with this control.

           MOVE EntryPanels-Session-ID TO Queue-ID
           MOVE EntryWindow-Data     TO aHwnd
           PERFORM GetWindow-Instance-Routine

           *> Create and initialize the Rich Edit control
           PERFORM Create-Control

           *> Update the master field with the object reference for the
           *> created control
           SET EntryObject-Reference TO aRichEdit

           *> Create a toolbar in a seperate mini window.
           *> The toolbar demonstrates some of the features
           *> of the Rich Edit control.
           PERFORM Create-Toolbar-Window

           *> Provide a link from the toolbar to it's associated
           *> Rich Edit control and RTF filename.
           SET lsTDRichEdit TO aRichEdit
           SET lsTDFilename TO NULL
           INVOKE aPicX8Class "withValue" USING lsToolbarData
                                      RETURNING lsObject
           INVOKE REDict "atPut" USING aToolbar
                                       lsObject
           *> Provide a link from the Rich Edit to it's associated
           *> toolbar.
           INVOKE REDict "atPut" USING aRichEdit
                                       aToolbar

           IF aRichEdit NOT = NULL
               PERFORM Register-Callbacks
               INVOKE aRichEdit "accessSystemEvents"
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

          SET aRichEdit TO EntryObject-Reference
          PERFORM Resize-Routine
          EXIT PROGRAM
          .

       Create-Control section.
           INVOKE RichEdit "new" USING aWindow
                             RETURNING aRichEdit

           *> Size it
           INVOKE aRichEdit "setRectangle" USING EntryPosition-X
                                                 EntryPosition-Y
                                                 EntrySize-Width
                                                 EntrySize-Height

           INVOKE aRichEdit "create"

           MOVE 6 TO i
           MULTIPLY 1440 BY i
           INVOKE aRichEdit "setLineWidth" USING i

           INVOKE CharacterArray "withValue" USING z"MS Sans Serif"
                                         RETURNING aCharArray
           MOVE 8 TO fntPtSize
           MOVE 0 TO fntFlags
           INVOKE Font "new" USING aCharArray
                                   fntPtSize
                                   fntFlags
                         RETURNING aFont
           INVOKE aRichEdit "SetFont" USING aFont
           INVOKE aCharArray "finalize" RETURNING aCharArray

           INVOKE aRichEdit "show"
           .

       Create-Toolbar-Window section.
           *> Create a mini window to be the parent of the toolbar
           INVOKE MiniWnd "new" USING aWindow
                            RETURNING aMiniWnd

           *> Position in top right hand corner of Rich Edit control
           INVOKE aRichEdit "getRectangle" USING i j k l
           SUBTRACT 924 FROM k GIVING wsIndex
           IF wsIndex > 0
               ADD wsIndex TO i
           END-IF
           *> Size it to fit the number of buttons on the toolbar
           MOVE 924 TO k
           MOVE 92 TO l
           INVOKE aMiniWnd "setRectangle" USING i j k l

           *> Set the window background color, title and styles
           INVOKE SysInfo "GetButtonFaceColor" RETURNING aBackColor
           INVOKE aMiniWnd "SetBackgroundColor" USING aBackColor
           INVOKE aBackColor "finalize" RETURNING aBackColor
           INVOKE aMiniWnd "setTitleZ" USING z"Rich Edit Toolbar"
           INVOKE aMiniWnd "noSizeBorder"
           INVOKE aMiniWnd "noSysMenu"
           INVOKE aMiniWnd "noMaxButton"

           *> Create the toolbar on the mini window
           INVOKE toolbar "new" USING aMiniWnd
                            RETURNING aToolbar

           *> Set the styles
           INVOKE aToolbar "flat"
           INVOKE aToolbar "noDivider"

           *> Set tool bar width and height
           MOVE 16 TO height
           INVOKE aToolbar "setHeight" USING height
           INVOKE aWindow "getWidth" RETURNING width
           INVOKE aToolbar "setWidth" USING width

           *> Make the tool bar resizable
           INVOKE aToolbar "resizable"

           *> Set the width and height of the buttons
           MOVE 16 TO width
           MOVE 16 TO height
           INVOKE aToolbar "setBitmapWidthHeight" USING width height

           *> Process the toolbar bitmaps and buttons
           PERFORM Process-Bitmaps
           PERFORM Process-Buttons
           .

       Process-Buttons SECTION.
      * Associate toolbar buttons with menu items and add them
      * to the toolbar
           MOVE 1 TO buttonIndex
           PERFORM varying wsIndex from 1 by 1
                           until wsIndex > defaultButtons
               PERFORM Add-Indexed-Button

           END-PERFORM
           .

       Add-Indexed-Button SECTION.

           IF bBitmapID(wsIndex) = 0
      * Add separator
               INVOKE aToolBar "addSeparator"
                                     RETURNING bReference(wsIndex)

           ELSE
      * Add button
               INVOKE aToolbar "addTool" USING buttonIndex
                                               wsNull
                                     RETURNING bReference(wsIndex)
               add 1 TO buttonIndex

      * Set tool tip (if specified)
               IF bString(wsIndex) NOT = SPACES
                   INVOKE bReference(wsIndex) "setTipZ"
                                             USING bString(wsIndex)
               END-IF

           END-IF
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
           IF bBitmapID(i) NOT = 0
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

       Register-Callbacks section.
      *    Register handler for commands sent to the toolbar window.
      *    This enables us to respond to commands sent by toolbar
      *    buttons
           INVOKE EntryCallback "new" USING bCallbackName
                                  RETURNING aCallback
           MOVE p2ce-command TO j
           INVOKE aMiniWnd "setEvent" USING j aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Selection changed in Rich Edit control
           MOVE '"' & ProgramID & z'OnRESelectionChanged"'
                                                   TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-SelectionChanged TO i
           INVOKE aRichEdit "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Rich Edit control gain focus
           MOVE '"' & ProgramID & z'OnREGainFocus"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-gainfocus TO i
           INVOKE aRichEdit "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Rich Edit control lose focus
           MOVE '"' & ProgramID & z'OnRELoseFocus"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-losefocus TO i
           INVOKE aRichEdit "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    MiniWnd lose focus
           MOVE '"' & ProgramID & z'OnMWLoseFocus"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-losefocus TO i
           INVOKE aMiniWnd "setEvent" USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *    Enable Shift+TAB to tab to previous control
           MOVE '"' & ProgramID & z'REFunctionKey"' TO MessageName
           INVOKE EntryCallback "new" USING MessageName
                                  RETURNING aCallback
           MOVE p2ce-FunctionKey TO i
           INVOKE aRichEdit "setEvent"  USING i aCallback
           INVOKE aCallback "finalize" RETURNING aCallback

      *   Always register a callback to delete the dictionary item
      *   when the containing window is deleted.
          MOVE '"' & ProgramID & z'OnDestroyed"' TO MessageName
          INVOKE EntryCallBack "new" USING MessageName
                                 RETURNING aCallback
          MOVE P2Ce-Destroyed TO i
          INVOKE aRichEdit "SetEvent" USING i aCallback
          INVOKE aCallback "finalize" RETURNING aCallback

          PERFORM SaveDataBlockPointer
          .


       On-RE-Selection-Changed section.
       Entry ProgramID & "OnRESelectionChanged" USING anEvent.
      * The selection in the Rich Edit control has changed.
      * Update the toolbar button states to reflect the change.
           INVOKE anEvent "getObject" RETURNING lsRichEdit
           INVOKE REDict "atOrNil" USING lsRichEdit
                               RETURNING lsToolbar

           PERFORM RE-Selection-Changed

           EXIT PROGRAM
           .

       RE-Selection-Changed section.
           IF lsToolbar = NULL
               EXIT PROGRAM
           END-IF

           *> Check Bold, Italic and Underline
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > 3
               ADD CharFormatIndex TO i GIVING j
               SUBTRACT 1 FROM j
               INVOKE lsToolbar "toolAtIndex" USING j
                                          RETURNING lsButton
               PERFORM Get-First-Char-Effect
               IF isTrue
                   *> First character is bold/italic/underline
                   PERFORM Is-Effect-Consistent
                   IF isTrue
                       *> Effect is consistant throughout selection
                       INVOKE lsButton "isChecked" RETURNING lsBool
                       IF isFalse
                           INVOKE lsButton "check"
                       END-IF
                       INVOKE lsButton "isIndeterminate"
                                               RETURNING lsBool
                       IF isTrue
                           INVOKE lsButton "notIndeterminate"
                       END-IF

                   ELSE
                       INVOKE lsButton "isIndeterminate"
                                               RETURNING lsBool
                       IF isFalse
                           INVOKE lsButton "indeterminate"
                       END-IF

                   END-IF

               ELSE
                   *> Char format off
                   INVOKE lsButton "isChecked" RETURNING lsBool
                   IF isTrue
                       INVOKE lsButton "uncheck"
                   END-IF
                   INVOKE lsButton "isIndeterminate"
                                               RETURNING lsBool
                   IF isTrue
                       INVOKE lsButton "notIndeterminate"
                   END-IF
               END-IF

           END-PERFORM

           *> Check paragraph formatting
           INVOKE lsRichEdit "isParaFormatConsistent" RETURNING lsBool
           IF isTrue
               *> Specified alignment is consistent

               *> Remove indeterminate state if set
               MOVE ParaFormatIndex TO j
               INVOKE lsToolbar "toolAtIndex"
                                   USING j
                               RETURNING lsButton
               INVOKE lsButton "isIndeterminate" RETURNING lsBool
               IF isTrue
                   MOVE ParaFormatIndex TO j
                   PERFORM 3 TIMES
                       INVOKE lsToolbar "toolAtIndex"
                                               USING j
                                           RETURNING lsButton
                       INVOKE lsButton "notIndeterminate"
                       ADD 1 TO j
                   END-PERFORM
               END-IF

               *> Uncheck all para format buttons
               MOVE ParaFormatIndex TO j
               PERFORM 3 TIMES
                   INVOKE lsToolbar "uncheckToolAtIndex" USING j
                   ADD 1 TO j
               END-PERFORM

               *> Check appropriate button
               MOVE ParaFormatIndex TO j
               INVOKE lsRichEdit "isCentered" RETURNING lsBool
               IF isTrue
                   ADD 1 TO j
               ELSE
                   INVOKE lsRichEdit "isRightJustified" RETURNING lsBool
                   IF isTrue
                       ADD 2 TO j
                   END-IF
               END-IF
               INVOKE lsToolbar "checkToolAtIndex" USING j

           ELSE
               *> Alignment is not consistant.
               *> Make all three buttons indeterminate
               MOVE ParaFormatIndex TO i
               PERFORM 3 TIMES
                   INVOKE lsToolbar "toolAtIndex" USING i
                                              RETURNING lsButton
                   INVOKE lsButton "indeterminate"
                   ADD 1 TO i
               END-PERFORM
           END-IF
           .

       Get-First-Char-Effect section.
           EVALUATE i
               WHEN 1
                   INVOKE lsRichEdit "isCharBold"
                                           RETURNING lsBool
               WHEN 2
                   INVOKE lsRichEdit "isCharItalic"
                                           RETURNING lsBool
               WHEN 3
                   INVOKE lsRichEdit "isCharUnderline"
                                           RETURNING lsBool
           END-EVALUATE
           .

       Is-Effect-Consistent section.
           EVALUATE i
               WHEN 1
                   INVOKE lsRichEdit "isBoldConsistent"
                                           RETURNING lsBool
               WHEN 2
                   INVOKE lsRichEdit "isItalicConsistent"
                                           RETURNING lsBool
               WHEN 3
                   INVOKE lsRichEdit "isUnderlineConsistent"
                                           RETURNING lsBool
           END-EVALUATE
           .

       On-Window-Command SECTION.
       Entry ProgramID & "OnWindowCommand" USING anEvent.

           INVOKE anEvent "getObject" RETURNING lsMiniWnd
           INVOKE lsMiniWnd "getAncestor" RETURNING lsWindow
           INVOKE lsWindow "getID" RETURNING aHwnd

      *    Was this a toolbar button command or something else?
           INVOKE anEvent "getCommand" RETURNING lsCmdID
           INVOKE lsMiniWnd "getFirstChild" RETURNING lsToolbar
           INVOKE lsToolbar "toolFromID" USING lsCmdID
                                     RETURNING lsButton
           IF lsButton = NULL
               EXIT PROGRAM *> Some other command we're not
                            *> interrested in
           END-IF
           INVOKE lsButton "getIndex" RETURNING i

           SET Handle-Event-In-Screenset TO FALSE
           EVALUATE i
               WHEN 1
                   PERFORM Open-RTF-File

               WHEN 2
                   PERFORM Save-File

               WHEN CharFormatIndex
               WHEN CharFormatIndex + 1
               WHEN CharFormatIndex + 2
                   PERFORM Handle-Char-Format

               WHEN ParaFormatIndex
               WHEN ParaFormatIndex + 1
               WHEN ParaFormatIndex + 2
                   PERFORM Handle-Para-Format

               WHEN 12
                   PERFORM Select-Font

               WHEN OTHER
                   SET Handle-Event-In-Screenset TO TRUE
           END-EVALUATE

           IF Handle-Event-In-Screenset
               MOVE 37000 TO Event-Type

               *> Post a Panels2 User Event to the Dialog System window
               *> to execute the correct dialog
               PERFORM Post-User-Event-Routine
           END-IF

           EXIT PROGRAM.
           .

       On-RE-Gain-Focus SECTION.
       Entry ProgramID & "OnREGainFocus" USING anEvent.
           *> Show the formatting toolbar when the Rich Edit gains focus
           INVOKE anEvent "getObject" RETURNING lsRichEdit
           INVOKE REDict "atOrNil" USING lsRichEdit
                               RETURNING lsToolbar
           IF lsToolbar NOT = NULL
               INVOKE lsToolbar "getAncestor" RETURNING lsMiniWnd
               INVOKE lsMiniWnd "showNoFocus"
               INVOKE lsToolbar "showNoFocus"
               INVOKE lsRichEdit "setInputFocus"
           END-IF
           EXIT PROGRAM
           .

       On-RE-Lose-Focus SECTION.
       Entry ProgramID & "OnRELoseFocus" USING anEvent.
           *> If focus was lost to the toolbar or it's parent,
           *> then don't bother to hide the mini window
           INVOKE anEvent "getObject" RETURNING lsRichEdit
           INVOKE REDict "atOrNil" USING lsRichEdit
                               RETURNING lsToolbar
           INVOKE lsToolbar "getAncestor" RETURNING lsMiniWnd
           INVOKE lsMiniWnd "getID" RETURNING i
           INVOKE lsToolbar "getID" RETURNING j
           CALL WAPI GetFocus RETURNING lsHwnd
           IF NOT (lsHwnd = i
              OR lsHwnd = j)
               INVOKE lsMiniWnd "hide"
           END-IF

           EXIT PROGRAM
           .

       On-MW-Lose-Focus SECTION.
       Entry ProgramID & "OnMWLoseFocus" USING anEvent.
           *> Hide the toolbar if focus not set to it's Rich Edit
           *> unless CanHideToolbar is set to FALSE
           IF CanHideToolbar
               INVOKE anEvent "getObject" RETURNING lsMiniWnd
               INVOKE lsMiniWnd "getFirstChild" RETURNING lsToolbar
               INVOKE REDict "atOrNil" USING lsToolbar
                                   RETURNING lsObject
               IF lsObject NOT = NULL
                   INVOKE lsObject "getValue" RETURNING lsToolbarData
                   IF lsTDRichEdit NOT = NULL
                       INVOKE lsTDRichEdit "getID" RETURNING i
                       CALL WAPI GetFocus RETURNING lsHwnd
                       IF lsHwnd NOT = i
                           INVOKE lsMiniWnd "hide"
                       END-IF
                   END-IF
               END-IF
           ELSE
               SET CanHideToolbar TO TRUE
           END-IF

           EXIT PROGRAM
           .

       RE-Function-Key section.
       Entry ProgramID & "REFunctionKey" USING anEvent.
           *> Shift+TAB will tab to previous control (if any)
           INVOKE anEvent "getObject" RETURNING aControl
           INVOKE aControl "getAncestor" RETURNING lsWindow
           INVOKE anEvent "getCharacterCode"
                               RETURNING K-Key OF Keystroke

           IF K-KeyAsNum = OVK-TAB
               PERFORM SetNextFocus
           END-IF

           EXIT PROGRAM
           .

       SetNextFocus section.

          *> This is required because we intercept all functionkeys
          *> for this control, (including TAB) which would
          *> otherwise move focus to the next object in order...
          *> so we must do it ourselves

          *> NOTE - For Rich Edit control, only Shift+TAB should
          *> tab to the next control, as TAB on its own should
          *> insert a TAB into the Rich Edit control
          INVOKE anEvent "ShiftDepressed" RETURNING lsBool
          IF isFalse
              EXIT SECTION
          END-IF

          INVOKE lsWindow "getID" RETURNING aHWND
          INVOKE aControl "getID" RETURNING aGadgetHWND
          CALL WAPI GetNextDlgTabItem USING BY VALUE aHWND
                                                     aGadgetHWND
                                                     1
                                           RETURNING aNextFocusHWND
          INVOKE window "fromHandle" USING aNextFocusHWND
                                 RETURNING anObject
          INVOKE anObject "setFocus"

          INVOKE anEvent "setProcessed"
          .

       Save-File section.
           INVOKE REDict "atOrNil" USING lsToolbar
                               RETURNING anObject
           INVOKE anObject "getValue" RETURNING lsToolbarData
           IF lsTDFilename = NULL
               PERFORM SaveAs-RTF-File
           ELSE
               PERFORM Save-RTF-File
           END-IF
           .

       Select-Font section.
           INVOKE FontDlg "new" USING lsWindow
                            RETURNING lsFontDialog
           INVOKE REDict "atOrNil" USING lsToolbar
                               RETURNING lsObject
           INVOKE lsObject "getValue" RETURNING lsToolbarData
           INVOKE lsTDRichEdit "getFont" RETURNING lsFont
           IF lsFont NOT = NULL
               INVOKE lsFontDialog "setInitialFont" USING lsFont
           END-IF

           SET CanHideToolbar TO FALSE
           INVOKE lsMiniWnd "disable"
           INVOKE lsFontDialog "show"
           INVOKE lsMiniWnd "enable"
           INVOKE lsTDRichEdit "setInputFocus"

           *> Get the font and color
           INVOKE lsFontDialog "getFont" RETURNING lsFont
           INVOKE lsFontDialog "getColor" RETURNING lsForeColor
           INVOKE lsFontDialog "finalize" RETURNING lsFontDialog

           IF lsFont NOT = NULL
               INVOKE lsTDRichEdit "setFont" USING lsFont
           END-IF

           IF lsForeColor NOT = NULL
               INVOKE lsTDRichEdit "setColor" USING lsForeColor
           END-IF
           .

       RichEdit-Init section.
           *> If not created yet, setup a dictionary to store
           *> associations between objects
           IF REDict = NULL
               SET anObject TO NULL
               INVOKE Association "newClass" USING anObject
                                                   anObject
                                         RETURNING objobjAssoc
               MOVE 10 TO i
               INVOKE Dictionary "ofAssociations" USING objobjAssoc
                                             i
                                   RETURNING REDict

           END-IF

           *> Setup a new intrinsic class to store two object references
           IF aPicX8Class = NULL
               MOVE 8 TO i
               INVOKE COBOLPicX "newClass" USING i
                                       RETURNING aPicX8Class
           END-IF
           .

       Open-RTF-File section.
           *> Let user choose an RTF file to open
           INVOKE OpenDlg "new" USING lsWindow
                            RETURNING lsFileDialog
           PERFORM Add-RTF-Filter

           INVOKE REDict "atOrNil" USING lsToolbar
                               RETURNING lsObject
           INVOKE lsObject "getValue" RETURNING lsToolbarData

           SET CanHideToolbar TO FALSE
           INVOKE lsMiniWnd "disable"
           INVOKE lsFileDialog "show"
           INVOKE lsMiniWnd "enable"
           INVOKE lsTDRichEdit "setInputFocus"

           INVOKE lsFileDialog "getFile" RETURNING lsString

           INVOKE lsFileDialog "finalize" RETURNING lsFileDialog

           IF lsString NOT = NULL
               *> Open the named RTF file
               INVOKE lsTDRichEdit "openRTFFile" USING lsString

               *> Update filename for this Rich Edit control
               IF lsTDFilename NOT = NULL
                   INVOKE lsTDFilename "finalize" RETURNING lsTDFilename
               END-IF
               SET lsTDFilename TO lsString
               INVOKE lsObject "setValue" USING lsToolbarData

               *> Update the toolbar buttons
               SET lsRichEdit TO lsTDRichEdit
               PERFORM RE-Selection-Changed

           END-IF
           .

       Save-RTF-File section.
           *> Save the text in the Rich Edit Control using the
           *> current filename
           INVOKE REDict "atOrNil" USING lsToolbar
                               RETURNING lsObject
           INVOKE lsObject "getValue" RETURNING lsToolbarData
           IF lsTDFilename NOT = NULL
               INVOKE lsTDRichEdit "saveRTFFile" USING lsTDFilename
           END-IF
           .

       SaveAs-RTF-File section.
           *> Let user specify a filename
           INVOKE SaveDlg "new" USING lsWindow
                            RETURNING lsFileDialog
           PERFORM Add-RTF-Filter

           INVOKE lsFileDialog "OverWritePrompt"

           SET CanHideToolbar TO FALSE
           INVOKE lsMiniWnd "disable"
           INVOKE lsFileDialog "show"
           INVOKE lsMiniWnd "enable"
           INVOKE lsTDRichEdit "setInputFocus"

           INVOKE lsFileDialog "getFile" RETURNING lsString

           INVOKE lsFileDialog "finalize" RETURNING lsFileDialog

           IF lsString NOT = NULL
               INVOKE REDict "atOrNil" USING lsToolbar
                                   RETURNING lsObject
               INVOKE lsObject "getValue" RETURNING lsToolbarData
               IF lsTDFilename NOT = NULL
                   INVOKE lsTDFilename "finalize" RETURNING lsTDFIlename
               END-IF
               SET lsTDFilename TO lsString
               INVOKE lsObject "setValue" USING lsToolBarData
               PERFORM Save-RTF-File
           END-IF
           .

       Add-RTF-Filter section.
           INVOKE CharacterArray "withValue"
                               USING z"Rich Text Format (RTF)"
                           RETURNING lsString
           INVOKE CharacterArray "withValue"
                               USING z"*.rtf"
                           RETURNING lsObject
           INVOKE lsFileDialog "addFilter" USING lsString
                                                 lsObject
           INVOKE lsString "finalize" RETURNING lsString
           INVOKE lsObject "finalize" RETURNING lsObject

           INVOKE CharacterArray "withValue" USING z"rtf"
                                         RETURNING lsString
           INVOKE lsFileDialog "setExtension" USING lsString
           INVOKE lsString "finalize" RETURNING lsString
           .

       Handle-Char-Format section.
           *> Get the associated Rich Edit control
           INVOKE REDict "atOrNil" USING lsToolbar
                               RETURNING lsObject
           INVOKE lsObject "getValue" RETURNING lsToolbarData

           MOVE i TO lsIndex
           INVOKE lsToolbar "toolAtIndex"
                                       USING lsIndex
                                   RETURNING lsButton
           INVOKE lsButton "isChecked" RETURNING lsBool
           INVOKE lsButton "isIndeterminate" RETURNING lsBool2
           IF isTrue
              AND isFalse2
               EVALUATE lsIndex
                   WHEN CharFormatIndex
                       INVOKE lsTDRichEdit "notBold"
                   WHEN CharFormatIndex + 1
                       INVOKE lsTDRichEdit "notItalic"
                   WHEN CharFormatIndex + 2
                       INVOKE lsTDRichEdit "noUnderline"
               END-EVALUATE
               INVOKE lsButton "uncheck"

           ELSE
               EVALUATE lsIndex
                   WHEN CharFormatIndex
                       INVOKE lsTDRichEdit "bold"
                   WHEN CharFormatIndex + 1
                       INVOKE lsTDRichEdit "italic"
                   WHEN CharFormatIndex + 2
                       INVOKE lsTDRichEdit "underline"
               END-EVALUATE
               IF isFalse
                   INVOKE lsButton "check"
               END-IF
               IF isTrue2
                   INVOKE lsButton "notIndeterminate"
               END-IF
           END-IF
           .

       Handle-Para-Format section.
           MOVE i TO lsIndex
           INVOKE lsToolbar "toolAtIndex"
                                       USING lsIndex
                                   RETURNING lsButton
           INVOKE lsButton "isChecked" RETURNING lsBool
           INVOKE lsButton "isIndeterminate" RETURNING lsBool2

           IF isTrue
              AND isFalse2
               EXIT SECTION *> Do nothing
           ELSE
               IF isFalse
                   INVOKE REDict "atOrNil" USING lsToolbar
                                       RETURNING lsObject
                   IF lsObject NOT = NULL
                       INVOKE lsObject "getValue"
                                           RETURNING lsToolbarData
                       EVALUATE lsIndex
                           WHEN ParaFormatIndex
                               INVOKE lsTDRichEdit "leftJustified"
                           WHEN ParaFormatIndex + 1
                               INVOKE lsTDRichEdit "centered"
                           WHEN ParaFormatIndex + 2
                               INVOKE lsTDRichEdit "rightJustified"

                       END-EVALUATE
                   END-IF
               END-IF
               IF isTrue2
                   *> Make all three buttons NOT indeterminate
                   MOVE ParaFormatIndex TO i
                   INVOKE lsToolbar "toolAtIndex" USING i
                                              RETURNING lsButton
                   INVOKE lsButton "notIndeterminate"
                   ADD 1 TO i
                   INVOKE lsToolbar "toolAtIndex" USING i
                                              RETURNING lsButton
                   INVOKE lsButton "notIndeterminate"
                   ADD 1 TO i
                   INVOKE lsToolbar "toolAtIndex" USING i
                                              RETURNING lsButton
                   INVOKE lsButton "notIndeterminate"
               END-IF

               *> UnCheck all 3 buttons
               MOVE ParaFormatIndex TO i
               INVOKE lsToolbar "unCheckToolAtIndex" USING i
               ADD 1 TO i
               INVOKE lsToolbar "unCheckToolAtIndex" USING i
               ADD 1 TO i
               INVOKE lsToolbar "unCheckToolAtIndex" USING i

               *> Check selected button
               INVOKE lsToolbar "checkToolAtIndex" USING lsIndex

           END-IF
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

          IF buttonImageList NOT = NULL
             INVOKE buttonImageList "finalize"
                                     RETURNING buttonImageList
          END-IF

          INVOKE anEvent "getObject" RETURNING lsRichEdit
          INVOKE lsRichEdit "getAncestor" RETURNING aWindow
          SET DataBlock-Pointer TO NULL

          INVOKE aDictionary "AtOrNil" USING aWindow
                                RETURNING DataBlock-Pointer
          IF DataBlock-Pointer NOT = NULL
             INVOKE aDictionary "removeKey" USING aWindow
          END-IF
          SET aWindow TO NULL

          IF REDict NOT = NULL
            *> Remove items from the Rich Edit dictionary
            INVOKE REDict "atOrNil" USING lsRichEdit
                                RETURNING lsToolbar
            IF lsToolbar NOT = NULL
              INVOKE REDict "removeKey" USING lsRichEdit
              INVOKE REDict "atOrNil" USING lsToolbar
                                  RETURNING lsObject
              IF lsObject NOT = NULL
                  INVOKE lsObject "getValue" RETURNING lsToolbarData
                  IF lsTDFilename NOT = NULL
                      INVOKE lsTDFilename "finalize"
                                               RETURNING lsTDFilename
                  END-IF
                  INVOKE REDict "removeKey" USING lsToolbar
              END-IF
            END-IF
            INVOKE REDict "size" RETURNING i
            IF i < 1
              INVOKE REDict "finalize" RETURNING REDict
            END-IF
          END-IF

          EXIT PROGRAM
          .


