       copy "guibase.if".                                                *> Standard interface to GUIBase class using vocabulary generator - you can just invoke GUIBase
      *----------------------------------------------------------------* *> methods directly if you wish.
      *  Text & Edit Field Demonstration Class :                         *>
      *                                                                  *>
      *  This is a Modal Dialog Box. The Dialog box has been created in  *>
      *  the Dialog Editor. This class demonstrates how to use edit      *>
      *  fields and text fields in your program - in particular :        *>
      *                                                                  *>
      *  - how to put values into text and edit fields                   *>
      *  - how to get values from text and edit fields                   *>
      *  - how to enable and disable edit fields                         *>
      *                                                                  *>
      *  Screen Controls Used :                                          *>
      *                                                                  *>
      *  - Text Fields - you use these for labelling things              *>
      *    > they are created as objects of class StaticText             *>
      *  - Edit Fields - you use these for data entry / display          *>
      *    > they are created as objects of class EntryField             *>
      *  - Pushbuttons - To perform actions                              *>
      *                                                                  *>
      *  The code in this Class Program is well commented, and further   *>
      *  explanations are given as in-line comments in cols 73 onwards.  *>
      *                                                                  *>
      * (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
      * Rights Reserved. 
      *----------------------------------------------------------------* *>
                                                                         *>
      *-----------------< CLASS PROGRAM DEFINITION >-------------------* *>
       Class-Id.   TextAndEditFields                                     *>
                   data is private                                       *>
                   inherits from Modal.                                  *>
                                                                         *>
       Object Section.                                                   *>
                                                                         *>
       Class-Control.                                                    *> Declare the classes that this class uses directly
           Modal               is class "modal"                          *> From the class library - we use this class to create and control a modal dialog box
           TextAndEditFields   is class "TextEdit"                       *> Our own class
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
                                                                         *> painted in the dialog editor - it gets this from the resource file
       Local-Storage Section.                                            *>
       01 aModalDialogBox          object reference.                     *>
       01 ResourceId               pic x(4) comp-5.                      *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkParent                object reference.                     *>
       01 lnkResource              object reference.                     *>
                                                                         *>
       Procedure Division using lnkParent                                *>
                                lnkResource.                             *>
                                                                         *>
      *--> Create our Modal Dialog box from the resource file            *>
      *--  as a child window of lnkParent                                *>
           move DLG-TEXT-EDIT-FIELD-DEMO  to ResourceId                  *> Use the symbol no for our dialog box as a sort of "index" to find it in the resource file
                                                                         *>
           invoke Self "FromResource" using lnkParent                    *> This DialogBox method finds the dialog box we painted in the resource file and creates it as
                                            lnkResource                  *> an object for us to use.  The resource file contains all the resources we want to use, like
                                            ResourceId                   *> screen designs, menu layouts, bitmaps and toolbar designs.
                                  returning aModalDialogBox              *>
                                                                         *>
      *--> aModalDialogBox has just been created as an instance object   *>
      *--  of our Text&EditField Class - so we can now create it as a    *>
      *--  displayable object                                            *>
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
       01  oEditField             object reference.                      *> easier to stick to processing objects - we rarely need to change them to COBOL fields unless
       01  oTextField             object reference.                      *>we're putting them on a database or into a file or something like that.
                                                                         *>
      *--> our fields declared as pic x fields for use in normal COBOL   *>
      *--  processing                                                    *>
       01  xEditField             pic x(20) value "Pre-displayed field". *>
       01  xTextField             pic x(20) value "Changed Text Label".  *>
       01  xAcceptEditField       pic x(20).                             *> These fields are just somewhere to accept values into
       01  xAcceptTextField       pic x(20).                             *>
                                                                         *>
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
                                                                         *>
       Exit Method.                                                      *>
       End Method "Create".                                              *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "AcceptFields".                                                 *>
      *> Invoked when the Dialog box "Accept Fields" button pushed       *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventAcceptFields".                                 *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *> A genreic working variable - an object which will contain a character string
       01 StringLength                 pic x(04) comp-5.                 *> The base classes take numeric parameters as pic x(04) comp-5, so that's what we must use
       01 lsMessage                    pic x(100).                       *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
      *--> Accept EditField                                              *>
           move spaces to xAcceptEditField                               *> We must initialise the field to spaces, as the CharacterArray methods do not space pad fields
                                                                         *>
           move length of xAcceptEditField to StringLength               *> Get the length of the field we are getting
                                                                         *>
           invoke oEditField "GetText" returning aString                 *> Use this EntryField method to return an object containing the value of the string we want
                                                                         *>
           invoke aString "GetValueWithSize" using StringLength          *> Use this CharacterArray method to return the 1st "StringLength" characters of "aString" into
                                         returning xAcceptEditField      *> a pic x field - it works like "move aString (1:StringLength) to AcceptEditField".
                                                                         *>
           invoke aString "Finalize" returning aString                   *> destroy the string object
                                                                         *>
      *--> Accept TextField                                              *>
           move spaces to xAcceptTextField                               *> we must initialise the field to spaces, as the CharacterArray methods do not space pad fields
                                                                         *>
           move length of xAcceptTextField to StringLength               *> Get the length of the field we are getting
                                                                         *>
           invoke oTextField "GetText" returning aString                 *> Use this StaticText method to return an object containing the value of the string we want
                                                                         *>
           invoke aString "GetValueWithSize" using StringLength          *> Use this CharacterArray method to return the 1st "StringLength" characters of "aString" into
                                         returning xAcceptTextField      *> a pic x field - it works like "move aString (1:StringLength) to TextField".
                                                                         *>
           invoke aString "Finalize" returning aString                   *> destroy the string object
                                                                         *>
           string "Edit Field Value = " xAcceptEditField                 *>
                  wsNewLine                                              *>
                  "Text Field Value = " xAcceptTextField                 *>
                  wsNullTerminator                                       *>
                  delimited by size                                      *>
                  into lsMessage                                         *>
           end-string                                                    *>
                                                                         *>
           invoke self "DisplayMessageBox" using lsMessage               *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventAcceptFields".                                 *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "ChangeTextField"                                               *>
      *> Invoked when the Dialog Box "Change Text Field" button pushed   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventChangeTextField".                              *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *>
       01 StringLength                 pic x(04) comp-5.                 *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           move length of xTextField to StringLength                     *> Get the length of the field we are setting
                                                                         *>
           invoke CharacterArray "WithLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xTextField      *> and the value in xTextField
                                               returning aString         *>
                                                                         *>
           invoke oTextField "SetLabel" using aString                    *> Use this StaticText method to set the value ("label") of our text field on screen to the
                                                                         *> Value contained in "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
      *--> You can also do it using a null terminated string instead     *> The comment lines to the right show an alternative method of setting the text field value
      *--  in the following two ways:                                    *>
      * 1.                                                               *>
      *    invoke CharacterArray "WithValue" using z"My Nice String"     *> Use this CharacterArray method to create "aString" object of from a null terminated string
      *           returning aString                                      *>
      *                                                                  *>
      *    invoke oTextField "SetLabel" using aString                    *>
      *                                                                  *>
      * 2.                                                               *>
      *    invoke oTextField "SetLabelZ" using z"My Nice String"         *>                                             *>
      *                                                                  *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventChangeTextField".                              *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "PreDisplayEditField"                                           *>
      *> Invoked when the Dialog Box "Pre display edit field" pushed     *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventPreDisplayEditField".                          *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *>
       01 StringLength                 pic x(04) comp-5.                 *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           move length of xEditField to StringLength                     *> Get the length of the field we are getting
                                                                         *>
           invoke CharacterArray "WithLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xEditField      *> and the value in xEditField
                                               returning aString         *>
                                                                         *>
           invoke oEditField "SetText" using aString                     *> Use this EntryField method to set the text of the screen edit field (oEditField) to "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
      *> you only have to do this if you want to make sure the user      *>
      *> can only type in a certain no of characters                     *>
           invoke oEditField "SetLength" using StringLength              *> Use this EntryFiled method to set the length of the above edit field if required
                                                                         *>
      *--> You can also do it using a null terminated string instead     *> The comment lines to the right show an alternative method of setting the edit field value
      *--  as follows                                                    *>
      *    invoke CharacterArray "WithValue" using z"Initial Value"      *> Use this CharacterArray method to create "aString" object of from a null terminated string
      *           returning aString                                      *>
      *                                                                  *>
      *    invoke osEditField"SetText" using aString                     *> As Above
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventPreDisplayEditField".                          *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "DisableEditField"                                              *>
      *> Invoked when the Dialog Box "Disable edit field" pushed         *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventDisableEditField".                             *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           invoke oEditField "Disable"                                   *> This AbstractWindow method disables the field
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventDisableEditField".                             *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "EnableEditField"                                               *>
      *> Invoked when the Dialog Box "Enable edit field" pushed          *>
      *>---------------------------------------------------------------* *>
                                                                         *>
       Method-Id. "OnEventEnableEditField".                              *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           invoke oEditField "Enable"                                    *> This AbstractWindow method enables the field
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventEnableEditField".                              *>
                                                                         *>
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
      *> Common finalize method - hide box and destroy all objects       *>
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
      *> 1. use symbol number to get a handle to the control             *>
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
      *--> Accept From Edit field button clicked                         *>
           move PB-ACCEPT-FIELDS            to lsResourceID              *> 1.Use symbol no. to get a handle to this control - The symbol numbers are defined in
           invoke self "GetObjectFromId" using lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the get our button from the resource
                                     returning lsPushbutton              *>   file and create it as the object lsPushButton.
           map event clicked upon lsPushbutton to                        *> 2.Use this GUIBase method (in GUIBase.if at the top of the code) to link the "clicked" event
               method z"OnEventAcceptFields" upon self                   *>   on "lsPushbutton" to the method "AcceptEditField" in this object. We've passed the name as
                                                                         *>   a Null terminated string.
      *--> Change Text Field button clicked                              *>
           move PB-CHANGE-TEXT-FIELD        to lsResourceID              *> As Above
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventChangeTextField" upon self                *>
                                                                         *>
      *--> Pre-Display Edit Field button clicked                         *> As Above
           move PB-PREDISPLAY-EDIT-FIELD    to lsResourceID              *>
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventPreDisplayEditField" upon self            *>
                                                                         *>
      *--> Disable Edit Field                                            *> As Above
           move PB-DISABLE-EDIT-FIELD       to lsResourceID              *>
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventDisableEditField" upon self               *>
                                                                         *>
      *--> Enable Edit Field                                             *> As Above
           move PB-ENABLE-EDIT-FIELD        to lsResourceID              *>
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventEnableEditField" upon self                *>
                                                                         *>
      *--> Cancel button clicked                                         *> As Above
           move IDCANCEL                    to lsResourceID              *>
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning lsPushbutton              *>
           map event clicked upon lsPushbutton to                        *>
               method z"OnEventCancel" upon self                         *>
                                                                         *>
      *--> Close button clicked > usually same as cancel.                *>
           map event closed upon self to                                 *> This time we don't need to get a handle to the control as above, because the close button
               method z"OnEventClose" upon self                          *> belongs to the dialog box - which is us!
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
       01 aString                      object reference.                 *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *> **> EDIT AND TEXT FIELDS <**
           move EF-EDIT-FIELD to lsResourceID                            *> 1.Use symbol no. to get a handle to this control/field - The symbol numbers are defined in
           invoke self "GetObjectFromId" using lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the get our edit/text field from the
                                     returning oEditField                *>   resource file and create it as an object.
                                                                         *> 2."getObjectFromID" takes edit fields from the screen and creates them as an object of class
           move TF-TEXT-FIELD to lsResourceID                            *>   EntryField.  Text fields are taken and created as objects of class StaticText.
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning oTextField                *>
                                                                         *>
           invoke CharacterArray "WithValue"                             *> Here we use the alternative way to put a value into an edit field as mentioned in the Method
                      using z"Edit Field Value"                          *> "PreDisplayEditField"
                  returning aString                                      *>
                                                                         *>
           invoke oEditField "SetText" using aString                     *>
                                                                         *>
      *    invoke oEditField "SetEmpty"                                  *> Use this EntryField method if you want the edit field to be empty initially
                                                                         *>
           invoke oEditField "SetFocus"                                  *> Use this EntryField method if you want to be in focus on this field when the screen is shown
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
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
           invoke aMsgBox "SetTitleZ" using z"Text & Edit Field Values"  *>
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
       End Class TextAndEditFields.                                      *>
