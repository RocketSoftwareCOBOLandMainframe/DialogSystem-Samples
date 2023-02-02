       copy "guibase.if".                                                *> Standard interface to GUIBase class using vocabulary generator - you can just invoke GUIBase
      *----------------------------------------------------------------* *> methods directly if you wish.
      *  About Box Demonstration Class :                                 *>
      *                                                                  *>
      *  This is a Modal Dialog Box. The Dialog box has been created in  *>
      *  the Dialog Editor. This class demonstrates a simple about box   *>
      *                                                                  *>
      *  Screen Controls Used :                                          *>

      *  - Pushbuttons - To perform actions                              *>
      *                                                                  *>
      *  The code in this Class Program is well commented, and further   *>
      *  explanations are given as in-line comments in cols 73 onwards.  *>
      *                                                                  *>
      *  Copyright (C) 1996-2000  Micro Focus International Ltd.
      *----------------------------------------------------------------* *>
                                                                         *>
      *-----------------< CLASS PROGRAM DEFINITION >-------------------* *>
       Class-Id.   AboutBox                                              *>
                   data is private                                       *>
                   inherits from Modal.                                  *>
                                                                         *>
       Object Section.                                                   *>
                                                                         *>
       Class-Control.                                                    *> Declare the classes that this class uses directly
           Modal               is class "modal"                          *> From the class library - we use this class to create and control a modal dialog box
           AboutBox            is class "AboutBox"                       *> Our own class
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
           move DLG-ABOUT to ResourceId                                  *> Use the symbol no for our dialog box as a sort of "index" to find it in the resource file
                                                                         *>
           invoke Self "FromResource" using lnkParent                    *> This DialogBox method finds the dialog box we painted in the resource file and creates it as
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
       *> None at the moment                                             *>
                                                                         *>
      *--------------------< INSTANCE METHODS >------------------------* *>
      *>---------------------------------------------------------------* *>
      *> "Create"                                                        *>
      *>---------------------------------------------------------------* *>
      *> Dialog box definition method.                                   *>
      *>   - Create the dialog box                                       *>
      *>   - Define Event Handling                                       *>
      *>       - Link Screen events to method names in the code          *>
      *>---------------------------------------------------------------* *>
       Method-Id. "Create".                                              *>
       Procedure Division.                                               *>
                                                                         *>
           invoke super "Create" *> To create our dialog box             *>
           invoke self "LinkScreenEventsToMethods"                       *>
                                                                         *>
       Exit Method.                                                      *>
       End Method "Create".                                              *>
                                                                         *>
      *>---------------------------------------------------------------* *>
      *> "OnOK".                                                         *>
      *> Invoked when the Dialog Box OK button is pressed                *>
      *>---------------------------------------------------------------* *>
       Method-Id. "OnEventOK".                                           *>
                                                                         *>
       Linkage Section.                                                  *>
       01 lnkEvent                     object reference.                 *>
                                                                         *>
       Procedure Division using lnkEvent.                                *>
                                                                         *>
           invoke self "AllDone"                                         *> call to a common finalising method
                                                                         *>
       Exit Method.                                                      *>
       End Method "OnEventOK".                                           *>
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
      *--> OK button clicked                                             *> 1.Use symbol no. to get a handle to this control - The symbol numbers are defined in
           move IDOK                        to lsResourceID              *>   The Dialog Editor. "GetObjectFromID" uses the symbol the get our button from the resource
           invoke self "GetObjectFromId" using lsResourceID              *>   file and create it as the object lsPushButton.
                                     returning lsPushbutton              *> 2.Use this GUIBase method (in GUIBase.if at the top of the code) to link the "clicked" event
           map event clicked upon lsPushbutton to                        *>   on "lsPushbutton" to the method "OnOK" in this object. We've passed the name as
               method z"OnEventOK" upon self                             *>   a Null terminated string.
                                                                         *>
      *--> Close button clicked > usually same as cancel.                *>
           map event closed upon self to                                 *> This time we don't need to get a handle to the control as above, because the close button
               method z"OnEventClose" upon self                          *> belongs to the dialog box - which is us!
                                                                         *>
       Exit Method.                                                      *>
       End Method "LinkScreenEventsToMethods".                           *>
                                                                         *>
       End Object.                                                       *>
                                                                         *>
       End Class AboutBox.

