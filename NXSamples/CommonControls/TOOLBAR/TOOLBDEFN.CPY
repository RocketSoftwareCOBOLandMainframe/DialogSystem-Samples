      *>----------------------------------------------------------------
      *> Menu bar definitions for tbards.gs toolbar
      *> demonstration screenset.
      *>----------------------------------------------------------------

      *>----------------------------------------------------------------
      *> To change the menu defined below, use the existing menu records
      *> as an example to change the menu structure, and if required
      *> add further menu records for any additional menu items.
      *>----------------------------------------------------------------

      ******************************************************************
      * NOTE - Each menu item record below must be mRecSize bytes.
      * ----   Unpredictable results may occur at run time if this
      *        table does not conform to the defined record structure.
      ******************************************************************
      
       01 mData.
       78 mDataStart               value NEXT.
      
      ***>>> Start USER MENU DATA <<<***
      *>----------------------------------------------------------------
      *   Menu item object reference.
          03   object reference.    *> Menu Index 01    

      *   Type of menu item.
          03   pic x comp-5         value typeHasChildren.

      *   Accelerator key definition (see keys.cpy for details).
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.

      *   Menu item state.
          03   pic x comp-5         value stateDefault.

      *   Name of callback to be invoked when menu item selected.
          03   pic x(mCallbackSize) value SPACES.

      *   Null terminated menu text followed by optional null
      *   terminated menu hint text.
      *   The whole string must be terminated by a further null.
          03   pic x(mStringSize)   value z"&File" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 02
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "N".
          03   pic xx.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&New" &
                                    z"Create something new" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 03
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "O".
          03   pic xx.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Open" &
                                    z"Open something" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 04
          03   pic x comp-5         value typeSeparator.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value x"0000".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 05
          03   pic x comp-5         value typeLastSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"E&xit" &
                                    z"Quit this demonstration" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 06
          03   pic x comp-5         value typeHasChildren.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value z"&Colors" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 07
          03   pic x comp-5         value typeSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value z"&Purple" &
                                    z"This does nothing" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 08
          03   pic x comp-5         value typeSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value z"&Yellow" &
                                    z"This does nothing" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 09
          03   pic x comp-5         value typeLastSiblingHasChildren.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value z"P&rimary" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 10
          03   pic x comp-5         value typeSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Red" &
                                    z"Primary red" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 11
          03   pic x comp-5         value typeSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Green" &
                                    z"Primary green" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 12
          03   pic x comp-5         value typeLastSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Blue" &
                                    z"Primary blue" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 13
          03   pic x comp-5         value typeHasChildren.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value SPACES.
          03   pic x(mStringSize)   value z"Ch&eckMark" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 14
          03   pic x comp-5         value typeLastSibling.
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Toggle" &
                                    z"Toggle checkmark" & x"00".
      *>----------------------------------------------------------------
          03   object reference.    *> Menu Index 15
          03   pic x comp-5         value typeLastSibling.
          03   pic x comp-5         value KS-Virtual-Key.
          03   pic x comp-5         value OVK-F1.
          03   pic xx.
          03   pic x comp-5         value stateDefault.
          03   pic x(mCallbackSize) value ProgramID & "OnItemSelected ".
          03   pic x(mStringSize)   value z"&Help" &
                                    z"Display help" & x"00".
      *>----------------------------------------------------------------
      ***>>> End USER MENU DATA <<<***

       78 defaultMenuItems         value NEXT - mDataStart / mRecSize.
       
       01 mTable redefines mData occurs maxMenuItems.
          03 mReference            object reference.
          03 mType                 pic x comp-5.
             88 hasChildren        value 1 3.
             88 lastSibling        value 2 3 6.
             88 isSeparator        value 4 6.
          03 mAccelKey             K-keyDesc.
          03 mState                pic x comp-5.
             88 isDisabled         value 1 3.
             88 isChecked          value 2 3.
          03 mCallback             pic x(mCallbackSize).
          03 mString               pic x(mStringSize).
       01 numberOfMenuItems        pic x(4) comp-5 value
                                   defaultMenuItems.


