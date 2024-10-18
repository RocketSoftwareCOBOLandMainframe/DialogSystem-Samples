*>------------------------------------------------------------
*> This program demonstrates how to:
*>
*> use a treeview, splitter window and multiple line edit field;
*> use a dictionary to store key/data pairs of values;
*> create GUI objects which are not stored in a resource file;
*> change the size and position of GUI objects;
*> use private methods in the class library.
*>
*> The code is commented from column 74.
*>
*> The program creates a vertically split window containing a tree view and a
*> multiple line entry field or memo field.  On the tree view are a number of
*> Items each with a number of SubItems.  For each SubItem there is a block
*> of text which is displayed in the memo field when the SubItem is selected.
*>
*> (C) 1996-2024 Rocket Software, Inc. or its affiliates. All    
*> Rights Reserved. 
*>-----------------------------------------------------------

       copy 'guibase.if'.                                                *> Method prototypes.  Alternatives to the 'invoke' syntax for many methods;
                                                                         *> also checks method parameters at compile time.
       Class-id. TreeViewDemo                                            *> The name of this class.
                 data is private                                         *> Children of this class would not have access to its data.
                 inherits from Modal.                                    *> Makes this a modal dialog box ie you must close it before moving
                                                                         *> to another part of the application.
       Object section.                                                   *> Class objects.
       Class-control.                                                    *> List the class this is and the classes it uses.
           TreeViewDemo           is class 'TreView'                     *> This class: its name and that of its executable file.
           Modal                  is class 'modal'                       *> The modal class this class inherits from.
           Module                 is class 'module'                      *> Used to wrap classes that may contain resources ie GUI objects in a .dll file.
           CharacterArray         is class 'chararry'                    *> Creates strings as objects.
           IdentityDictionary     is class 'idictnry'                    *> A type of dictionary which only stores objects.
           Association            is class 'associtn'                    *> Used to tell the dictionary it will be holding key/data pairs.
           TreeViewControl        is class 'treeview'                    *> We will use this class to create a tree view object.
           MultipleLineEntryField is class 'mle'                         *> We will use this class to create a multiple line entry field.
           SplitView is class 'vspwndow'                                 *> We will use this class to create a vertical Split View Window.
                                                                         *> NOTE: that we could also use this class to produce a horizontal Split View Window
       .                                                                 *>
       working-storage section.                                          *> Fields declared here will be visible ie in scope throughout this class program.
           copy 'mfres.cpy'.                                             *> Created by the resource compiler, contains unique identifiers for all GUI objects.
           copy 'p2cevent.cpy'.                                          *> Contains physical events eg gained-focus, clicked, resized.  Should be complete.
                                                                         *>
       class-object.                                                     *> Class data and methods start here.
       object-storage section.                                           *> None needed in this program.
                                                                         *>
       method-id. 'showDemo'.                                            *> The calling program invokes this method to create and run the treeview dialog box.
       local-storage section.                                            *> Data private to this method, created when the method is invoked, destroyed when the
                                                                         *> method is exited. Note however that objects must be explicitly destroyed.
       01 lsResourceId                            pic x(4) comp-5.       *> Unique identifier for this dialog box.
       01 lsDialogBox                             object reference.      *> This dialog box.
                                                                         *>
       linkage section.                                                  *> Data passed from the invoking program.
       01 lkResource                              object reference.      *> The resource .dll file containing the dialog box GUI object.
       01 lkParent                                object reference.      *> The parent of this dialog box, in this case another dialog box.
                                                                         *>
       procedure division using lkParent                                 *> The executable code of the 'run' method.
                                lkResource.                              *>
          move DLG-TREEVIEW-DEMO        to lsResourceId                  *> Unique identifier for this dialog box.
          invoke self 'fromResource' using lkParent                      *> Get the dialog box from the resource file, with the currently open dialog box as parent.
                                           lkResource                    *>
                                           lsResourceId                  *>
                                 returning lsDialogBox                   *>
          invoke lsDialogBox 'create'                                    *> Create the dialog box; overrides the inherited 'create' method.
          invoke lsDialogBox 'show'                                      *> Make it visible and give control to the event manager, wait for user input.
          invoke lsDialogBox 'finalize' returning lsDialogBox            *> Destroy this dialog box.
                                                                         *>
          exit method.                                                   *> Return to the invoking method in the invoking program.
       end method 'showDemo'.                                            *> End of this method.
       end class-object.                                                 *> End of class data and methods.
                                                                         *>
       object.                                                           *> Instance data and methods start here.
       object-storage section.                                           *> Data declared here is visible ie in scope throughout the rest of this class.
       01 osPushbutton                            object reference.      *> The push button object.
       01 osSplitView                             object reference.      *> The Split View Window object we will create.
       01 osTreeView                              object reference.      *> The tree view object we will create.
       01 osMemoField                             object reference.      *> The memo field or multiple line edit field object we will create.
       01 osSubItemMemoList                       object reference.      *> Will hold a block of text for each subItem on the tree view.
                                                                         *>
       method-id. 'create'.                                              *> Instance method invoked by the class method 'run'; overrides the inherited 'create' method.
       procedure division.                                               *> The executable code of the create method.
                                                                         *>
           invoke super 'create'                                         *> Invoke the inherited method to make and initialize this class.
           invoke self  'createGUIObjects'                               *> Invoke a method in this class program to initialise the GUI objects.
           invoke self  'mapControlsToMethods'                           *> Map events on controls to methods.
           invoke self  'initializeTreeView'                             *> Put data in the tree view and memo fields.
                                                                         *>
           exit method.                                                  *> Return control to the class method 'run'.
       end method 'create'.                                              *> End of the create method.
                                                                         *>
       method-id. 'onEventOk'.                                           *> When the OK pushbutton is pressed control passes to this method.
       procedure division.                                               *>
                                                                         *>
           invoke self              'hide'                               *> Remove the dialog box from the screen.
           invoke osSubItemMemoList 'reallyDeepFinalize'                 *> Destroy this object and the objects it contains.
                                     returning osSubItemMemoList         *>
                                                                         *>
           invoke osTreeView        'finalize' returning osTreeView      *> Destroy this object.
           invoke osMemoField       'finalize' returning osMemoField     *> Destroy this object.
           invoke osSplitView       'finalize' returning osSplitView     *> Destroy this object.
                                                                         *>
           exit method.                                                  *> Retun to the invoking method in the class object.
       end method 'onEventOk'.                                           *> End of method.
                                                                         *>
       method-id. 'onEventTreeItemSelected'.                             *> When a tree view item is selected control passes to this method.
       working-storage section.                                          *> Data private to this method.
                                                                         *>
       01 aSubItem                                object reference.      *> Will tell us which tree view item or subItem is selected.
       01 aSubItemMemo                            object reference.      *> Text for a subItem.
                                                                         *>
       procedure division.                                               *>
                                                                         *>
           invoke osTreeView        'selectedItem' returning aSubItem    *> Ask the tree view which item is selected.
                                                                         *>
           invoke osSubItemMemoList 'atOrNil'      using aSubItem        *> Ask the memo list if it contains a memo for this item or subItem.
                                               returning aSubItemMemo    *>
           if aSubItemMemo = null                                        *> It doesn't, so it's an item not a subItem.
               invoke osMemoField   'setEmpty'                           *> Empty the memo field.
           else                                                          *>
               invoke osMemoField   'setText'     using aSubItemMemo     *> It's an item, so put the memo into the memo field.
           end-if                                                        *>
                                                                         *>
           exit method.                                                  *> Leave this method, return control to the event manager, wait for more input.
       end method 'onEventTreeItemSelected'.                             *> End of this method.
                                                                         *>
       method-id. 'initializeTreeView'.                                  *> Put items and subItems on the tree view, make a list of the subItems,
                                                                         *> and the text for each one.
       working-storage section.                                          *> Data private to this method which exists the whole time this class is executing.
       01 itemText                            pic x(20) value 'Item'.    *> Text for the tree view and memo fields. It's here because value clauses can't
       01 subItemText                         pic x(20) value 'SubItem'. *> apply to non-static data eg fields in local-storage.
       01 subItemMemoGroup.                                              *>
          05 occurs 20.                                                  *>
              10 subItemMemo                  pic x(70) value            *>
                 'This is line 01 of SubItem 01 of Item 01.'.            *>
                                                                         *>
       local-storage section.                                            *> Data private to this method, created when the method is invoked, destroyed when the
                                                                         *> method is exited. Note however that objects must be explicitly destroyed.
       01 anItem                              object reference.          *> An item for the tree view.
       01 aSubItem                            object reference.          *> A subItem for the tree view.
       01 aSubItemMemo                        object reference.          *> A subItem memo item for the memo box.
       01 aString                             object reference.          *> A general purpose string.
       01 itemCount                           pic x(4) comp-5.           *> Counter for loading the tree view with items.
       01 subItemCount                        pic x(4) comp-5.           *> Counter for loading the tree view with subItems.
       01 subItemMemoCount                    pic x(4) comp-5.           *> Counter for loading the memo text lines into the memo text object.
       01 CounterEdited                       pic 99.                    *> The counter is put into the memo text lines to differentiate them.
       01 subItemListSize                     pic x(4) comp-5.           *> The initial size of the subItem list and subItem memo list.
       01 stringLength                        pic x(4) comp-5.           *> Generic string length for the character array class.
                                                                         *>
       procedure division.                                               *>
                                                                         *>
           move 1 to subItemListSize                                     *> The initial size of the subItem memo list; it will grow as entries are added.
           invoke identityDictionary 'ofValues' using association        *> Create a list of key/data pairs for each subItem/subItem memo.  IdentityDictionary
                                                      subItemListSize    *> will only hold objects, the association template tells the dictionary to hold
                                            returning osSubItemMemoList  *> simple key/data pairs of objects.
                                                                         *>
           perform varying itemCount from 1 by 1                         *> Load the tree view and the list of memo text.
                     until itemCount > 5                                 *>
               move itemCount          to counterEdited                  *>
               move counterEdited      to itemText(6:2)                  *>
               move length of itemText to stringLength                   *> CharacterArray wants the length of the string.
               invoke characterArray 'withLengthValue'                   *> Make a string object containing the item text.
                                                   using stringLength    *>
                                                         itemText        *>
                                               returning aString         *>
               invoke osTreeView     'addItem'     using osTreeView      *> Add the item text to the tree view, with the tree view as parent,
                                                         aString         *> giving back an item object. The tree view takes responibility for
                                               returning anItem          *> destroying the item object.
               invoke aString        'finalize'returning aString         *> Finished with the string so destroy it.
               perform varying subItemCount from 1 by 1                  *> Add five histories for each item on the tree view
                         until subItemCount > 5                          *> and create memo text for each subItem.
                   move subItemCount          to counterEdited           *>
                   move counterEdited         to subItemText(9:2)        *>
                   move length of subItemText to stringLength            *> CharacterArray wants the length of the string.
                   invoke characterArray  'withLengthValue'              *> Make a string object containing the subItem text.
                                                      using stringLength *>
                                                             subItemText *>
                                                   returning aString     *>
                   invoke osTreeView      'addItem'    using anItem      *> Add the subItem text to the tree view, with the current item as parent,
                                                             aString     *> giving back a subItem object. The tree view takes responibility for
                                                   returning aSubItem    *> destroying the subItem object.
                   invoke aString         'finalize' returning aString   *> Finished with the string so destroy it.
                   perform varying subItemMemoCount from 1 by 1          *> Create memo text for the current subItem.
                             until subItemMemoCount > 20                 *>
                       move SubItemMemoCount   to counterEdited          *> Assemble the text line.
                       move counterEdited      to subItemMemo            *>
                                               (subItemMemoCount)(14:2)  *>
                       move subItemText(1:10)  to subItemMemo            *>
                                               (subItemMemoCount)(20:10) *>
                       move itemText  (1:7)    to subItemMemo            *>
                                               (subItemMemoCount)(34:8)  *>
                       move x'0d0a'            to subItemMemo            *> The x'0d0a' is a carriage return/line feed pair, needed to separate
                                               (subItemMemoCount)(69:2)  *> the lines in the memo field.
                       if subItemMemoCount = 5 or 10 or 15               *>
                          move ' with some extra text.'                  *>
                            to subItemMemo(subItemMemoCount)(42:21)      *>
                       end-if                                            *>
                   end-perform                                           *>
                   move length of subItemMemoGroup to stringLength       *> CharacterArray wants the length of the string.
                   invoke characterArray  'withLengthValue'              *> Make a string object containing the subItem memo text.
                                                  using stringLength     *>
                                                        subItemMemoGroup *>
                                              returning aSubItemMemo     *>
                   invoke osSubItemMemoList 'atPut' using aSubItem       *> Add the subItem and its memo text to the list of subItems.  The dictionary
                                                          aSubItemMemo   *> object takes responsibility for destroying these objects.
               end-perform                                               *>
           end-perform                                                   *>
                                                                         *>
           exit method.                                                  *> Leave this method, return control to the invoking method.
       end method 'initializeTreeView'.                                  *> End of this method.
                                                                         *>
       method-id. 'createGUIObjects'.                                    *> Create the GUI objects and set their size and position.
       local-storage section.                                            *> Data private to this method, created when the method is invoked, destroyed when the
                                                                         *> method is exited. Note however that objects must be explicitly destroyed.
       01 lsResourceId                            pic x(4)  comp-5.      *> Holds the unique identifier for the push button.
       01 sizeOrPosition                          pic x(4)  comp-5.      *> Holds a size or position for moving the GUI objects around on the screen.
       01 lsX                                     pic s9(9) comp-5.      *> Used for the private tree view method to move the vertical splitter bar left.
       01 lsY                                     pic s9(9) comp-5.      *> Passed to the above method but not actually used by it.
                                                                         *>
       procedure division.                                               *>
                                                                         *>
           move IDOK to lsResourceId                                     *> Unique identifier for the OK button.
           invoke self 'getObjectFromId'       using lsResourceId        *> Get the push button object from the resource file.
                                           returning osPushbutton        *>
                                                                         *>
           invoke SplitView 'new'              using self                *> Create a new vertical Split View Window with this dialog box as parent,
                                           returning osSplitView         *> giving back a Split View Window object.
           invoke treeViewControl        'new' using osSplitView         *> Create a new tree view with the Split View Window as parent,
                                           returning osTreeView          *> giving back a tree view object.
           invoke multipleLineEntryField 'new' using osSplitView         *> Create a new memo field with the Split View Window as parent,
                                           returning osMemoField         *> giving back a memo field object.
                                                                         *>
           invoke osSplitView 'create'                                   *> Make the GUI object visible.
           invoke osTreeView  'create'                                   *> Make the GUI object visible.
           invoke osMemoField 'create'                                   *> Make the GUI object visible.
                                                                         *>
           move 160 to sizeOrPosition                                    *> A pixel value for the height.
           invoke osSplitView 'setHeight'    using sizeOrPosition        *> Set the height of the Split View Window; its children will reflect the change.
           move 445 to sizeOrPosition                                    *> A pixel value for the width.
           invoke osSplitView 'setWidth'     using sizeOrPosition        *> Set the width of the Split View Window; its children will follow again.
                                                                         *>
           move 9   to sizeOrPosition                                    *> A pixel value for moving the Split View Window.
           invoke osSplitView 'setX'         using sizeOrPosition        *> Move to the right.
           invoke osSplitView 'setY'         using sizeOrPosition        *> Move down.
                                                                         *>
           move 150 to sizeOrPosition                                    *> A pixel value for moving the splitter bar left.
           invoke osSplitView 'setInitialSplitPos' using sizeOrPosition  *> Move the splitter bar to 150 pixels from the left side of the Split View Window.
                                                                         *>
           invoke osMemoField 'readOnly'                                 *> Make the memo field read only.
                                                                         *>
           exit method.                                                  *> Leave this method, return control to the invoking method.
       end method 'createGUIObjects'.                                    *> End of this method.
                                                                         *>
       method-id. 'mapControlsToMethods'.                                *> Map pushbutton events and menu selections to methods.
       procedure division.                                               *>
                                                                         *>
           map event  clicked                    upon osPushButton       *> When the pushbutton is clicked, invoke the method 'onEventOK' in this program.
            to method z'onEventOk'               upon self               *> The 'z' preceding 'onEventOK' makes it a null terminated or ASCIIZ string
                                                                         *> ie adds a low-value byte to the end.
           map event  closed                     upon self               *> When the close menu option or alt+F4 is pressed invoke the same method.
            to method z'onEventOK'               upon self               *>
                                                                         *>
           map event  p2ce-select                upon osTreeView         *> When a tree view item is selected invoke the method onEventTreeItemSelected.
            to method z'onEventTreeItemSelected' upon self               *>
                                                                         *>
           exit method.                                                  *> Leave this method, return control to the invoking method.
       end method 'mapControlsToMethods'.                                *> End of this method.
                                                                         *>
       end object.                                                       *> End of instance data and methods.
                                                                         *>
       end class TreeViewdemo.                                           *> End of this class.
                                                                         *>
