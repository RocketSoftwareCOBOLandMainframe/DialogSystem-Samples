       copy "guibase.if".                                                *> Standard interface to GUIBase class using vocabulary generator - you can just invoke GUIBase
      *----------------------------------------------------------------* *> methods directly if you wish.
      *  Check Box Demonstration Class :                                 *>
      *                                                                  *>
      *  This is a Modal Dialog Box. The Dialog box has been created in  *>
      *  the Dialog Editor. This class demonstrates how to use a         *>
      *  check box in your program - in particular :                     *>
      *                                                                  *>
      *  - how to set it to checked                                      *>
      *  - how to set it to not checked                                  *>
      *  - how to find out if it is checked or not                       *>
      *                                                                  *>
      *  Screen Controls Used :                                          *>
      *                                                                  *>
      *  - Check Boxes - you use these for choosing options              *>
      *  - Pushbuttons - To perform actions                              *>
      *                                                                  *>
      *  The code in this Class Program is well commented, and further   *>
      *  explanations are given as in-line comments in cols 73 onwards.  *>
      *                                                                  *>
      *  Copyright (C) 1996-2000  Micro Focus International Ltd.
      *----------------------------------------------------------------* *>
                                                                         *>
      *-----------------< CLASS PROGRAM DEFINITION >-------------------* *>
       Class-Id.   CheckBoxDemo                                          *>
                   data is private                                       *>
                   inherits from Modal.                                  *>
                                                                         *>
       Object Section.                                                   *>
                                                                         *>
       Class-Control.                                                    *> Declare the classes that this class uses directly
           Modal               is class "modal"                          *> From the class library - we use this class to create and control a modal dialog box
           CheckBoxDemo        is class "ChkBox"                         *> Our own class
           CharacterArray      is class "chararry"                       *> From the class library - we use this class to change objects to pic x strings and back
           MessageBox          is class "msgbox"                         *> From the class library - we use this class to create and control a message box
           .                                                             *>
                                                                         *>
      *--------------< COMMON CLASS & INSTANCE DATA >------------------* *>
       Working-Storage Section.                                          *> Declare the data that can be accessed from both the class and instances of the class
                                                                         *>
      *--> Copy files                                                    *>
       copy "mfres.cpy".    *> Symbol nos to identify screen controls    *>
       copy "p2cevent.cpy". *> 78s used to identify physical events      *>
                                                                         *>
      *--> Common Data                                                   *>
       78  wsNullTerminator        value x'00'.                          *> we can use this when creating null terminated strings
       78  wsNewLine               value x'0D0A'.                        *> we can use this when creating null terminated strings
                                                                         *>
      *--------------------< CLASS DEFINITION >------------------------* *>
       Class-Object.                                                     *>
                                                                         *>
      *----------------------< CLASS DATA >----------------------------* *>
       Object-Storage Section.                                           *>
       *> None at the moment                                             *>
                                                                         *>
      *---------------------< CLASS METHODS >--------------------------* *>
       Method-Id. "ShowDemo".                                            *> This class method creates an instance of class "Modal" - a modal dialog box - from the one we
                                                                         *> painted in the dialog editor - it Gets this from the resource file
       Local-Storage Section.                                            *>
       01 aModalDialogBox          object reference.                     *>
       01 ResourceId               pic x(4) comp-5.                      *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkResource              object reference.                     *>
       01 lnkParent                object reference.                     *>
                                                                         *>
       Procedure Division using lnkParent                                *>
                                lnkResource.                             *>
                                                                         *>
      *--> Create our Modal Dialog box from the resource file            *>
      *--  as a child window of lnkParent                                *>
           move DLG-CHECKBOX-DEMO to ResourceId                          *> Use the symbol no for our dialog box as a sort of "index" to find it in the resource file
                                                                         *>
           invoke Self "fromResource" using lnkParent                    *> This DialogBox method finds the dialog box we painted in the resource file and creates it as
                                            lnkResource                  *> an object for us to use.  The resource file contains all the resources we want to use, like
                                            ResourceId                   *> screen designs, menu layouts, bitmaps and toolbar designs.
                                  returning aModalDialogBox              *>
                                                                         *>
      *--> aModalDialogBox has just been created as an instance object   *>
      *--  of our Text&EditField Class - so we can initialize it         *>
           invoke aModalDialogBox "Create"                               *> This is our own instance method which sets up the initial state of our dialog box and events
                                                                         *>
      *--> Display the ModalDialogBox created and wait for screen events *>
           invoke aModalDialogBox "Show"                                 *> This is a method of the Modal class we inherited which shows our dialog box on the screen and
                                                                         *> then waits for an event to happen to it.
      *--> If we've got to here - the dialog box has been finished with. *>
      *--  So we will now exit from the class.                           *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "ShowDemo".                                            *>
                                                                         *>
       End Class-Object.                                                 *>
                                                                         *>
      *-------------------< INSTANCE DEFINITION >----------------------* *>
       Object.                                                           *>
                                                                         *>
      *---------------------< INSTANCE DATA >--------------------------* *>
       Object-Storage Section.                                           *>
      *--> our fields declared as objects for use in various methods     *> Since it's OO - we can use objects for processing fields - in fact all the GUI foundation
      *--  including putting to and from the screen                      *> classes use and return objects. In most cases, if you are doing an OO development it is much
       01  oCheckBox1             object reference.                      *> easier to stick to processing objects - we rarely need to change them to COBOL fields unless
       01  oCheckBox2             object reference.                      *> we're putting them on a database or into a file or something like that.
                                                                         *>
      *--------------------< INSTANCE METHODS >------------------------* *>
      *>---------------------------------------------------------------* *>
      *> "Create"                                                        *>
      *>---------------------------------------------------------------* *>
      *> Dialog box definition method.                                   *>
      *>   - Create the dialog box                                       *>
      *>   - Define Event Handling                                       *>
      *>       - Link Screen events to method names in the code          *>
      *>       - Link Screen controls / fields etc to objects in the     *>
      *>         class program                                           *>
      *>---------------------------------------------------------------* *>
       Method-Id. "Create".                                              *>
       Procedure Division.                                               *>
                                                                         *>
           invoke super "Create" *> To create our dialog box             *>
           invoke self "LinkScreenEventsToMethods"                       *>
           invoke self "LinkControlsToProgramFields"                     *>
           invoke self "InitializeCheckBoxes"                            *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "Create".                                              *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "InitializeCheckBoxes"                                          *>
      *> Invoked from create (above)                                     *>
      *>---------------------------------------------------------------* *>
       Method-Id. "InitializeCheckBoxes".                                *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsState                      pic x(01) comp-5.                 *> lsState is the field used to determine the state that our check boxes are in.
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
      *--> Set the initial state of our check boxes                      *>
      *--  0 = unchecked, 1 = checked                                    *>
           move 1 to lsState                                             *>
           invoke oCheckBox1 "SetValue" using lsState                    *> this is a method of class CheckBox from the class library
                                                                         *>
           move 0 to lsState                                             *>
           invoke oCheckBox2 "SetValue" using lsState                    *>
                                                                         *>
      *--> You could also do the following to achieve the same result    *>
      *    invoke oCheckBox1 "Select"                                    *> these are both methods of class CheckBox from the class library
      *    invoke oCheckBox2 "Deselect"                                  *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "InitializeCheckBoxes".                                *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnOK".                                                         *>
      *> Invoked when the Dialog Box OK button is pressed                *>
      *> This method finds out what state the check boxes are in.        *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventOK".                                           *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsState                      pic x(01) comp-5.                 *>
       01 lsMessage                    pic x(100).                       *>
       01 lsCheckBox1State             pic x(10).                        *>
       01 lsCheckBox2State             pic x(10).                        *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
      *--> Get the state of our check boxes                              *>
      *--  0 = unchecked, 1 = checked                                    *>
           invoke oCheckBox1 "GetValue" returning lsState                *> this is a method of class CheckBox from the class library
           if lsState = 1                                                *>
               move "checked"   to lsCheckBox1State                      *>
           else                                                          *>
               move "unchecked" to lsCheckBox1State                      *>
           end-if                                                        *>
                                                                         *>
           invoke oCheckBox2 "GetValue" returning lsState                *> this is a method of class CheckBox from the class library
           if lsState = 1                                                *>
               move "checked"   to lsCheckBox2State                      *>
           else                                                          *>
               move "unchecked" to lsCheckBox2State                      *>
           end-if                                                        *>
                                                                         *>
                                                                         *>
           string "The first check box is " delimited by size            *>
                  lsCheckBox1State delimited by spaces                   *>
                  wsNewLine delimited by size                            *>
                  "The second check box is " delimited by size           *>
                  lsCheckBox2State delimited by spaces                   *>
                  wsNullTerminator delimited by size                     *>
                  into lsMessage                                         *>
           end-string                                                    *>
                                                                         *>
           invoke self "DisplayMessageBox" using lsMessage               *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventOK".                                           *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnCancel"                                                      *>
      *> Invoked when the Dialog Box Cancel button is pressed            *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventCancel".                                       *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           invoke self "AllDone"                                         *> call to a common finalising method
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventCancel".                                       *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnClose"                                                       *>
      *> Invoked when the Dialog Box close button is pushed              *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventClose".                                        *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           invoke self "AllDone"                                         *> call to a common finalising method
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventClose".                                        *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "AllDone"                                                       *>
      *> Common Finalize method - Hide box and destroy all objects       *>
      *>---------------------------------------------------------------* *>
       Method-Id. "AllDone".                                             *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
           invoke Self "Hide"                                            *>
           invoke self "Finalize" returning self                         *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "AllDone".                                             *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LinkScreenEventsToMethods"                                     *>
      *>---------------------------------------------------------------* *>
      *> Link physical events to method names                            *>
      *> 1. use symbol number to Get a handle to the control             *>
      *> 2. map physical event on this control to a method in the code   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LinkScreenEventsToMethods".                           *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsResourceID                 pic x(4) comp-5.                  *>
       01 lsPushbutton                 object reference.                 *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
      *--> OK button clicked                                             *> 1.Use symbol no. to Get a handle to this control - The symbol numbers are defined in
           move IDOK                        to lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the Get our button from the resource
           invoke self "GetObjectFromId" using lsResourceID              *>   file and create it as the object lsPushButton.
                                     returning lsPushbutton              *> 2.Use this GUIBase method (in GUIBase.if at the top of the code) to link the "clicked" event
           map event clicked upon lsPushbutton to                        *>   on "lsPushbutton" to the method "OnOK" in this object. We've passed the name as
               method z"OnEventOK" upon self                             *>   a Null terminated string.
                                                                         *>
      *--> Cancel button clicked                                         *> As Above
           move IDCANCEL                    to lsResourceID              *>
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventCancel" upon self                         *>
                                                                         *>
      *--> Close button clicked > usually same as cancel.                *>
           map event closed upon self to                                 *> This time we don't need to Get a handle to the control as above, because the close button
               method z"OnEventClose" upon self                          *> belongs to the dialog box - which is us!
                                                                         *>
      *--> invoke lsPushbutton "Finalize" returning lsPushbutton         *> Destroy the local storage objects
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkScreenEventsToMethods".                           *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LinkControlsToProgramFields"                                   *>
      *>---------------------------------------------------------------* *>
      *> Use symbol nos of screen entry fields to link them with field   *>
      *> objects in the program.  Initialise them too.                   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LinkControlsToProgramFields".                         *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsResourceID                 pic x(4) comp-5.                  *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *> **> CHECK BOXES <**
           move CHK-CHECKBOX1 to lsResourceId                            *> 1.Use symbol no. to Get a handle to this control/field - The symbol numbers are defined in
           invoke self "GetObjectFromId" using lsResourceId              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the Get our edit/text field from the
                                     returning oCheckBox1                *>   resource file and create it as an object.
                                                                         *> 2."GetObjectFromID" takes the check box from the screen and creates it as an object of class
                                                                         *>   CheckBOx.
           move CHK-CHECKBOX2 to lsResourceId                            *>
           invoke self "GetObjectFromId" using lsResourceId              *>
                                     returning oCheckBox2                *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkControlsToProgramFields".                         *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "DisplayMessageBox".                                            *>
      *> Demonstrates how to put a message in a message box on the       *>
      *> screen.                                                         *>
      *>---------------------------------------------------------------* *>
       method-id. "DisplayMessageBox".                                   *>
                                                                         *>
       local-storage section.                                            *>
       01 aString                      object reference.                 *>
       01 aMsgBox                      object reference.                 *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkMessage                   pic x(100).                       *>
                                                                         *>
       procedure division using lnkMessage.                              *>
                                                                         *>
       *> Create a new message box object                                *>
           invoke MessageBox "New" using self returning aMsgBox          *>
                                                                         *>
       *> Use the CharacterArray class to create a string object         *>
       *> Containing the message                                         *>
           invoke CharacterArray "WithValue" using lnkMessage            *>
                                         returning aString               *>
                                                                         *>
       *> Set the title & message text                                   *>
           invoke aMsgBox "SetMessage" using aString                     *>
           invoke aMsgBox "SetTitleZ" using z"Check Box Values"          *>
                                                                         *>
       *> In tihs case we set it to an information message, but there    *>
       *> are many types to choose from                                  *>
           invoke aMsgBox "SetTypeInformation"                           *>
                                                                         *>
       *> Display the box                                                *>
           invoke aMsgBox "Show"                                         *>
                                                                         *>
       *> destroy the objects used in this method                        *>
           invoke aMsgBox "Finalize" returning aMsgBox                   *>
           invoke aString "Finalize" returning aString                   *>
                                                                         *>
       End Method "DisplayMessageBox".                                   *>
                                                                         *>
                                                                         *>
       End Object.                                                       *>
                                                                         *>
       End Class CheckBoxDemo.
