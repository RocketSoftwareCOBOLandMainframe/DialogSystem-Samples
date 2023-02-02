       copy "guibase.if".                                               *> Standard interface to GUIBase class using vocabulary generator - You can just invoke GUIBase methods directly if you wish.
      *>--------------------------------------------------------------
      *> Updown Demonstration Class :
      *>
      *> This is a modal Dialog Box. The dialog box has been created
      *> using the Dialog Editor. This class demonstrates how to use
      *> updown controls in your program - In Particular :
      *>
      *>   How to use an updown control to increment or decrement
      *>    -  the value of a number displayed in a companion control
      *>    -  the scroll position of a companion control such as a
      *>       list box.
      *>
      *> Screen Controls Used :
      *>
      *>   - Updown buttons - To increment or decrement companion
      *>                      controls
      *>   - Edit Field     - Companion control containing numeric value
      *>   - List box       - Companion control containing a list of
      *>                      items
      *>
      *>
      *> Copyright (C) 1996-2000  Micro Focus International Ltd.
      *>--------------------------------------------------------------

      *>------------------<CLASSS PROGRAM DEFINITION>-----------------

       Class-id. UpDownControls
              data is private
              inherits from Modal.

       Object section.


       Class-control.                                                   *> Declare the classes that this class uses directly
           Modal is class "modal"                                       *> From the class library - we use this class to create and control a modal dialog box
           UpDownControls is class "UpDownct"                           *> Our own class
           CharacterArray is class "chararry"                           *> From the class library - we use this to create string object to add to a listbox
           .

      *--------------< COMMON CLASS & INSTANCE DATA >------------------*
       working-storage section.
      *> Common Data
       copy "mfres.cpy".      *> Symbol nos to identify screen controls
       copy "p2cevent.cpy".   *> 78s used to identify physical events

      *--------------------< CLASS DEFINITION >------------------------*
       class-object.

      *----------------------< CLASS DATA >----------------------------*
       object-storage section.
       *> None at the moment

      *---------------------< CLASS METHODS >--------------------------*
       method-id. "ShowDemo".                                           *> This class method creates an instance of class "Modal" - a modal dialog box - from the one we
                                                                        *> painted in the dialog editor - it gets this from the resource file
       local-storage section.
       01 lsDialog                 object reference.
       01 lsId                     pic x(4) comp-5.

       linkage section.
       01 lnkresource              object reference.
       01 lnkparent                object reference.

       procedure division using lnkparent
                                lnkresource.
      *--> Create our Modal Dialog box from the resource file
      *--  as a child window of lnkParent

           move DLG-UP-DOWN-CONTROLS to lsId                            *> Use the symbol no for our dialog box as a sort of "index" to find it in the resource file
                                                                        *>
           invoke self "fromResource" using lnkparent                   *> This DialogBox method finds the dialog box we painted in the resource file and creates it as
                                        lnkresource                     *> an object for us to use.  The resource file contains all the resources we want to use, like
                                        lsId                            *> screen designs, menu layouts, bitmaps and toolbar designs.
                                        returning lsDialog
      *--> lsDialog has just been created as an instance object
      *--  of our UpDownControls Class - so we can initialize it
           invoke lsDialog "create"                                     *> This is our own instance method which sets up the initial state of our dialog box and events

      *--> Display the ModalDialogBox created and wait for screen events*>
           invoke lsDialog "show"                                       *> This is a method of the Modal class we inherited which shows our dialog box on the screen and
                                                                        *> then waits for an event to happen to it.
       Exit method.
       End method "ShowDemo".

       End class-object.

      *-------------------< INSTANCE DEFINITION >----------------------*
       Object.

      *---------------------< INSTANCE DATA >--------------------------*
       Object-Storage Section.
      *--> our fields, listbox and updown controls declared as objects
      *--> for use in various methods
       01 oEditField             object reference.
       01 oListBox               object reference.
       01 oUpDown1               object reference.
       01 oUpDown2               object reference.
       01 oPushbutton           object reference.

      *--------------------< INSTANCE METHODS >------------------------*
      *----------------------------------------------------------------*
      *> "Create"
      *>---------------------------------------------------------------*
      *> Dialog box definition method.
      *>   - Create the dialog box
      *>   - Link fields/controls on the screen to fields/controls
      *>     in our class program
      *>   - Define Event Handling
      *>       - Link Button events to method names in the code
      *>   - Set any initial values for our screen fields
      *>---------------------------------------------------------------*
       method-id. "create".

       procedure division.
           invoke super "create"  *> To create our dialog box
           invoke self  "mapScreenAndProgramFields"
           invoke self  "mapControlsToMethods"
           invoke self  "InitializeDialog"

       Exit method.
       End method "create".

      *>---------------------------------------------------------------*
      *> "mapScreenAndProgramFields"
      *>---------------------------------------------------------------*
      *> Use symbol nos of screen fields/controls to link them with
      *> field/controls objects in the program.
      *>---------------------------------------------------------------*
       method-id. "mapScreenAndProgramFields".

       local-storage section.
       01 lsResourceId                 pic x(4) comp-5.

       procedure division.

           move IDCANCEL to lsResourceId                                *> Use symbol no. to get a handle to this pushbutton - The symbol numbers are defined in
           invoke self "getObjectFromId" using lsResourceId             *> The Dialog Editor. "GetObjectFromID" uses the symbol the get our pushbutton from the
                                         returning oPushbutton          *> resource file and create it as an object.

           move EF-EDIT-FIELD3 to lsResourceId                          *> similarly for our edit field
           invoke self "getObjectFromId" using lsResourceId             *> Certain properties can be set withinn the dialog editor, this edit field is set to readonly
                                     returning oEditField               *> from the styles dialogbox applying to this edit field in dialog editor. You cannot invoke the
                                                                        *> "readonly" method on the edit field later since this property has to be set at create time
                                                                        *> ie from dialog editor.

           move UD-UPDOWN-CONTROL1 to lsResourceId                      *> similarly for our first updown control
           invoke self "getObjectFromId" using lsResourceId
                                     returning oUpDown1

           move LB-LISTBOX to lsResourceId                              *> similarly for our list box
           invoke self "getObjectFromId" using lsResourceId
                                     returning oListBox

           move UD-UPDOWN-CONTROL2 to lsResourceId                      *> similarly for our second updown control
           invoke self "getObjectFromId" using lsResourceId
                                     returning oUpDown2

       Exit method.
       End method "mapScreenAndProgramFields".

      *>---------------------------------------------------------------*
      *> "mapControlsToMethods"
      *>---------------------------------------------------------------*
      *> Map physical events on controls to a method in the code
      *>---------------------------------------------------------------*
       method-id. "mapControlsToMethods".
       procedure division.

      *--> OK button clicked
           map event clicked upon oPushbutton to method z"OnEventCancel"*> Use this GUIBase method (in GUIBase.if at the top of the code) to link the "clicked" event
                                               upon self                *> on "lsPushbutton" to the method "OnOk" in this object. We've passed the name as
                                                                        *> a Null terminated string.
      *--> Close button clicked > usually same as cancel.
           map event closed upon self to                                *> Link the "closed" event on the dialog box (self - the close button belongs to the dialog box)
               method z"OnEventClose" upon self                         *> to the method "OnEventClose" in this object.

       Exit method.
       End method "mapControlsToMethods".

      *----------------------------------------------------------------*
      *> "InitializeDialog"                                            *
      *>   -  sets the initial value of the Edit Field                 *
      *>   -  sets the buddy controls of the updown controls           *
      *>   -  sets a range on the updown linked to the Edit Field      *
      *>   -  initializes the listbox with some values and sets the    *
      *>      first item of the listbox to be initially selected.      *
      *>---------------------------------------------------------------*
       method-id. "InitializeDialog".
       local-storage section.
       01 astring                      object reference.
       01 lsbase                       pic x(4) comp-5.
       01 lsindex                      pic x(4) comp-5.
       01 i                            pic x(4) comp-5.
       01 j                            pic x(4) comp-5.

       procedure division.
           invoke characterarray "withvalue" using z"1"                 *> Use this CharacterArray method to create "aString" object containing the null terminated
                                             returning astring          *> value "1"
           invoke oEditField "settext" using astring                    *> Use the class library method "settext" to set the initial value of the edit field
                                                                        *> to the previousely defined string.
           invoke astring "finalize" returning astring

           invoke oUpDown1 "setbuddycontrol" using oEditField           *> Use the class library method "setbuddycontrol" to link this updown control with
                                                                        *> the edit field.
           move 1 to i
           move 8 to j
           invoke oUpDown1 "setrange" using i j                         *> Use the class library method "setrange" to set the range of the updown control

      *    move 16 to lsbase                                            *> Can set the base of the buddy control, i.e. to use hexa-decimal lnkbase would be 16
      *    invoke oUpDown1 "setbase" using lsbase

           invoke characterarray "withvalue" using z"item1"             *> Use this CharacterArray method to create "aString" containing the null terminated
                                             returning astring          *> value "item1"
           invoke oListBox "additem" using astring                      *> Use the class library method "additem" to add the previousely defined string to the list
           invoke astring "finalize" returning astring

           move 1 to lsindex
           invoke oListBox "selectitem" using lsindex                   *> Use the class library method "selectitem" to make the lnkindex item in the list initialaly selected

           invoke characterarray "withvalue" using z"item2"             *> Create "astring" object containg the value "item2" and add it to the listbox as above
                                             returning astring
           invoke oListBox "additem" using astring
           invoke astring "finalize" returning astring

           invoke characterarray "withvalue" using z"item3"             *> Create "astring" object containg the value "item3" and add it to the listbox as above
                                             returning astring
           invoke oListBox "additem" using astring
           invoke astring "finalize" returning astring

           invoke oUpDown2 "setbuddycontrol" using oListBox             *> Use the class library method "setbuddycontrol" to link this updown control with
                                                                        *> the list box.
       Exit method.
       End method "InitializeDialog".


      *----------------------------------------------------------------*
      *> "OnEventCancel"
      *> Invoked when the Dialog Box Cancel button is pressed.
      *>---------------------------------------------------------------*
       Method-Id. "OnEventCancel".

       Linkage Section.
       01 lnkEventObject               object reference.                 *> Each event sends this to it's method - it's a handle to the object which caused the event

       Procedure Division using lnkEventObject.

           invoke self "AllDone"                                        *> call to a common finalising method

       Exit Method.
       End Method "OnEventCancel".

      *----------------------------------------------------------------*
      *> "OnEventClose"
      *> Invoked when the Dialog Box close button is pushed
      *>---------------------------------------------------------------*
       Method-Id. "OnEventClose".

       Linkage Section.
       01 lnkEventObject               object reference.                *> Each event sends this to it's method - it's a handle to the object which caused the event

       Procedure Division using lnkEventObject.

           invoke self "AllDone"                                        *> call to a common finalising method

       Exit Method.
       End Method "OnEventClose".

      *>---------------------------------------------------------------*

      *>---------------------------------------------------------------*
      *> "AllDone"
      *> Common finalise method - hide box and destroy all objects
      *>---------------------------------------------------------------*
       Method-Id. "AllDone".
      *>---------------------------------------------------------------*

       procedure division.
           invoke self "hide"
           invoke self "Finalize" returning self
       Exit method.
       End method "AllDone".

       end object.

       end class UpDownControls.
