       copy "guibase.if".                                               *> Standard interface to GUIBase class using vocabulary generator - You can just invoke GUIBase methods directly if you wish.
      *>--------------------------------------------------------------  *>
      *> List Box Demonstration Class :                                 *>
      *>                                                                *>
      *> This is a modal Dialog Box. The dialog box has been created    *>
      *> using the Dialog Editor. This class demonstrates how to use 3  *>
      *> types of List boxes within your program - In                   *>
      *> Particular :                                                   *>
      *>                                                                *>
      *>   - How to display List Boxes (Single, multiple and Extended)  *>
      *>   - How to insert items into listbox controls prior to display *>
      *>   - How to obtain user selections on each list box             *>
      *>   - How to display strings of text within a message Box.       *>
      *>                                                                *>
      *> Screen Controls Used :                                         *>
      *>                                                                *>
      *> Pushbuttons        - To perform Actions                        *>
      *> Single List Box    - To select a single items from a list      *>
      *> Multiple List Box  - To select a number of items from a list   *>
      *> Extended List Box  - To extend a selection within a list box   *>
      *>                      by dragging the mouse.                    *>
      *> MessageBox         - To display the selected values from the   *>
      *>                      combo boxes.                              *>
      *> The code in this class has been heavily commented, and further *>
      *> explanations are given as in-line comments in columns 73       *>
      *> Onwards.                                                       *>
      *>                                                                *>
      *> Copyright (C) 1996-2000  Micro Focus International Ltd.
      *>--------------------------------------------------------------  *>
                                                                        *>
      *>------------------<CLASSS PROGRAM DEFINITION>-----------------  *>
       class-id. ListBoxDemo                                            *> Declare the name of this class.
                 data is private                                        *> Declares that children of this class do not have access to it's data
                 inherits from modal.                                   *> Forces this class to inherit the behaviour of the modal class from the class library. This implies that the dialog boxes created will be modal, I.E. you cannot move to other areas
                                                                        *> of the application whilst a dialog box created by this class is active
                                                                        *>
       Object Section.                                                  *> Class Objects
                                                                        *>
       class-control.                                                   *> Declare the classes that this class uses directly
           CharacterArray is class "chararry"                           *> From the class library - Used for translating strings to objects
           OrderedCollection is class "ordrdcll"                        *> From the class library - Used to create collections of objects - similar to an array where data is stored in the order in which it was added to the array.
           Sortedcollection is class "srtdclln"                         *> From the class library - Used to create collection of objects which may be sorted - usually alphabetically
           Module is class "module"                                     *> From the class library - Used to wrap classes that may contain resources - I.E. GUI objects in a DLL file
           MessageBox is class "msgbox"                                 *> From the class library - we use this class for creating and handling message boxes
           ListBoxDemo is class "LstBox"                                *> Our own class
           Modal is class "modal"                                       *> From the class library - we use this class to create and control a modal dialog box
           .                                                            *>
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
       01 lsId pic x(4) comp-5.                                         *> Unique identifier for this dialog box
       01 lsDialog                 object reference.                    *> Used by this class as an object handle to the dialog which this class creates
                                                                        *>
       linkage section.                                                 *> Data passed from the invoking class
       01 lnkParent                object reference.                    *> The resource .dll file containing the dialog box GUI object
       01 lnkResource              object Reference.                    *> The parent of this dialog box, in this case another dialog box
       procedure division using lnkParent lnkResource.                  *> The executable code of the Run method
           move list-box-screen to lsId                                 *> Unique identifier for this dialog box using the symbol number for the dialog within the resource copy file
           invoke self "fromResource" using lnkparent lnkresource       *> Locates the required Groupbox dialog box within the resource file, and creates it as an object (lsdialog) that we can then use
                                           lsId returning lsDialog      *>
           invoke lsdialog "create"                                     *> Initialize above created (lsdialog) instance object, which sets up the initial state of the dialog and events
           invoke lsdialog "show"                                       *> Make the dialog visible, giving control to the eventmanager, and await user input.
       exit method.                                                     *> Return control to the invoking method of the invoking program
       end method "ShowDemo".                                           *> End of "ShowDemo" Method
       end class-object.                                                *> End of class data and methods
                                                                        *>
      *>------------------<INSTANCE DEFINITION>-----------------------  *>
       object.                                                          *> Instance data and methods start here
                                                                        *>
      *>------------------<INSTANCE DATA>-----------------------------  *>
       object-storage section.                                          *> Data declared here is visible throughout the class
       01 SingleItem               object reference.                    *> Used by this class as an object handle to the Single item list box item which will be created as a control within lsdialog by this class
       01 MultipleItem             object reference.                    *> Used by this class as an object handle to the multiple item list box item which will be created as a control within lsdialog by this class
       01 ExtendedItem             object reference.                    *> Used by this class as an object handle to the extended item list box item which will be created as a control within lsdialog by this class
      *>------------------<INSTANCE METHODS>--------------------------  *>
      *>--------------------------------------------------------------  *>
       method-id. "Create".                                             *> instance Method invoked by the class method "RUN"
       procedure division.                                              *>
       invoke super "Create"                                            *> invoke the inherited method to invoke and initialize the class
       invoke self "LinkScreenEventsToMethods"                          *> Invoke method to map events to methods within this class
       invoke self "LinkControlsToProgramFields"                        *> Invoke method to obtain object handles to the controls on the dialog for this class
       invoke self "InitializeControls"                                 *> Invoke method to intialize the screen controls, in particular, to populate the combo boxes with values
       exit method.                                                     *> Return control to the class method "RUN"
       end method "Create".                                             *> End of "CREATE" method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "LinkScreenEventsToMethods".                          *> Instance method invoked from the create instance method "RUN"
       local-storage section.                                           *> contains data private to this method
       01 lsId                         pic x(4) comp-5.                 *> Unique identifier for this dialog box
       01 lsPushbutton                 object reference.                *> Object reference item used for storing object handles to push button controls on our dialog
                                                                        *>
       procedure division.                                              *>
      *> Cancel Button.                                                 *>
           move idCancel to lsId                                        *> Pick up the symbol number for the cancel control for our dialog
           invoke self "getObjectFromId" using lsId                     *> Obtain an object reference to the cancel control for our dialog, using the cancel control's symbol number
                                     returning lsPushbutton             *>
           map event clicked upon lspushbutton to method                *> Use the GUIBase Map method to link the event "clicked" upon our cancel pushbutton control to
               z"OnEventCancel" upon self                               *> the method "Oncancel" within this class
      *> OK Button                                                      *>
           move IDOK to lsId                                            *> Similar processing as for Cancel button
           invoke self "getObjectFromId" using lsId                     *>
                                     returning lsPushbutton             *>
           map event clicked upon lspushbutton to method                *>
               z"OnEventOK" upon self                                   *>
      *> Dialog Close icon                                              *>
           map event closed upon self to method                         *> For the close icon on the dialog, we don't need to obtain an object handle to it, as it is part of the dialog.
               z"OnEventcancel" upon self                               *> in this case, we have mapped the dialog close to the same method as the cancel pusbutton.
       exit method.                                                     *> Return control to the class method "RUN"
       end method "LinkScreenEventsToMethods".                          *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "LinkControlsToProgramFields".                        *> Instance method invoked from the class instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       01 lsId pic x(4) comp-5.                                         *> Unique identifier for this dialog box
       procedure division.                                              *>
           move single-list-box to lsId                                 *> Obtain symbol number for the simple combo box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the single list box
                                     returning SingleItem               *>
           move multiple-list-box to lsId                               *> Obtain symbol number for the drop combo box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the multiple list box
                                     returning MultipleItem             *>
           move extended-list-box to lsId                               *> Obtain symbol number for the droplist box
           invoke self "getobjectfromid" using lsId                     *> Obtain an object handle for the extended list box
                                     returning ExtendedItem             *>
       exit method.                                                     *> Return control to the class method "RUN"
       end method "LinkControlsToProgramFields".                        *> End of Method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "InitializeControls".                                 *> Instance method invoked from the class instance method "RUN"
       local-storage section.                                           *> Contains data private to this method
       01 aCollection object reference.                                 *> Object handle to the collection used to populate the list boxes
       procedure division.                                              *>
           invoke self "PreDisplayList" returning aCollection           *> Invoke the Predisplaylist method within this class to populate the simple combo box
           invoke SingleItem "setcontents" using aCollection            *> Sets the contents of the combo box to those of the sorted collection
           invoke MultipleItem "setcontents" using aCollection          *> Sets the contents of the combo box to those of the sorted collection
           invoke ExtendedItem "setcontents" using aCollection          *> Sets the contents of the combo box to those of the sorted collection
           invoke aCollection "deepfinalize" returning aCollection      *> Destroys the collection and all objects which it contains
       exit method.                                                     *> Return control to the class method "RUN"
       end method "InitializeControls".                                 *> End of Method
      *>--------------------------------------------------------------  *>
                                                                        *>
       method-id. "OnEventOK".                                          *> Instance method invoked when the OK pushbutton is pressed
       working-storage section.                                         *> Contains data required for this method
       01 SingleListMessage.                                            *> Data item used for displaying the contents of the single list box within a messagebox
           03 SingleMessage    pic x(21) value "Single box Value : ".   *> String of text for titling the single list box value
           03 SingleListValue      pic x(10).                           *> Stores the user selected value for the single list box
           03 filler               pic x value is x"00".                *> Null terminator for the message
       01 MultipleListMessage.                                          *> Data item used for displaying the contents of the Multiple list box within a messagebox
           03 MultipleMessage  pic x(21) value "Multiple box Value : ". *> String of text for titling the multiple list box value
           03 MultipleListValue    pic x(40).                           *> Stores the user selected value for the multiple list box
           03 filler               pic x value is x"00".                *> Null terminator for the message
       01 ExtendedListMessage.                                          *> Data item used for displaying the contents of the Extended list box within a messagebox
           03 ExtendedMessage  pic x(21) value "Extended box Value : ". *> String of text for titling the extended list value
           03 ExtendedListValue    pic x(40).                           *> Stores the user selected value for the extended list box
           03 filler               pic x value is x"00".                *> Null terminator for the message
       01 LineFeed                 pic xxx value x"0D0A00".             *> Carriage Return, Line Feed and Null terminators used to seperate items within the collection to be passed to the message box
       01 ArraySize                pic x(4) comp-5 value 4.             *> Contains the maximum number of items to be placed in the message display collection
       local-storage section.                                           *> Contains data private to this method
       01 lsMsgBox                 object reference.                    *> Contains the length of string to be returned when using the getvaluewithsize method to accept the user selected input from each combo box
       01 StringCollection         object reference.                    *> Object handle to the collection of user input from either the Multiple or Extended List boxes
       01 SeperateCharObject       object reference.                    *> Object handle to the character used to seperate the contents of a collection
       01 SelectedStringObject     object reference.                    *> Object handle to the String of items contained within the collection seperated by SeperateCharObject
       01 StringLength             pic x(4) comp-5.                     *> Contains the length of string to be returned when using the getvaluewithsize method to accept the user selected input from each combo box
       01 ItemNumber               pic s9(9) comp-5.                    *> Contains the number of the user selected item from the single list box
       01 SingleListRef            object reference.                    *> Object handle to the user selected input on the Single selection list box
       01 DisplayCollection        object reference.                    *> Object handle to the message display collection
       01 aString                  object reference.                    *> Object handle used to add items to the display collection
       01 DisplayStringObject      object reference.                    *> Object handle to the String of items contained within the display collection seperated by SeperateCharObject
       procedure division.                                              *>
       invoke SingleItem "SelectedItem" returning ItemNumber            *> Obtain an the number of the user selected item from within the single list box, will return null if no item has been selected
       if ItemNumber not = zero                                         *> Test to ensure that an item from the single list box has been selected, otherwise the getitem text method will give an error
           invoke SingleItem "GetItemText" using ItemNumber             *> Obtain an object handle to the item number selected by the user from the listbox
               returning SingleListRef                                  *>
           move length of SingleListValue to StringLength               *> Move the size of the data item singlelistvalue to stringlength, stringlength will then be used to delimit the length of text retrieved from the user input
           invoke SingleListRef "GetValueWithSize" using StringLength   *> Using the object handle to the user selected item, obtain the actual text that the user selected, delimited by size stringlength returning the value within an alphanumeric item
               returning SingleListValue                                *>
       end-if                                                           *> Delimits the if statement
       invoke MultipleItem "SelectedStrings" returning                  *> Initialize an ordered collection containing the user selected items from the multiple selection listbox, returning an object handle to the collection
           StringCollection                                             *>
       invoke CharacterArray "WithValue" using z", " returning          *> Initialize a character array to contain a comma, returning an object handle to the array. This will be used as a separation character for a later method
           SeperateCharObject                                           *>
       invoke stringcollection "AsSeparatedString" using                *> Modify the ordered collection to separate each item within the collection with the separation character, in this case a comma, returning a fresh object handle
           SeperateCharObject returning SelectedStringObject            *>
       move length of MultipleListValue to StringLength                 *> Move the size of the data item multiplelistvalue to stringlength, stringlength will then be used to delimit the length of text retrieved from the user input
       invoke SelectedStringObject "GetValueWithSize" using StringLength*> Extract the comma separated contents of the ordered collection into the pic X item multiplelistvalue, delimited by the size of the data item.
           returning MultipleListValue                                  *>
       invoke ExtendedItem "SelectedStrings" returning                  *> Initialize an ordered collection containing the user selected items from the multiple selection listbox, returning an object handle to the collection
           StringCollection                                             *>
       invoke CharacterArray "WithValue" using z", " returning          *> Initialize a character array to contain a comma, returning an object handle to the array. This will be used as a separation character for a later method
           SeperateCharObject                                           *>
       invoke StringCollection "AsSeparatedString" using                *> Modify the ordered collection to separate each item within the collection with the separation character, in this case a comma, returning a fresh object handle
           SeperateCharObject returning SelectedStringObject            *>
       move length of ExtendedListValue to StringLength                 *> Move the size of the data item multiplelistvalue to stringlength, stringlength will then be used to delimit the length of text retrieved from the user input
       invoke SelectedStringObject "GetValueWithSize" using StringLength*> Extract the comma separated contents of the ordered collection into the pic X item multiplelistvalue, delimited by the size of the data item.
           returning ExtendedListValue                                  *>
       invoke OrderedCollection "ofReferences" using ArraySize          *> Initialize an ordered collection, displaycollection which will be used later to contain the three items to be displayed within the message box
           returning DisplayCollection
       invoke CharacterArray "WithValue" using SingleListMessage        *> Initialize a character array, containing the contents of SingleListMessage, returning an object handle
           returning Astring
       invoke DisplayCollection "add" using Astring                     *> Add the contents of character array "aString" to the display collection
       invoke CharacterArray "withvalue" using MultipleListMessage      *> Initialize a character array, containing the contents of MultipleListMessage, returning an object handle
           returning Astring
       invoke DisplayCollection "add" using Astring                     *> Add the contents of character array "aString" to the display collection
       invoke CharacterArray "withvalue" using ExtendedListMessage      *> Initialize a character array, containing the contents of ExtendedListMessage, returning an object handle
           returning Astring
       invoke DisplayCollection "add" using Astring                     *> Add the contents of character array "aString" to the display collection
       invoke CharacterArray "WithValue" using LineFeed returning       *> Initialize a character array, containing the contents of LineFeed, returning an object handle
           SeperateCharObject
       invoke DisplayCollection "AsSeparatedString" using               *> Modify the ordered collection to separate each item within the collection with the separation character, in this case a CRLF and Null terminators, returning a fresh object handle
           SeperateCharObject returning DisplayStringObject
       invoke MessageBox "new" using self returning lsMsgBox            *> Create an instance of the messagebox class (from the GUI class library) returning an object handle to it
                                                                        *> Note - the message box to be diaplayed will have default properties - I.E. and OK button.
       invoke lsMsgBox "settitlez" using                                *> Set the title of the message box to the contents of a null terminated string
           z"User Selections From List Boxes"                           *>
       invoke lsMsgBox "setMessage" using DisplayStringObject           *> Set the message to be displayed within the message box to be the string identified by the display string object
       invoke lsMsgBox "show"                                           *> Display the message box, passing control to the event manager, which will await the user pressing the OK button before control will return to the next statement in this method
       invoke lsMsgBox "finalize" returning lsMsgBox                    *> Remove all object references used by the message box
       invoke DisplayStringObject "deepfinalize" returning              *> Destroys the collection and all objects which it contains
           DisplayStringObject
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
       method-id. "predisplaylist".                                     *> Instance method invoke by the initialise controls method
       working-storage section.                                         *> Contains data required for this method
       78 ListItemSize                  value is 8.                     *> Item containing the maximum length of the items within the table
       78 ListArraySize                value is 4.                      *> Item containing the number of items within the table
       01 ListItems.                                                    *> Contains data items for populating an occurs item.
           05 filler                   pic X(8) value z"Clinton".       *>
           05 filler                   pic X(8) value z"Nixon".         *>
           05 filler                   pic X(8) value z"Reagan".        *>
           05 filler                   pic X(8) value z"Bush".          *>
       01 ListItemsArray redefines ListItems pic                        *> Table which is populated by a redefinition of a group item
           x(ListItemSize) occurs ListArraySize.                        *>
       local-storage section.                                           *> Contains data private to this method
       01 ArraySize                    pic x(4) comp-5.                 *> Used to store two's complement version of issue-status-array-size
       01 ItemSize                     pic x(4) comp-5.                 *> Used to store two's complement version of issue-status-item-size
       01 LoopCount                    pic x(4) comp-5.                 *> Counter used to loop around the inline perform until all items from the table have been added to the collection
       01 aString                      object reference.                *> Object handle to individual items being added to the collection
       linkage section.                                                 *> Data passed from calling method
       01 aCollection                  object reference.                *> Object handle to the collection of items used to populate the combo boxes
       procedure division returning aCollection.                        *>
           move ListArraySize to ArraySize                              *> Moves the number of items in the table to a two's complement item
           move ListItemSize to ItemSize                                *> Moves the maximum size of items in the table to a two's complement item
           invoke SortedCollection "ofReferences" using ArraySize       *> Creates a sortedcollection which can contain "array-size" number of object references to items, returning a handle to the collection
               returning aCollection                                    *>
           perform varying LoopCount from 1 by 1 until LoopCount >      *> Initiates a loop for including a reference to each item within the table into the collection.
               ArraySize                                                *>
                   invoke CharacterArray "WithValue"                    *> Produces a character array containing an item from within the table, returning an object handle to the characterarray
                       using ListItemsArray(LoopCount)                  *>
                                       returning aString                *>
               invoke aCollection "add" using aString                   *> Adds a reference to the contents of the character array "astring" to the sorted collection
           end-perform                                                  *> Delimits the perform - The perform will repeat four times
       exit method.                                                     *> Return control to the calling method
       end method "PreDisplayList".                                     *> End of method
      *>--------------------------------------------------------------  *>
                                                                        *>
       end object.                                                      *> End of instance and data methods
       end class ListBoxDemo.                                           *> End of this class
