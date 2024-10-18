       copy "guibase.if".                                                *> Standard interface to GUIBase class using vocabulary generator - you can just invoke GUIBase
      *----------------------------------------------------------------* *> methods directly if you wish.
      *  Lose & Gain Focus Demonstration Class :                         *>
      *                                                                  *>
      *  This is a Modal Dialog Box. The Dialog box has been created in  *>
      *  the Dialog Editor. This class demonstrates how to use the       *>
      *  "lost-focus" & "gained-focus" events on edit fields.  These     *>
      *  are triggered on entry to or exit from an edit field, and are   *>
      *  useful for such things as field by field validation.            *>
      *                                                                  *>
      *  These events are not normally available to the program, so you  *>
      *  have to tell the field or control in question that you are      *>
      *  interested in these events first.                               *>
      *                                                                  *>
      *  Screen Controls Used :                                          *>
      *                                                                  *>
      *  - Edit Fields - you use these for data entry / display          *>
      *  - Pushbuttons - OK to exit                                      *>
      *                                                                  *>
      *  The code in this Class Program is well commented, and further   *>
      *  explanations are given as in-line comments in cols 73 onwards.  *>
      *                                                                  *>
      * (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
      * Rights Reserved. 
      *----------------------------------------------------------------* *>
                                                                         *>
      *-----------------< CLASS PROGRAM DEFINITION >-------------------* *>
       Class-Id.   LoseAndGainFocus                                      *>
                   data is private                                       *>
                   inherits from Modal.                                  *>
                                                                         *>
       Object Section.                                                   *>
                                                                         *>
       Class-Control.                                                    *> Declare the classes that this class uses directly
           Modal               is class "modal"                          *> From the class library - we use this class to create and control a modal dialog box
           LoseAndGainFocus    is class "LoseGain"                       *> Our own class
           CharacterArray      is class "chararry"                       *> From the class library - we use this class to change objects to pic x strings and back
           .                                                             *>
                                                                         *>
      *--------------< COMMON CLASS & INSTANCE DATA >------------------* *>
       Working-Storage Section.                                          *> Declare the data that can be accessed from both the class and instances of the class
                                                                         *>
      *--> Copy files                                                    *>
       copy "mfres.cpy".    *> Symbol nos to identify screen controls    *>
       copy "p2cevent.cpy". *> 78s used to identify physical events      *>
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
       01 lnkResource              object reference.                     *>
       01 lnkParent                object reference.                     *>
                                                                         *>
       Procedure Division using lnkParent                                *>
                                lnkResource.                             *>
                                                                         *>
      *--> Create our Modal Dialog box from the resource file            *>
      *--  as a child window of lnkParent                                *>
           move DLG-LOSE-AND-GAIN-FOCUS  to ResourceId                   *> Use the symbol no for our dialog box as a sort of "index" to find it in the resource file
                                                                         *>
           invoke Self "fromResource" using lnkParent                    *> This DialogBox method finds the dialog box we painted in the resource file and creates it as
                                            lnkResource                  *> an object for us to use.  The resource file contains all the resources we want to use, like
                                            ResourceId                   *> screen designs, menu layouts, bitmaps and toolbar designs.
                                  returning aModalDialogBox              *>
                                                                         *>
      *--> aModalDialogBox has just been created as an instance object   *>
      *--  of our Text&EditField Class - so we can initialize it         *>
           invoke aModalDialogBox "Create"                               *> This is our own instance method which Sets up the initial state of our dialog box and events
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
       01  oEditField1            object reference.                      *> easier to stick to processing objects - we rarely need to change them to COBOL fields unless
       01  oEditField2            object reference.                      *>
                                                                         *>
      *--> our fields declared as pic x fields for use in normal COBOL   *>
      *--  processing                                                    *>
       01  xEditField1            pic x(20) value "Edit Field 1".        *>
       01  xEditField2            pic x(20) value "Edit Field 2".        *>
       01  xGainedFocus           pic x(20) value "Gained Focus".        *>
       01  xLostFocus             pic x(20) value "Lost Focus".          *>
                                                                         *>
      *--------------------< INSTANCE METHODS >------------------------* *>
      *>---------------------------------------------------------------* *>
      *> "Create"                                                        *>
      *>---------------------------------------------------------------* *>
      *> Dialog box definition method.                                   *>
      *>   - Create the dialog box                                       *>
      *>   - Link fields on the screen to fields in our class program    *>
      *>   - Set any initial values for our screen fields                *>
      *>   - Define Event Handling                                       *>
      *>       - Link Field events to method names in the code           *>
      *>       - Link Button events to method names in the code          *>
      *>---------------------------------------------------------------* *>
       Method-Id. "Create".                                              *>
       Procedure Division.                                               *>
                                                                         *>
           invoke super "Create" *> To create our dialog box             *>
           invoke self "LinkScreenAndProgramFields"                      *>
           invoke self "InitializeEditFields"                            *>
           invoke self "LinkFieldEventsToMethods"                        *>
           invoke self "LinkButtonEventsToMethods"                       *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "Create".                                              *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventGainedFocusEditField1"                                  *>
      *> Invoked when Focus is gained by EditField1 - in                 *>
      *> other words - when the edit field is entered                    *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventGainedFocusEditField1".                        *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "GainedFocus" using oEditField1                   *> Method in this class program which Sets the text in this fields to "gained focus"
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventGainedFocusEditField1".                        *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventGainedFocusEditField2"                                  *>
      *> Invoked when Focus is gained by EditField2 - in                 *>
      *> other words - when the edit field is entered                    *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventGainedFocusEditField2".                        *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "GainedFocus" using oEditField2                   *> Method in this class program which Sets the text in this fields to "gained focus"
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventGainedFocusEditField2".                        *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "GainedFocus"                                                   *>
      *> Puts text in given edit field to say it has Gained focus        *>
      *>---------------------------------------------------------------* *>
       Method-Id. "GainedFocus".                                         *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *>
       01 StringLength                 pic x(04) comp-5.                 *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkObject                    object reference.                 *>
                                                                         *>
       Procedure Division using lnkObject.                               *>
                                                                         *>
      *--> Set value in object causing event "GainedFocus"               *>
           move length of xGainedFocus to StringLength                   *> Get the length of the field we are Setting
                                                                         *>
           invoke CharacterArray "withLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xGainedFocus    *> and the value in xGainedFocus
                                               returning aString         *>
                                                                         *>
           invoke lnkObject "SetText" using aString                      *> Use this EntryField method to Set the text of the screen edit field to "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
       Exit Method.                                                      *>
       End Method "GainedFocus".                                           *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventLostFocusEditField1"                                    *>
      *> Invoked when Focus is lost by EditField1 - in                   *>
      *> other words - when the edit field is exited                     *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventLostFocusEditField1".                          *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "LostFocus" using oEditField1                     *> Method in this class program which Sets the text in this fields to "lost focus"
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventLostFocusEditField1".                          *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventLostFocusEditField2"                                    *>
      *> Invoked when Focus is lost by EditField2 - in                   *>
      *> other words - when the edit field is exited                     *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventLostFocusEditField2".                          *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "LostFocus" using oEditField2                     *> Method in this class program which Sets the text in this fields to "lost focus"
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventLostFocusEditField2".                          *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LostFocus"                                                     *>
      *> Puts text in given edit field to say it has lost focus          *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LostFocus".                                           *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *>
       01 StringLength                 pic x(04) comp-5.                 *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkObject                    object reference.                 *>
                                                                         *>
       Procedure Division using lnkObject.                               *>
                                                                         *>
      *--> Set value in object causing event "LostFocus"                 *>
           move length of xLostFocus to StringLength                     *> Get the length of the field we are Setting
                                                                         *>
           invoke CharacterArray "withLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xLostFocus      *> and the value in xLostFocus
                                               returning aString         *>
                                                                         *>
           invoke lnkObject "SetText" using aString                      *> Use this EntryField method to Set the text of the screen edit field to "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
       Exit Method.                                                      *>
       End Method "LostFocus".                                           *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventOK"                                                     *>
      *> Invoked when the Dialog Box OK button is pressed.               *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventOK".                                           *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "AllDone"                                         *> call to a common finalising method
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventOK".                                           *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnEventClose"                                                  *>
      *> Invoked when the Dialog Box close button is pushed              *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventClose".                                        *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event
                                                                         *>
       Procedure Division using lnkEventObject.                          *>
                                                                         *>
           invoke self "AllDone"                                         *> call to a common finalising method
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventClose".                                        *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "AllDone"                                                       *>
      *> Common Finalize method - hide box and destroy all objects       *>
      *>---------------------------------------------------------------* *>
       Method-Id. "AllDone".                                             *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
           invoke Self "Hide"                                            *>
           invoke oEditField1 "CancelAccessToSystemEvents"               *> Use this Gadget method to tell the system we are no longer interested in events
           invoke oEditField2 "CancelAccessToSystemEvents"               *> from our edit fields
           invoke self "Finalize" returning self                         *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "AllDone".                                             *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LinkScreenAndProgramFields"                                    *>
      *>---------------------------------------------------------------* *>
      *> Use symbol nos of screen fields to link them with field         *>
      *> objects in the program.                                         *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LinkScreenAndProgramFields".                          *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsResourceID                 pic x(4) comp-5.                  *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *> **> EDIT AND TEXT FIELDS <**
           move EF-EDIT-FIELD1 to lsResourceID                           *> 1.Use symbol no. to get a handle to this control/field - The symbol numbers are defined in
           invoke self "GetObjectFromId" using lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the get our edit/text field from the
                                     returning oEditField1               *>   resource file and create it as an object.
                                                                         *> 2."getObjectFromID" takes edit fields from the screen and creates them as an object of class
           move EF-EDIT-FIELD2 to lsResourceID                           *>   EntryField.  Text fields are taken and created as objects of class StaticText.
           invoke self "GetObjectFromId" using lsResourceID              *>
                                     returning oEditField2               *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkScreenAndProgramFields".                          *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "InitializeEditFields"                                          *>
      *>---------------------------------------------------------------* *>
      *> Use symbol nos of screen entry fields to link them with field   *>
      *> objects in the program.  Initialise them too.                   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "InitializeEditFields".                                *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 aString                      object reference.                 *>
       01 StringLength                 pic x(04) comp-5.                 *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
      *--> put initial value in edit field 1                             *>
           move length of xEditField1 to StringLength                    *> Get the length of the field we are Setting
                                                                         *>
           invoke CharacterArray "withLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xEditField1     *> and the value in xEditField
                                               returning aString         *>
                                                                         *>
           invoke oEditField1 "SetText" using aString                    *> Use this EntryField method to Set the text of the screen edit field (oEditField) to "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
      *--> put initial value in edit field 2                             *>
           move length of xEditField2 to StringLength                    *> Get the length of the field we are Setting
                                                                         *>
           invoke CharacterArray "withLengthValue" using StringLength    *> Use this CharacterArray method to create "aString" object of length StringLength
                                                         xEditField2     *> and the value in xEditField
                                               returning aString         *>
                                                                         *>
           invoke oEditField2 "SetText" using aString                    *> Use this EntryField method to Set the text of the screen edit field (oEditField) to "aString"
                                                                         *>
           invoke aString "Finalize" returning aString                   *> Destroy the local storage objects
                                                                         *>
      *--> Set a field to "empty" if required...                         *>
      *    invoke oEditField1 "SetEmpty"                                 *> Use this EntryField method if you want the edit field to be empty initially
                                                                         *>
      *--> Set Focus on a field if required...                           *>
           invoke oEditField1 "SetFocus"                                 *> Use this EntryField method if you want to be in focus on this field when the screen is shown
                                                                         *>
      *--> Use this alternate method if you want to use null terminated  *>
      *--  Strings for initialisation instead of pic x fields.           *>
      *    invoke CharacterArray "withValue"                             *> Here we use the alternative way to put a value into an edit field using a null terminated string
      *               using z"This Is An Edit Field"                     *>
      *           returning aString                                      *>
      *                                                                  *>
      *    invoke oEditField1 "SetText" using aString                    *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "InitializeEditFields".                                *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LinkFieldEventsToMethods"                                      *>
      *>---------------------------------------------------------------* *>
      *> Link physical events to method names                            *>
      *> 1. use symbol number to get a handle to the control             *>
      *> 2. map physical event on this control to a method in the code   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LinkFieldEventsToMethods".                            *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
      *--> Only standard events are passed back to the program by        *>
      *--  default, so we must first register our interest in the        *>
      *--  events for each field (we're interested in gained/lost focus) *>
           invoke oEditField1 "accessSystemEvents"                       *> Use this Gadget method to tell the system we are interested in events from our edit fields
           invoke oEditField2 "accessSystemEvents"                       *>  - the ones we are interested in are gained-focus and lost-focus (see p2cevent.cpy)
                                                                         *>
      *--> Gained-focus event on each edit field                         *> Gain Focus Event - this is the event generated as you enter a field (or any control)
           map event gained-focus upon oEditField1 to                    *> We map both fields to one general "OnGainedFocus" method here for simplicity.
               method z"OnEventGainedFocusEditField1" upon self          *>
                                                                         *>
           map event gained-focus upon oEditField2 to                    *>
               method z"OnEventGainedFocusEditField2" upon self          *>
                                                                         *>
      *--> lost-focus event on each edit field                           *> Lost Focus Event - this is the event generated as you exit a field (or any control)
           map event lost-focus upon oEditField1 to                      *> We map both fields to one general "OnLostFocus" method here for simplicity.
               method z"OnEventLostFocusEditField1" upon self            *>
                                                                         *>
           map event lost-focus upon oEditField2 to                      *>
               method z"OnEventLostFocusEditField2" upon self            *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkFieldEventsToMethods".                            *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "LinkButtonEventsToMethods"                                     *>
      *>---------------------------------------------------------------* *>
      *> Link physical events to method names                            *>
      *> 1. use symbol number to get a handle to the control             *>
      *> 2. map physical event on this control to a method in the code   *>
      *>---------------------------------------------------------------* *>
       Method-Id. "LinkButtonEventsToMethods".                           *>
                                                                         *>
       Local-Storage Section.                                            *>
       01 lsResourceID                 pic x(4) comp-5.                  *>
       01 lsPushbutton                 object reference.                 *>
                                                                         *>
       Procedure Division.                                               *>
                                                                         *>
      *--> OK button clicked                                             *> Button Clicks
           move IDOK                        to lsResourceID              *> 1.Use symbol no. to get a handle to this control - The symbol numbers are defined in
           invoke self "GetObjectFromId" using lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the get our button from the resource
                                     returning lsPushbutton              *>   file and create it as the object lsPushButton.
           map event clicked upon lsPushbutton to                        *> 2.Use this GUIBase method (in GUIBase.if at the top of the code) to link the "clicked" event
               method z"OnEventOK" upon self                             *>   on "lsPushbutton" to the method "AcceptEditField" in this object. We've passed the name as
                                                                         *>   a Null terminated string.
      *--> Close button clicked > usually same as cancel.                *>
           map event closed upon self to                                 *> This time we don't need to get a handle to the control as above, because the close button
               method z"OnEventClose" upon self                          *> belongs to the dialog box - which is us!
                                                                         *>
      *--> invoke lsPushbutton "Finalize" returning lsPushbutton         *> Destroy the local storage objects
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkButtonEventsToMethods".                           *>
                                                                         *>
       End Object.                                                       *>
                                                                         *>
       End Class LoseAndGainFocus.                                       *>
