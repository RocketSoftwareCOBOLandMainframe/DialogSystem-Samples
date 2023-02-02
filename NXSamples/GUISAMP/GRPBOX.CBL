       copy "guibase.if".                                               *> Standard interface to GUIBase class using vocabulary generator - You can just invoke GUIBase methods directly if you wish.
      *>--------------------------------------------------------------  *>
      *> Group Demonstration Class :                                    *>
      *>                                                                *>
      *> This is a modal Dialog Box. The dialog box has been created    *>
      *> using the Dialog Editor. This class demonstrates how to use a  *>
      *> group containing radio buttons within your program - In        *>
      *> Particular :                                                   *>
      *>                                                                *>
      *>   - How to display a group item                                *>
      *>   - How to Detect the status of radio buttons within the group *>
      *>   - How to detect which radio button has been selected         *>
      *>                                                                *>
      *> Screen Controls Used :                                         *>
      *>                                                                *>
      *>   - Pushbuttons   - To perform Actions                         *>
      *>   - Radiobuttons  - To select items                            *>
      *>   - MessageBox    - To display the radio button value selected *>
      *>                                                                *>
      *> The code in this class has been heavily commented, and further *>
      *> explanations are given as in-line comments in columns 73       *>
      *> Onwards.                                                       *>
      *>                                                                *>
      *> Copyright (C) 1996-2000  Micro Focus International Ltd.
      *>--------------------------------------------------------------  *>
                                                                        *>
      *>------------------<CLASSS PROGRAM DEFINITION>-----------------  *>
       class-id. GroupBoxDemo                                           *> Declare the name of this class.
                 data is private                                        *> Declares that children of this class do not have access to it's data
                 inherits from modal.                                   *> Forces this class to inherit the behaviour of the modal class from the class library. This implies that the dialog boxes created will be modal, I.E. you cannot move to other areas
                                                                        *> of the application whilst a dialog box created by this class is active
                                                                        *>
       Object Section.                                                  *> Class Objects
                                                                        *>
       class-control.                                                   *> Declare the classes that this class uses directly
           CharacterArray is class "chararry"                           *> From the class library - we use this class
           OrderedCollection is class "ordrdcll"                        *> From the class library - we use this class
           Module is class "module"                                     *> From the class library - we use this class
           MessageBox is class "msgbox"                                 *> From the class library - we use this class for creating and handling message boxes
           groupboxdemo is class "grpbox"                               *> Our own class
           radiobutton is class "radiobut"                              *> From the class library - we use this class for handling radio buttons
           Modal is class "modal"                                       *> From the class library - we use this class to create and control a modal dialog box
           .                                                            *>
                                                                        *>
      *>------------------<COMMON CLASS & INSTANCE DATA>--------------  *>
       working-storage section.                                         *> Declare the data that can be accessed from both the class and instances of the class
      *> Copy Files                                                     *>
       copy "mfres.cpy".                                                *> Copy file created by resource manager containing control names and symbol numbers
       copy "p2cevent.cpy".                                             *> Panels2 copy file containing level 78 items used to identify events
                                                                        *>
      *>------------------<CLASS DEFINITION>--------------------------  *>
       class-Object.                                                    *> Class data and methods start here
                                                                        *>
      *>------------------<COMMON CLASS & INSTANCE DATA>--------------  *>
       object-storage section.                                          *> None required within this class
                                                                        *>
      *>------------------<CLASS METHODS>-----------------------------  *>
       method-id. "ShowDemo".                                           *> The calling class invokes and executes this method to create and run the groupbox dialog
                                                                        *>
       local-storage section.                                           *> Contains data which is private to this method
       01 lsid pic x(4) comp-5.                                         *> Unique identifier for this dialog box
       01 lsDialog                 object reference.                    *> Used by this class as an object handle to the dialog which this class creates
                                                                        *>
       linkage section.                                                 *> Data passed from the invoking class
       01 lnkParent                object reference.                    *> The resource .dll file containing the dialog box GUI object
       01 lnkResource              object Reference.                    *> The parent of this dialog box, in this case another dialog box
       procedure division using lnkParent lnkResource.                  *> The executable code of the Run method
           move group-radio-screen to lsId                              *> Unique identifier for this dialog box using the symbol number for the dialog within the resource copy file
           invoke self "fromResource" using lnkparent lnkresource       *> Locates the required Groupbox dialog box within the resource file, and creates it as an object (lsdialog) that we can then use
                                           lsid returning lsDialog      *>
           invoke lsdialog "create"                                     *> Initializes the above created (lsdialog) dialog instance object, which sets up the initial state of the dialog and events
           invoke lsdialog "show"                                       *> Make the dialog visible, giving control to the eventmanager, and await user input.
       exit method.                                                     *> Return control to the invoking method of the invoking program
       end method "ShowDemo".                                           *> End of "ShowDemo" Method
       end class-object.                                                *> End of class data and methods
                                                                        *>
      *>------------------<INSTANCE DEFINITION>-----------------------  *>
       object.                                                          *> Instance data and methods start here
                                                                        *>
      *>------------------<INSTANCE DATA>-----------------------------  *>
       object-storage section.                                          *> Data declared here is visible throughout the rest of the class
       01 RadioButtonGroup         object reference.                    *> Used by this class as an object handle to the Group item which will be created as a control within lsdialog by this class
      *>------------------<INSTANCE METHODS>--------------------------  *>
      *>--------------------------------------------------------------  *>
       method-id. "create".                                             *> Instance method invoked by the class method "RUN"
       procedure division.                                              *>
       invoke super "create"                                            *> Invoke the inherited method to invoke and initialize the class
       invoke self "LinkScreenEventsToMethods"                          *> Invoke method to map events to methods within this class
       invoke self "LinkControlsToProgramFields"                        *> Invoke method to obtain object handles to the controls on the dialog for this class
       invoke self "InitializeControls"                                 *> Invoke method to intialize the screen controls, in particular, to populate the combo boxes with values
       exit method.                                                     *> Return control to the class method "RUN"
       end method "create".                                             *> End of "create" method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "LinkScreenEventsToMethods".                          *> Instance method invoked from the create instance method "RUN"
       local-storage section.                                           *> contains data private to this method
       01 lsId                         pic x(4) comp-5.                 *> Unique identifier for this dialog box
       01 lsPushbutton                 object reference.                *> Object reference item used for storing object handles to push button controls on our dialog
       procedure division.                                              *>
      *> Cancel Button.                                                 *>
           move idCancel to lsId                                        *> Pick up the symbol number for the cancel control for our dialog
           invoke self "getObjectFromId" using lsId                     *> Obtain an object reference to the cancel control for our dialog, using the cancel control's symbol number
                                     returning lsPushbutton             *>
           map event clicked upon lspushbutton to method                *> Use the GUIBase Map method to link the event "clicked" upon our cancel pushbutton control to
               z"OnEventCancel" upon self                               *> the method "Oncancel" within this class
      *> OK Button                                                      *> Similar processing as for Cancel button
           move idOK to lsId                                            *>
           invoke self "getObjectFromId" using lsId                     *>
                                     returning lsPushbutton             *>
           map event clicked upon lspushbutton to method                *>
               z"OnEventOK" upon self                                   *>
      *> Dialog Close icon                                              *>
           map event closed upon self to method                         *> For the close icon on the dialog, we don't need to obtain an object handle to it, as it is part of the dialog.
               z"OnEventCancel" upon self                               *> in this case, we have mapped the dialog close to the same method as the cancel pusbutton.
       exit method.                                                     *> Return control to the class method "RUN"
       end method "LinkScreenEventsToMethods".                          *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "LinkControlsToProgramFields".                        *> Instance method invoked from the class instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       01 lsid pic x(4) comp-5.                                         *> Unique identifier for this dialog box
       procedure division.                                              *>
       move radio-hourly to lsId                                        *> Obtain symbol number for the first radio button in the group of radio buttons
       invoke self "getObjectFromId" using lsId                         *> Obtain an object handle for the group of radio buttons, using the symbol number for the first radio button as reference to the group
           returning RadioButtonGroup                                   *>
       exit method.                                                     *> Return control to the class method "RUN"
       end method "LinkControlsToProgramFields".                        *> End of Method
      *>--------------------------------------------------------------  *>

       method-id. "InitializeControls".                                 *> Instance method invoked from the class instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       procedure division.                                              *>
       invoke RadioButtonGroup "select"                                 *> Make the first radio button in the group the default selection
       exit method.                                                     *> Return control to the class method "RUN"
       end method "InitializeControls".                                 *> End of Method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "OnEventOK".                                          *> Instance method invoked when the OK Pushbutton is clicked on our dialog.
       local-storage section.                                           *> Contains data private to this method
       01 lsMsgBox                 object reference.                    *> Object handle to the message box within which a message will be displayed identifying the radio button clicked
       01 RadioDefaultFlag         pic x comp-5.                        *> Two's complement item used to identify if the default radio button has been selected by the user
       01 RadioSelectedObject      object reference.                    *> Object handle to the radio button which was selected/clicked
       01 RadioNameObject          object reference.                    *> Object handle to the label of the radio button selected
                                                                        *>
       procedure division.                                              *>
       invoke RadioButtonGroup "isselected" returning RadioDefaultFlag  *> Identify whether the selected radio button is the default button - i.e. the first button in the group. If it is not selected Null will be returned
       if RadioDefaultFlag not = zero                                   *> If the radio button selected is still the default .....
           invoke RadioButtonGroup "getlabel" returning RadioNameObject *> Obtain the object handle to the value of the default radio button
       else                                                             *> If a radio button other than the defaul has been selected .......
           invoke RadioButtonGroup "getnextselected" returning          *> Obtain the object handle to the radio button selected using the name of the radio button group. Note that using "getnextselected" avoids the need to execute an "isselected" on
               RadioSelectedObject                                      *> each item within the group.
           invoke RadioSelectedObject "getlabel"                        *> Obtain the object handle to the value of the radio button clicked
               returning RadioNameobject                                *>
       end-if                                                           *> Delimits the if statement
       invoke MessageBox "new" using self returning lsMsgBox            *> Create an instance of the message box class (from the GUI class library) returning an object handle to it
                                                                        *> Note - the message box to be diaplayed will have default properties - I.E. and OK button.
       invoke lsMsgBox "SetTitlez" using                                *> Set the title of the message box to the contents of a null terminated string
           z"User Selection From The Group Box"                         *>
       invoke lsMsgBox "setMessage" using RadioNameObject               *> Set the message to be displayed within the message box to be the object reference to the label of the radio button selected
       invoke lsMsgBox "show"                                           *> Display the message box, passing control to the event manager, which will await the user pressing the OK button before control will return to the next statement in this method
       invoke lsMsgBox "finalize" returning lsMsgBox                    *> Remove all object references used by the message box
       exit method.                                                     *> Return control to the eventmanger, which will continue to poll for events on our dialog
       end method "OnEventOK".                                          *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "OnEventCancel".                                      *> Instance of method invoked when the Cancel Pushbutton or the dialog close icon is clicked on our dialog
       procedure division.                                              *>
       invoke self "hide"                                               *> Make our dialog invisible to the user on screen
       invoke self "finalize" returning self                            *> Destroy our dialog and the objects that it contained
       exit method.                                                     *> Return control to the calling class
       end method "OnEventCancel".                                      *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       end object.                                                      *> End of instance and data methods
       end class GroupBoxDemo.                                          *> End of this class

