       copy "guibase.if".                                               *> Standard interface to GUIBase class using vocabulary generator - You can just invoke GUIBase methods directly if you wish.
      *>--------------------------------------------------------------  *>
      *> Combo Box Demonstration Class :                                *>
      *>                                                                *>
      *> This is a modal Dialog Box. The dialog box has been created    *>
      *> using the Dialog Editor. This class demonstrates how to use 3  *>
      *> types of Selection boxes within your program - In              *>
      *> Particular :                                                   *>
      *>                                                                *>
      *>   - How to display selection (combo) boxes -                   *>
      *>           Simple, Dropdown(drop) and Droplist                  *>
      *>   - How to insert items in combobox controls prior to display  *>
      *>   - How to obtain user selections on each combo box            *>
      *>   - How to display strings of text within a message Box.       *>
      *>                                                                *>
      *> Screen Controls Used :                                         *>
      *>                                                                *>
      *> Pushbuttons        - To perform Actions                        *>
      *> Simple Combo Box   - To populate an entry field with a value,  *>
      *>                   or select an item from a list                *>
      *> Drop Combo Box     - To populate an entry field with a value   *>
      *>                   or select an item from a list which is only  *>
      *>                   displayed if the user selects it.            *>
      *> DropList Combo Box - To populate an entry field with a         *>
      *>                   selection from a list.                       *>
      *> MessageBox         - To display the selected values from the   *>
      *>                      combo boxes.                              *>
      *> The code in this class has been heavily commented, and further *>
      *> explanations are given as in-line comments in columns 73       *>
      *> Onwards.                                                       *>
      *>                                                                *>
      *> (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
      *> Rights Reserved. 
      *>--------------------------------------------------------------  *>
                                                                        *>
      *>------------------<CLASSS PROGRAM DEFINITION>-----------------  *>
       class-id. ComboBoxDemo                                           *> Declare the name of this class.
                 data is private                                        *> Declares that children of this class do not have access to it's data
                 inherits from modal.                                   *> Forces this class to inherit the behaviour of the modal class from the class library. This implies that the dialog boxes created will be modal, I.E. you cannot move to other areas
                                                                        *> of the application whilst a dialog box created by this class is active
                                                                        *>
       Object Section.                                                  *> Class Objects
                                                                        *>
       class-control.                                                   *> Declare the classes that this class uses directly
           CharacterArray is class "chararry"                           *> From the class library - Used for translating strings to objects
           OrderedCollection is class "ordrdcll"                        *> From the class library - Used to create collections of objects - similar to an array where data is stored in the order in which it was added to the array.
           SortedCollection is class "srtdclln"                         *> From the class library - Used to create collection of objects which may be sorted - usually alphabetically
           Module is class "module"                                     *> From the class library - Used to wrap classes that may contain resources - I.E. GUI objects in a DLL file
           MessageBox is class "msgbox"                                 *> From the class library - we use this class for creating and handling message boxes
           ComboBoxDemo is class "combobox"                             *> Our own class
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
       local-storage section.                                           *>
       01 lsid                     pic x(4) comp-5.                     *> Unique identifier for this dialog box
       01 lsDialog                 object reference.                    *> Used as an object handle to the dialog which this class creates
                                                                        *>
       linkage section.                                                 *> Data passed from the invoking class
       01 lnkParent                object reference.                    *> The resource .dll file containing the dialog box GUI object
       01 lnkResource              object Reference.                    *> The parent of this dialog box, in this case another dialog box
       procedure division using lnkParent lnkResource.                  *> The executable code of the Run method
           move combo-box-screen to lsId                                *> Unique identifier for this dialog box using the symbol number for the dialog within the resource copy file
           invoke self "fromResource" using lnkParent lnkResource       *> Locates the required Groupbox dialog box within the resource file, and creates it as an object (lsdialog) that we can then use
                                           lsid returning lsDialog      *>
           invoke lsdialog "create"                                     *> Initialize above created (lsdialog) instance object, which sets up the initial state of the dialog and events
           invoke lsdialog "show"                                       *> Make the dialog visible, giving control to the eventmanager, and await user input.
       exit method.                                                     *>
       end method "ShowDemo".                                           *> End of "ShowDemo" Method
       end class-object.                                                *> End of class data and methods
                                                                        *>
      *>------------------<INSTANCE DEFINITION>-----------------------  *>
       object.                                                          *> Instance Data and Methods start here
                                                                        *>
      *>------------------<INSTANCE DATA>-----------------------------  *>
       object-storage section.                                          *> Data declared here is visible throughout the scope of this class
       01 SimpleComboItem          object reference.                    *> Used as an object handle to the Simple combo box item which will be created as a control within lsdialog by this class
       01 DropComboItem            object reference.                    *> Used as an object handle to the Drop combo box item which will be created as a control within lsdialog by this class
       01 DropListComboItem        object reference.                    *> Used as an object handle to the Droplist combo box item which will be created as a control within lsdialog by this class
      *>------------------<INSTANCE METHODS>--------------------------  *>
      *>--------------------------------------------------------------  *>
       method-id. "Create".                                             *> instance Method invoked by the class method "RUN"
       procedure division.                                              *>
       invoke super "create"                                            *> invoke the inherited method to invoke and initialize the class
       invoke self "LinkScreenEventsToMethods"                          *> Invoke method to map events to methods within this class
       invoke self "LinkControlsToProgramFields"                        *> Invoke method to obtain object handles to the controls on the dialog for this class
       invoke self "InitializeControls"                                 *> Invoke method to intialize the screen controls, in particular, to populate the combo boxes with values
       exit method.                                                     *> Return control to the class method "RUN"
       end method "Create".                                             *> End of "CREATE" method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "LinkScreenEventsToMethods".                          *> Instance method invoked from the create instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       01 lsId                         pic x(4) comp-5.                 *> Unique identifier for this dialog box
       01 lsPushbutton                 object reference.                *> Object reference item used for storing object handles to push button controls on our dialog
                                                                        *>
       procedure division.                                              *>
      *> Cancel Button.                                                 *>
           move idCancel to lsId                                        *> Pick up the symbol number for the cancel control for our dialog
           invoke self "GetObjectFromId" using lsId                     *> Obtain an object reference to the cancel control for our dialog, using the cancel control's symbol number
                                     returning lsPushbutton             *>
           map event clicked upon lspushbutton to method                *> Use the GUIBase Map method to link the event "clicked" upon our cancel pushbutton control to
               z"OnEventCancel" upon self                               *> the method "Oncancel" within this class
      *> OK Button                                                      *>
           move IDOK to lsId                                            *> Similar processing as for Cancel button
           invoke self "GetObjectFromId" using lsId                     *>
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
       01 lsId pic x(4) comp-5.                                         *> Unique identifier for this dialog box
       procedure division.                                              *>
           move simple-combo-box to lsid                                *> Obtain symbol number for the simple combo box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the simple combo box
                                     returning SimpleComboItem          *>
           move drop-combo-box to lsid                                  *> Obtain symbol number for the drop combo box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the drop combo box
                                     returning DropComboItem            *>
           move droplist-combo-box to lsid                              *> Obtain symbol number for the droplist box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the droplist combo box
                                     returning DropListComboItem        *>
       exit method.                                                     *> Return control to the class method "RUN"
       end method "LinkControlsToProgramFields".                        *> End of Method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "InitializeControls".                                 *> Instance method invoked from the class instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       01 aCollection  object reference.                                *> Object handle to the collection used to populate each combo selection box
       procedure division.                                              *>
           invoke self "PreDisplayList" returning aCollection           *> Invoke the Predisplaylist method within this class to populate the simple combo box
           invoke SimpleComboItem "setcontents" using aCollection       *> Sets the contents of the combo box to those of the sorted collection
           invoke DropComboItem "setcontents" using aCollection         *> Sets the contents of the combo box to those of the sorted collection
           invoke DropListComboItem "setcontents" using aCollection     *> Sets the contents of the combo box to those of the sorted collection
           invoke aCollection "deepfinalize" returning aCollection      *> Destroys the collection and all objects which it contains
       exit method.                                                     *> Return control to the class method "RUN"
       end method "InitializeControls".                                 *> End of Method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "OnEventOK".                                          *> Instance method invoked when the OK pushbutton is pressed
       working-storage section.                                         *> Contains data required for this method
       01 message-string.                                               *> Data item used for the string passed to the message box containing the item within each combo box which the user selected
           03 simplecombo-text     pic x(19)                            *> String of text for titling the simple combo box value
                                   value "Simple box Value : ".         *>
           03 simplecombovalue     pic x(10).                           *> Stores the user selected value for the simple combo box
           03 simple-terminate     pic xx value is x"0D0A".             *> Carriage return line feed required to force line seperation in the displayed message box
           03 dropcombo-text       pic x(17)                            *> String of text for titling the drop combo box value
                                   value "Drop box Value : ".           *>
           03 dropcombovalue       pic x(10).                           *> Stores the user selected value for the drop combo box
           03 dropcombo-terminate  pic xx value is x"0D0A".             *> Carriage return line feed required to force line seperation in the displayed message box
           03 droplist-text        pic x(21)                            *> String of text for titling the droplist combo box value
                                   value "DropList box Value : ".       *>
           03 droplistcombovalue   pic x(10).                           *> Stores the user selected value for the droplist combo box
           03 droplist-terminate   pic x value is x"00".                *> Null termination of message-string to enable the string to be passed to the null terminated setmessage method of the message box class
       local-storage section.                                           *> Contains data private to this method
       01 lsMsgBox                 object reference.                    *> The object handle to the message box
       01 StringLength             pic x(4) comp-5.                     *> Contains the length of string to be returned when using the getvaluewithsize method to accept the user selected input from each combo box
       01 SimpleComboRef           object reference.                    *> Object handle to the user selected input on the simple combo box
       01 DropComboRef             object reference.                    *> Object handle to the user selected input on the drop combo box
       01 DropListComboRef          object reference.                   *> Object handle to the user selected input on the droplist combo box
                                                                        *>
       procedure division.                                              *>
       invoke SimpleComboItem "gettext" returning SimpleComboRef        *> Obtain an object handle to the user selected input within the simple combo box control
       move length of SimpleComboValue to StringLength                  *> Move the maximum length of item that the combo box could contain, to stringlength
       invoke SimpleComboRef "GetValueWithSize" using StringLength      *> Extract the value (of length stringlength) of the users input within the simple combobox Using the object handle for the user selected input, placing it into the item
           returning SimpleComboValue                                   *> simplecombovalue
       invoke DropComboItem "GetText" returning DropComboRef            *> Obtain an object handle to the user selected input within the simple combo box control
       move length of DropComboValue to StringLength                    *> Move the maximum length of item that the combo box could contain, to stringlength
       invoke DropComboRef "GetValueWithSize" using StringLength        *> Extract the value (of length stringlength) of the users input within the simple combobox Using the object handle for the user selected input, placing it into the item
           returning DropComboValue                                     *> dropcombovalue
       invoke DropListComboItem "GetText" returning DropListComboRef    *> Obtain an object handle to the user selected input within the simple combo box control
       move length of DropListComboValue to StringLength                *> Move the maximum length of item that the combo box could contain, to stringlength
       invoke DropListComboRef "GetValueWithSize" using StringLength    *> Extract the value (of length stringlength) of the users input within the simple combobox Using the object handle for the user selected input, placing it into the item
           returning DropListComboValue                                 *> droplistcombovalue
       invoke MessageBox "new" using self returning lsMsgBox            *> Create an instance of the messagebox class (from the GUI class library) returning an object handle to it
                                                                        *> Note - the message box to be displayed will have default properties - I.E. and OK button.
       invoke lsMsgBox "SetTitlez" using                                *> Set the title of the message box to the contents of a null terminated string
           z"User Selections From Combination Selection Boxes"          *>
       invoke lsMsgBox "setMessagez" using Message-String               *> Set the message to be displayed within the message box to be the null terminated string message-string (note method used is setmessageZ)
       invoke lsMsgBox "show"                                           *> Display the message box, passing control to the event manager, which will await the user pressing the OK button before control will return to the next statement in this method
       invoke lsMsgBox "finalize" returning lsMsgBox                    *> Remove all object references used by the message box
       exit method.                                                     *> Return control to the eventmanger, which will continue to poll for events on our dialog
       end method "OnEventOK".                                          *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "OnEventCancel".                                      *> Instance of method invoked when the Cancel Pushbutton or the dialog close icon is clicked on our dialog
       local-storage section.                                           *>
       procedure division.                                              *>
       invoke self "hide"                                               *> Make our dialog invisible to the user on screen
       invoke self "finalize" returning self                            *> Destroy our dialog and the objects that it contained
       exit method.                                                     *> Return control to the calling class
       end method "OnEventCancel".                                      *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "PreDisplayList".                                     *> Instance method invoke by the initialise controls method
       working-storage section.                                         *> Contains data required for this method
       78 ComboArraySize               value is 4.                      *> Item containing the number of items within the table
       78 ComboItemSize                value is 7.                      *> Item containing the maximum length of the items within the table
       01 ComboItems.                                                   *> Contains data items for populating an occurs item.
           05 filler                   pic X(7) value "Clinton".        *>
           05 filler                   pic X(7) value "Nixon".          *>
           05 filler                   pic X(7) value "Reagan".         *>
           05 filler                   pic X(7) value "Bush".           *>
       01 ComboItemsArray redefines ComboItems pic                      *> Table which is populated by a redefinition of a group item
           x(ComboItemSize) occurs ComboArraySize.                      *>
       local-storage section.                                           *> Contains data private to this method
       01 ArraySize                    pic x(4) comp-5.                 *> Used to store two's complement version of issue-status-array-size
       01 ItemSize                     pic x(4) comp-5.                 *> Used to store two's complement version of issue-status-item-size
       01 LoopCount                    pic x(4) comp-5.                 *> Counter used to loop around the inline perform until all items from the table have been added to the collection
       01 aString                      object reference.                *> Object handle to individual items being added to the collection
       linkage section.                                                 *> Data passed from calling method
       01 aCollection                  object reference.                *> Object handle to the collection of items used to populate the combo boxes
       procedure division returning aCollection.                        *>
           move ComboArraySize to ArraySize                             *> Moves the number of items in the table to a two's complement item
           move ComboItemSize to ItemSize                               *> Moves the maximum size of items in the table to a two's complement item
           invoke SortedCollection "ofReferences" using ArraySize       *> Creates a sortedcollection which can contain "array-size" number of object references to items, returning a handle to the collection
               returning aCollection                                    *>
           perform varying LoopCount from 1 by 1 until LoopCount >      *> Initiates a loop for including a reference to each item within the table into the collection.
               ArraySize                                                *>
                   invoke CharacterArray "withlengthvalue"              *> Produces a character array containing an item from within the table, returning an object handle to the characterarray
                       using ItemSize ComboItemsArray(LoopCount)        *>
                       returning aString                                *>
               invoke aCollection "add" using aString                   *> Adds a reference to the contents of the character array "astring" to the sorted collection
           end-perform                                                  *> Delimits the perform - The perform will repeat four times
       exit method.                                                     *> Return control to the calling method
       end method "PreDisplayList".                                     *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       end object.                                                      *> End of instance and data methods
       end class ComboBoxDemo.                                          *> End of this class
