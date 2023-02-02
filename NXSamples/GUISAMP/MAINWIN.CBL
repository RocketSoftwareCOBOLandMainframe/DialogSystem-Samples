       copy "guibase.if".
       copy "sdiframe.if".
      *>---------------------------------------------------------------*
      *> This is the Main Window of the GUI Samples application.
      *> This class is a simplified version of the standard GUI template
      *> main window class.  This Main Window demonstates :
      *>
      *> - A menu bar
      *> - A simple status bar with menu hints
      *> - Menu item enable \ disable
      *> - Linking menu items to methods
      *> - invoking other classes which demonstrate the basic behaviour
      *>   of the more common screen controls
      *> - How to display a message box using the MessageBox class
      *>
      *> This window uses idle time processing to update the status bar
      *> with the state of the Ins, Num and Caps lock keys. When
      *> debugging, you must comment out the following statement in the
      *> "defineEventHandling" method:
      *>
      *>   invoke lsEventManager "registerIdleObject" using self
      *>
      *> Otherwise, each time focus switches to the debugger, this
      *> method is invoked. If you want to run with IdleTime processing
      *> comment this section back in.
      *> Copyright (C) 1996-2000  Micro Focus International Ltd.
      *----------------------------------------------------------------*

      *-----------------< CLASS PROGRAM DEFINITION >-------------------*
       class-id.   MainWindow
                   inherits from SDIFrame.

       class-control.

      *--> These are the classes we've written ourselves!
           MainWindow          is class "MainWin"
           TextAndEditFields   is class "TextEdit"
           LoseAndGainFocus    is class "LoseGain"
           CheckBoxDemo        is class "ChkBox"
           TreeViewDemo        is class "TreView"
           UpDownControls      is class "UpDownct"
           GroupBoxDemo        is class "grpbox"
           ComboBoxDemo        is class "combobox"
           ListBoxDemo         is class "LstBox"
           ScrollBarDemo       is class "scrolbar"
           AboutBox            is class "AboutBox"

      *--> These Classes are from the standard Class Libraries
           SDIFrame            is class "sdiframe"
           CharacterArray      is class "chararry"
           OrderedCollection   is class "ordrdcll"
           MenuBar             is class "menubar"
           EventManager        is class "p2emgr"
           OpenDialog          is class "opendlg"
           Module              is class "module"
           Behavior            is class "behavior"
           MessageBox          is class "msgbox"
           CobolComp5          is class "comp5"
           Keybrd              is class "keyboard"
           IconData            is class "icondata"
           BitmapData          is class "bitmapd"
           StaticBitmap        is class "bitmap"
           .

      *--------------< COMMON CLASS & INSTANCE DATA >------------------*
       working-storage section.

       01 wsDesktop                object reference.
       01 wsEventManager           object reference.

      *> Constants
       78 wsWindowtitle            value z"Gui Sample Class Programs".
       78 wsResourceDll            value z"GuiSamp.dll".
       78 wsHelpFile               value z"visocoo.hlp".

      *> Control values (constants, but must be x(4) comp-5 format)
       01 wsNumberStatusSections   pic x(4) comp-5     value 4.

      *> Messages (more constants)
       78 msgNotImplemented
           value z'This Facility Is Not Yet Implemented'.
       78 msgDescription
           value 'This is an information message displayed using the ' &
                z'MessageBox class'.

      *> Copy code
       copy "mfres.cpy".
       copy "p2cevent.cpy".

      *--------------------< CLASS DEFINITION >------------------------*
       Class-Object.

      *----------------------< CLASS DATA >----------------------------*
       Object-Storage Section.
       *> None at the moment

      *---------------------< CLASS METHODS >--------------------------*
       *> None at the moment

       End Class-Object.

      *-------------------< INSTANCE DEFINITION >----------------------*
       Object.

      *---------------------< INSTANCE DATA >--------------------------*
       object-storage section.

      *--> these are all handles to the objects we're using.
       01 osStatusBar          object reference.
       01 osMenuBar            object reference.
       01 osResource           object reference.
       01 osStatusDimensions   object reference.
       01 osKeyStates          pic x(4) comp-5.
       01 osKeyFlag            pic x comp-5        value 1.
        88 firstTimeThru                           value 1.

       01 osIcon               object reference    value null.
       01 childIcon            object reference    value null.
       01 osBitmap             object reference    value null.
       01 osBitmapD            object reference    value null.
       01 osClientPane         object reference    value null.

      *--------------------< INSTANCE METHODS >------------------------*
      *> Note: all the basic initialisation and window definition
      *> methods are at the bottom of the code as they are fairly
      *> standard
      *>---------------------------------------------------------------*

      *>---------------------------------------------------------------*
      *> "DefineMenuMap"
      *> Uses a vocabulary defined verb "map menuId" from "SDIFrame.if".
      *> This maps the menu items defined for this window to methods.
      *> Each menu item is identified by its resource symbol, defined
      *> in the .RC file which builds the menu.
      *>---------------------------------------------------------------*
       method-id. "DefineMenuMap".
       procedure division.

           map menuId ID-GROUP-BOX-WITH-RADIOS at osResource
               to z"OnEventGroupBoxWithRadioButtons"

           map menuId ID-COMBO-BOX             at osResource
               to z"OnEventComboBox"

           map menuId ID-LIST-BOX              at osResource
               to z"OnEventListBox"

           map menuId ID-TREE-VIEW             at osResource
               to z"OnEventTreeView"

           map menuId ID-CHECK-BOX             at osResource
               to z"OnEventCheckBox"

           map menuId ID-TEXT-EDIT-FIELDS1     at osResource
               to z"OnEventTextAndEditFields"

           map menuId ID-TEXT-EDIT-FIELDS2     at osResource
               to z"OnEventLoseAndGainFocus"

           map menuId ID-SCROLLBARS            at osResource
               to z"OnEventScrollbars"

           map menuId ID-UP-DOWN-CONTROLS      at osResource
               to z"OnEventUpDownControls"

           map menuId ID-ENABLE-MENU           at osResource
               to z"OnEventEnableMenu"

           map menuId ID-DISABLE-MENU          at osResource
               to z"OnEventDisableMenu"

           map menuId ID-MESSAGE-BOX           at osResource
               to z"OnEventDisplayMessageBox"

           map menuId ID-EXIT-SYSTEM           at osResource
               to z"OnEventExit"

           map menuId ID-ABOUT                 at osResource
               to z"OnEventAbout"

      *--> This initialises the default menu enabling
           invoke self "OnEventEnableMenu"

       exit method.
       end method "DefineMenuMap".

      *>---------------------------------------------------------------*
      *> "OnEventGroupBoxWithRadioButtons"
      *> Demonstrates how to process Radio Buttons in a group box
      *>---------------------------------------------------------------*
       method-id. "OnEventGroupBoxWithRadioButtons".
       procedure division.

           invoke GroupBoxDemo "ShowDemo" using self
                                                osResource

       exit method.
       end method "OnEventGroupBoxWithRadioButtons".

      *>---------------------------------------------------------------*
      *> "OnEventComboBox"
      *> Demonstrates how to process the different types of Combo Box
      *>---------------------------------------------------------------*
       method-id. "OnEventComboBox".
       procedure division.

           invoke ComboBoxDemo "ShowDemo" using self
                                                osResource

       exit method.
       end method "OnEventComboBox".

      *>---------------------------------------------------------------*
      *> "OnEventListBox"
      *> Demonstrates how to process the different types of List Box
      *>---------------------------------------------------------------*
       method-id. "OnEventListBox".
       procedure division.

           invoke ListBoxDemo "ShowDemo" using self
                                               osResource

       exit method.
       end method "OnEventListBox".

      *>---------------------------------------------------------------*
      *> "OnEventTreeView"
      *> Demonstrates how to process a Tree View control
      *>---------------------------------------------------------------*
       method-id. "OnEventTreeView".
       procedure division.

           invoke TreeViewDemo "ShowDemo" using Self
                                                osResource


       exit method.
       end method "OnEventTreeView".

      *>---------------------------------------------------------------*
      *> "OnEventCheckBox"
      *> Demonstrates how to process a Check Box control
      *>---------------------------------------------------------------*
       method-id. "OnEventCheckBox".
       procedure division.

           invoke CheckBoxDemo "ShowDemo" using self
                                                osResource

       exit method.
       end method "OnEventCheckBox".

      *>---------------------------------------------------------------*
      *> "OnEventTextAndEditFields"
      *> Demonstrates how to process Text Field controls and Edit Field
      *> controls including getting and setting values in them and how
      *> to Enable/Disable them
      *>---------------------------------------------------------------*
       method-id. "OnEventTextAndEditFields".
       procedure division.

           invoke TextAndEditFields "ShowDemo" using self
                                                     osResource

       exit method.
       end method "OnEventTextAndEditFields".

      *>---------------------------------------------------------------*
      *> "OnEventLoseAndGainFocus"
      *> Demonstrates how to process the 'lost focus' & 'gained focus'
      *> events for Edit Field controls.  These are generated on entry
      *> to and exit from Edit Fields.
      *>---------------------------------------------------------------*
       method-id. "OnEventLoseAndGainFocus".
       procedure division.

           invoke LoseAndGainFocus "ShowDemo" using self
                                                    osResource

       exit method.
       end method "OnEventLoseAndGainFocus".

      *>---------------------------------------------------------------*
      *> "OnEventScrollbars"
      *> Demonstrates how to process scroll bar controls on a window.
      *> In particular when the data area is larger than the window
      *> itself
      *>---------------------------------------------------------------*
       method-id. "OnEventScrollbars".
       procedure division.

           invoke ScrollBarDemo "ShowDemo" using self
                                                 osResource
                                                 childIcon

       exit method.
       end method "OnEventScrollbars".

      *>---------------------------------------------------------------*
      *> "OnEventUpDownControls"
      *> Demonstrates how to process UpDown controls
      *>---------------------------------------------------------------*
       method-id. "OnEventUpDownControls".
       procedure division.

           invoke UpDownControls "ShowDemo" using self
                                                  osResource

       exit method.
       end method "OnEventUpDownControls".

      *>---------------------------------------------------------------*
      *> "OnEventDisplayMessageBox".
      *> Demonstrates how to put a message in a message box on the
      *> screen.
      *>---------------------------------------------------------------*
       method-id. "OnEventDisplayMessageBox".

       local-storage section.
       01 aString                      object reference.
       01 aMsgBox                      object reference.

       procedure division.

       *> Create a new message box object
           invoke MessageBox "New" using self returning aMsgBox

       *> Use the CharacterArray class to create a string object
       *> Containing the message
           invoke CharacterArray "WithValue" using msgDescription
                                         returning aString

       *> Set the title & message text
           invoke aMsgBox "SetMessage" using aString
           invoke aMsgBox "SetTitleZ" using z"This is a Message Box"

       *> In tihs case we set it to an information message, but there
       *> are many types to choose from
           invoke aMsgBox "SetTypeInformation"

       *> Display the box
           invoke aMsgBox "Show"

       *> destroy the objects used in this method
           invoke aMsgBox "Finalize" returning aMsgBox
           invoke aString "Finalize" returning aString

       exit method.
       end method "OnEventDisplayMessageBox".

      *>---------------------------------------------------------------*
      *> "OnEventAbout"
      *> Demonstrates a simple About Box
      *>---------------------------------------------------------------*
       method-id. "OnEventAbout".
       procedure division.

           invoke AboutBox "ShowDemo" using self
                                            osResource

       exit method.
       end method "OnEventAbout".

      *>---------------------------------------------------------------*
      *> "OnEventExit".
      *> Invoked by selecting File, exit, or closing window from
      *> system menu or close button.
      *> Terminates event processing.
      *>---------------------------------------------------------------*
       method-id. "OnEventExit".

       local-storage section.
       01 lsEventManager       object reference.

       linkage section.
       01 lnkEvent             object reference.

       procedure division using lnkEvent.

           invoke EventManager "New" returning lsEventManager
           invoke lsEventManager "Terminate"

       exit method.
       end method "OnEventExit".

      *>---------------------------------------------------------------*
      *> "OnEventEnableMenu".
      *> Demonstrates how to Enable menu items
      *>---------------------------------------------------------------*
       method-id. "OnEventEnableMenu".
       local-storage section.
       01 lsId                     pic x(4) comp-5.
       procedure division.

      *--> DISABLE the enable option
           move ID-ENABLE-MENU to lsId
           invoke self "DisableMenuItem" using lsId

      *--> ENABLE Rest of menu
           move ID-GROUP-BOX-WITH-RADIOS   to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-COMBO-BOX               to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-LIST-BOX                to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-TREE-VIEW               to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-CHECK-BOX               to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-TEXT-EDIT-FIELDS1       to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-TEXT-EDIT-FIELDS2       to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-SCROLLBARS              to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-UP-DOWN-CONTROLS        to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-DISABLE-MENU            to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-MESSAGE-BOX             to lsId
           invoke self "EnableMenuItem" using lsId
           move ID-EXIT-SYSTEM             to lsId
           invoke self "EnableMenuItem" using lsId

       exit method.
       end method "OnEventEnableMenu".

      *>---------------------------------------------------------------*
      *> "EnableMenuItem"
      *> This method enables a menu item passed to it
      *>---------------------------------------------------------------*
       method-id. "EnableMenuItem".
       local-storage section.
       01 lsMenuItem               object reference.
       linkage section.
       01 lnkId                    pic x(4) comp-5.
       procedure division using lnkId.

       *> this method gets us a handle to the menu item using the
       *> symbol number passed in lsId
           invoke self "MenuItemAtCommand" using lnkId
                                       returning lsMenuItem

       *> and this method enables it
           invoke lsMenuitem "Enable"

       exit method.
       end method "EnableMenuItem".

      *>---------------------------------------------------------------*
      *> "DisableMenu".
      *> Demonstrates how to Disable menu items
      *>---------------------------------------------------------------*
       method-id. "OnEventDisableMenu".
       local-storage section.
       01 lsId                     pic x(4) comp-5.
       procedure division.
      *--> ENABLE the enable option
           move ID-ENABLE-MENU to lsId
           invoke self "EnableMenuItem" using lsId

      *--> DISABLE Rest of menu
           move ID-GROUP-BOX-WITH-RADIOS    to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-COMBO-BOX                to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-LIST-BOX                 to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-TREE-VIEW                to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-CHECK-BOX                to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-TEXT-EDIT-FIELDS1        to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-TEXT-EDIT-FIELDS2        to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-SCROLLBARS               to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-UP-DOWN-CONTROLS         to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-DISABLE-MENU             to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-MESSAGE-BOX              to lsId
           invoke self "DisableMenuItem" using lsId
           move ID-EXIT-SYSTEM              to lsId
           invoke self "DisableMenuItem" using lsId

       exit method.
       end method "OnEventDisableMenu".

      *>---------------------------------------------------------------*
      *> "DisableMenuItem"
      *> This method disables a menu item passed to it
      *>---------------------------------------------------------------*
       method-id. "DisableMenuItem".
       local-storage section.
       01 lsMenuItem               object reference.
       linkage section.
       01 lnkId                    pic x(4) comp-5.
       procedure division using lnkId.

       *> this method gets us a handle to the menu item using the
       *> symbol number passed in lsId
           invoke self "MenuItemAtCommand" using lnkId
                                       returning lsMenuItem

       *> and this method disables it
           invoke lsMenuitem "Disable"

       exit method.
       end method "DisableMenuItem".

      *>----------------< WINDOW DEFINITION METHODS >------------------*
      *> These set up the main window and menus in the first place

      *>---------------------------------------------------------------*
      *> Window definition method.
      *> Initialize the window. Sets the initial size, and title of
      *> the window. Also paints menu and statusbar and sets up
      *> event handling.
      *>---------------------------------------------------------------*
       method-id. "Initialize".

       linkage section.
       01 lnkParent             object reference.

       procedure division using lnkParent.

      *> Get the Eventmanager object handle and desktop.
           invoke EventManager "getCurrentManager"
                                               returning wsEventManager
           invoke wsEventManager "getDesktop"  returning wsDesktop

           invoke super "Initialize" using lnkParent
           invoke self "DefineInitialSize"
           invoke self "LoadResources"
           invoke self "SetTitleZ" using wsWindowTitle
           invoke self "DefineStatusbar"
           invoke self "DefineMenuBar"
           invoke self "DefineMenuMap"
           invoke self "DefineEventHandling"
           invoke self "AddIcon" returning osIcon
           invoke self "CreateChildIcon" returning childIcon
           invoke self "Create"
           invoke self "PutBitmapInClientArea"

       exit method.
       end method "Initialize".

      *>---------------------------------------------------------------*
      *> "LoadResources"
      *> Load the .dll file with all the resources for the interface
      *> (menus, dialog boxes, bitmaps etc).
      *>---------------------------------------------------------------*
       method-id. "LoadResources".

       procedure division.

       *> this method gets us a handle to the resource file which
       *> contains our menus and the screens we've designed in Dialog
       *> Editor
           invoke Module "NewZ" using wsResourceDll
                            returning osResource

       exit method.
       end method "LoadResources".

      *>---------------------------------------------------------------*
      *> "DefineStatusbar"
      *> Adds a status bar to the window. Default method provides four
      *> sections. The 1st section is used for menu hinting. The next
      *> three show key status indicators (i.e. CAPS, NUM, INS).
      *>---------------------------------------------------------------*
       method-id. "DefineStatusbar".
       local-storage section.
       01 lsIndex                  pic x(4) comp-5.
       01 lsWidth                  pic x(4) comp-5.

       procedure division.

      *> Add a status bar
           invoke super "AddStatusbar" returning osStatusBar

      *> Display menu hints in first part of status bar
           move 1 to lsIndex
           invoke osStatusBar "SetMenuTextIndex" using lsIndex

      *> Divide status bar into four sections. First create an ordered
      *> collection of values to hold the width of each section.
           invoke OrderedCollection "ofValues" using
                                               CobolComp5
                                               wsNumberStatusSections
                                     returning osStatusDimensions

      *> Initialize the collection for status bar section widths.
           invoke self "GetWidth" returning lsWidth
           divide lsWidth by wsNumberStatusSections giving lsWidth
           perform varying lsIndex from 1 by 1
                   until lsIndex > wsNumberStatusSections
               invoke osStatusDimensions "AddLast" using lsWidth
           end-perform

      *> Sets the status bar size in proportion to the window width
           invoke self "SizeStatusBar"

           invoke self "UpdateStatusBar"

       exit method.
       end method "DefineStatusbar".


      *>---------------------------------------------------------------*
      *> Window definition method.
      *> Adds the menubar defined under id-menubar in the resource.dll
      *> file for this application.
      *>---------------------------------------------------------------*
       method-id. "DefineMenuBar".
       local-storage section.
       01 lsResourceId             pic x(4) comp-5.
       01 lsMenuItem               object reference.
       procedure division.

      *> this gets a handle to the menu bar object using it's symbol
      *> number
           move ID-MENUBAR to lsResourceId
           invoke self "SetMenuFromResource" using osResource
                                                   lsResourceId

       exit method.
       end method "DefineMenuBar".

      *>---------------------------------------------------------------*
      *> Window definition method.
      *> Set the initial size of this window. The default code sets it
      *> relative to the size of the desktop.
      *>---------------------------------------------------------------*
       method-id. "DefineInitialSize".
       local-storage section.
       01 lsX                  pic 9(9) comp-5.
       01 lsY                  pic 9(9) comp-5.
       01 lsCx                 pic 9(9) comp-5.
       01 lsCy                 pic 9(9) comp-5.

       procedure division.

           invoke wsDesktop "GetHeight" returning lsY
           invoke wsDesktop "GetWidth"  returning lsX
           divide lsX by 1.2 giving lsCx
           divide lsY by 1.2 giving lsCy
           divide lsCx by 10 giving lsX
           divide lsCy by 10 giving lsY
           invoke self "SetRectangle" using lsX lsY lsCx lsCy

       exit method.
       end method "DefineInitialSize".

      *>---------------------------------------------------------------*
      *> Window definition method.
      *> Register events not raised by menu items to which this window
      *> responds. Default method registers close and idle processing.
      *>---------------------------------------------------------------*
       method-id. "DefineEventHandling".
       local-storage section.
       01 lsEvent                  pic 9(9) comp-5.
       01 lsEventManager           object reference.
       procedure division.

      *> map the main window close button to the exit method
           map event closed upon self
                           to method z"OnEventExit" upon self

      *> Register window as an object to do idle processing.
      *> For debugging, comment out next 2 lines - comment them in if
      *> you want your system to do idle time processing.
      *> Get the event manager object handle and register this window
      *>   invoke EventManager "New" returning lsEventManager
      *>   invoke lsEventManager "RegisterIdleObject" using self

       exit method.
       end method "DefineEventHandling".

      *>---------------------------------------------------------------*
      *> Window event method.
      *> Called each time the window is resized. The default
      *> method resizes the sections in the status bar too.
      *>---------------------------------------------------------------*
       method-id. "Resized".
       local-storage section.
       01 lsX                      pic x(4) comp-5.
       01 lsY                      pic x(4) comp-5.
       linkage section.
       01 lnkEvent             object reference.
       procedure division using lnkEvent.

           invoke super "Resized" using lnkEvent

           if osBitmap = null
               continue
           else
               invoke self "PositionBitmap"
           end-if

           invoke self "SizeStatusBar"

       exit method.
       end method "Resized".

      *>---------------------------------------------------------------*
      *> Window event method.
      *> Invoked during application idle time (when waiting for events).
      *> Default method updates state of lock keys displayed in status
      *> bar.
      *>---------------------------------------------------------------*
       method-id. "DoIdleProcessing".

       local-storage section.
       01 lsCount                  pic x(4) comp-5.

       linkage section.
       01 lnkBool                  pic x comp-5.

       procedure division returning lnkBool.

      *> Change this code to alter idle time processing.
      *> Add to it to carry out extra idle time processing.
           invoke self "UpdateStatusBar"

      *> Change this code to prevent other objects from carrying out
      *> idle-time processing!
      *> This statement allows idle time processing.
           move 1 to lnkBool
      *> This statement stops other objects from idle time processing.
      *>   move 0 to lsBool

       exit method.
       end method "DoIdleProcessing".

      *>---------------------------------------------------------------*
      *> Window appearance method.
      *> Displays the states of the Ins, Caps Lock and Num Lock
      *> keys in the status bar.
      *>---------------------------------------------------------------*
       method-id. "UpdateStatusBar".

       local-storage section.
       01 lsString                 object reference.
       01 lsIndex                  pic x(4) comp-5.
       01 lsKeyStates              pic x(4) comp-5.
       01 lsBool                   pic x comp-5.
        88 isTrue                  value 1.
        88 isFalse                 value 0.
       procedure division.

      *> This code is an example of updating the status bar -
      *> Change it as needed for your application.

           invoke Keybrd "GetKeyStates" returning lsKeyStates
           if lsKeyStates <> osKeyStates or firstTimeThru
             *> The status bar is only updated if the keyboard state has
             *> changed since last time, or if this is the start of the
             *> application run. This prevents the status bar
             *> from flickering while the application runs.
               move 0 to osKeyFlag
               invoke Keybrd "InsLocked" returning lsBool
               if isTrue
                   invoke CharacterArray "WithValue" using Z"INS"
                                                 returning lsString
               else
                   invoke CharacterArray "WithValue" using Z"OVR"
                                                 returning lsString
               end-if
               move 2 to lsIndex
               invoke osStatusBar "SetSectionText" using lsIndex
                                                         lsString
               invoke lsString "Finalize" returning lsString
               invoke Keybrd "CapsLocked" returning lsBool
               if isTrue
                   invoke CharacterArray "WithValue" using Z"CAPS"
                                                 returning lsString
               else
                   invoke CharacterArray "WithValue" using Z"     "
                                                 returning lsString
               end-if
               move 3 to lsIndex
               invoke osStatusBar "SetSectionText" using lsIndex
                                                         lsString
               invoke lsString "Finalize" returning lsString
               invoke Keybrd "NumLocked" returning lsBool
               if isTrue
                   invoke CharacterArray "WithValue" using Z"NUM"
                                                 returning lsString
               else
                   invoke CharacterArray "WithValue" using Z"     "
                                                 returning lsString
               end-if
               move 4 to lsIndex
               invoke osStatusBar "SetSectionText" using lsIndex
                                                         lsString
               invoke lsString "Finalize" returning lsString
               move lsKeyStates to osKeyStates

           end-if

       exit method.
       end method "UpdateStatusBar".

      *>---------------------------------------------------------------*
      *> Window appearance method.
      *> Size the status bar. Default method sizes the status
      *> bar sections proportional to the width of the window.
      *>---------------------------------------------------------------*
       method-id. "SizeStatusBar".

       local-storage section.
       01 lsWidth                  pic x(4) comp-5.
       01 lsSectionWidth           pic x(4) comp-5.
       01 lsIndex                  pic x(4) comp-5.

       procedure division.

      *> Alter this code to change the way the status bar
      *> sections are sized. The default code sizes sections of the
      *> status bar proportional to the size of the window.

           invoke self "GetWidth" returning lsWidth

      *> First section is three quarters window width.
           move 1 to lsIndex
           multiply lsWidth by 0.75 giving lsSectionWidth
           invoke osStatusDimensions "AtPut" using
                                             lsIndex lsSectionWidth

      *> Rest of sections are divided between the last quarter
           multiply lsWidth by 0.25 giving lsSectionWidth
           divide lsSectionWidth by 4 giving lsSectionWidth
           move 2 to lsIndex
           invoke osStatusDimensions "AtPut" using
                                             lsIndex lsSectionWidth

           multiply 1.2 by lsSectionWidth
           move 3 to lsIndex
           invoke osStatusDimensions "AtPut" using
                                             lsIndex lsSectionWidth

           divide   1.2 into lsSectionWidth
           multiply 1.8 by lsSectionWidth
           move 4 to lsIndex
           invoke osStatusDimensions "AtPut" using
                                             lsIndex lsSectionWidth
      *----Set the status bar
           invoke osStatusBar "SetParts" using osStatusDimensions

       exit method.
       end method "SizeStatusBar".

      *>---------------------------------------------------------------*
      *> Window appearance method.
      *> Attaches the icon idicon-guisamp which is defined in
      *> guisamp.ico to this window
      *>---------------------------------------------------------------*
       method-id. "addIcon".
       local-storage section.
       01 lsResourceId             pic x(4) comp-5.
       linkage section.
       01 lnkIcon                object reference.
       procedure division returning lnkicon.
               move IDICON-GUISAMP to lsResourceId
               invoke icondata "fromResource" using
                                            osResource
                                            lsResourceId
                                  returning lnkIcon
           invoke self "attachIcon" using lnkIcon

       Exit method.
       End method "addIcon".


      *>---------------------------------------------------------------*
      *> "CreateChildIcon"
      *> Creates an icon which is defined in childwin.ico to be
      *> attched to the child of the mainwindow.
      *>---------------------------------------------------------------*
       method-id. "CreateChildIcon".
       local-storage section.
       01 lsResourceId             pic x(4) comp-5.
       linkage section.
       01 lnkIcon                  object reference.
       procedure division returning lnkIcon.
               move IDICON-CHILDWIN to lsResourceId                     *> Use the symbol no for our icon as a sort of "index" to find it in the resource file
               invoke icondata "fromResource" using                     *> This method finds the icon we painted in the resource file and creates it as
                                            osResource                  *> an object for us to use
                                            lsResourceId
                                  returning lnkIcon
       exit method.
       end method "CreateChildIcon".

      *>---------------------------------------------------------------*
      *> Window definition method. Paints a Splash Screen in this case
      *> Defines the type of object to be used for the client area, by
      *> default a Subpane. If you want to "paint" into the client area,
      *> use your own subclass of Subpane and override the "paint"
      *> method. Alternatively, if you only want to display lines of
      *> text, you could use a ListBox or MultipleLineEntry field
      *> instead.
      *>---------------------------------------------------------------*
       method-id. "PutBitmapInClientArea".
       local-storage section.
       01 lsX                      pic x(4) comp-5.
       01 lsY                      pic x(4) comp-5.
       01 lsResourceId             pic x(4) comp-5.

       procedure division.

           move IDB-SPLASH-SCREEN to lsResourceId

           invoke BitmapData "FromResource" using osResource
                                                  lsResourceId
                                        returning osBitmapD

           invoke self "GetClientPane" returning osClientPane

           invoke StaticBitmap "New" using osClientPane
                                 returning osBitmap

           invoke osBitmap "SetBitmap" using osBitmapD

           invoke osClientPane "gray"

           invoke self "PositionBitmap"

           exit method.
       end method "PutBitmapInClientArea".

      *>---------------------------------------------------------------*
      *> Method to position bitmap in the centre of the client Area
      *> Called when the bitmap is created, and each time the window is
      *> resized.
      *>---------------------------------------------------------------*
       method-id. "PositionBitmap".
       working-storage section.
       78 bitmapwidth value 360.
       78 bitmapheight value 100.
       local-storage section.
       01 lsX                      pic x(4) comp-5.
       01 lsY                      pic x(4) comp-5.
       linkage section.
       01 lnkEvent             object reference.
       procedure division using lnkEvent.

           invoke self "GetClientWidthHeight" using lsX lsY

           if lsX >= bitmapwidth
               compute lsX = (lsX - bitmapwidth) / 2
               if lsY >= bitmapheight then
                   compute lsY = (lsY - bitmapheight) / 2
                   invoke osBitmap "setXY" using lsX lsY
                   invoke osBitmap "Show"
               else
                   invoke osBitmap "hide"
               end-if
           else
               invoke osBitmap "hide"
           end-if

       exit method.
       end method "PositionBitmap".

      *>---------------------------------------------------------------*
      *> Finalize - destroy objects used
      *>---------------------------------------------------------------*
       method-id. "Finalize".
       linkage section.
       01 lnkreturn                object reference.
       procedure division returning lnkreturn.
           invoke osIcon       "finalize" returning osIcon
           invoke childIcon    "finalize" returning childIcon
           invoke osBitmapD    "finalize" returning osBitmapD
           invoke osBitmap     "finalize" returning osBitmap
           invoke osClientPane "finalize" returning osClientPane
           invoke super        "finalize" returning lnkreturn
           exit method.
       end method "Finalize".

       end object.
       end class MainWindow.


