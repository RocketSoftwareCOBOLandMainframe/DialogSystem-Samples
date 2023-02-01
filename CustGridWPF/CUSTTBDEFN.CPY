      * ----------------------------------------------------------------
      *> Menu bar and tool bar definitions for customer.gs
      *> demonstration screenset.
      *>----------------------------------------------------------------

      * Name of resource file containing tool bar button bitmaps.
      * Please refer to the topic "Tool Bar Control" in the help
      * for information on creating a resource DLL.
       78 resourceDllName          value z"tbar.dll".

         copy "tbresid.cpy". *> Resource IDs for tool bar button bitmaps

      *>----------------------------------------------------------------
      *> Menu bar definitions.
      *>----------------------------------------------------------------

      * Menu item types.
      * Each menu item added to the window can be one of:
      *    - sub menu
      *    - menu item
      *    - separator
      *
      * In addition, any of the above may be the last item within
      * a sub menu or the whole menu structure on the window.
      *
      * In the menu data structure, the first byte after the menu
      * object reference is used to store the type of the menu item.
      *
      * The first 3 bits in the type byte are defined as follows:
      *
      *    bit 0 set   - indicates a sub menu (has children)
      *          unset - indicates a menu item
      *
      *    bit 1 set   - indicates last item in sub menu or window
      *                                                   (last sibling)
      *          unset - indicates not last item in sub menu or window
      *
      *    bit 2 set   - indicates a separator
      *          unset - indicates not a separator
      *
       78 typeSibling                  value 0.
       78 typeHasChildren              value 1.
       78 typeLastSibling              value 2.
       78 typeLastSiblingHasChildren   value typeLastSibling +
                                             typeHasChildren.
       78 typeSeparator                value 4.
       78 typeLastSiblingSeparator     value typeLastSibling +
                                             typeSeparator.
      * End of menu item types.

       78 noAcceleratorKeyDefined      value 0.

      * Virtual key with control key pressed. This is used to define
      * an accelerator key that has a virtual key code and needs to
      * have the ctrl key pressed.
       78 KS-Virt-Ctrl                 value KS-VIRTUAL-KEY +
                                             KS-CTRL-PRESSED.

      * The maximum number of menu items that can be stored within
      * the menu data table.
       78 maxMenuItems             value 100.

      * Maximum string length of callback entry point names.
       78 mCallbackSize            value 32.

      * Maximum length of menu item text and hint text combined.
       78 mStringSize              value 87.

      * Size of each menu record (one record per menu item).
       78 mRecSize                 value 128.

      *
      * CREATING A NEW MENU STRCUTURE
      * -----------------------------
      *
      * The mData table structure below defines the content and
      * structure (hierachy) of the menu.
      *
      * Each element of the table defines an item in the menu structure
      * and is made up of five parts:
      *    1. Object reference of the created menu item
      *    2. Type of the menu item
      *    3. Accelerator key (if any)
      *    4. Callback entry point name to be executed when the
      *       menu item or an associated tool bar button is selected
      *    5. Optional menu item text and menu hint text
      *
      * To change the menu defined below, use the existing menu
      * records as an example to change the menu structure, and if
      * required add further menu records for any additional menu items.
      *
      *
      * HOW THE MENU HIERACHY IS BUILT
      * ------------------------------
      *
      * The first menu record details the first menu item to be added
      * to the window. The first menu item must be either:
      *    - a menu item (typeSibling) OR
      *    - a sub menu  (typeHasChildren)
      *
      * Each time a sub menu is added, all the following items are added
      * to that sub menu until an item of type
      *    1. typeLastSibling               OR
      *    2. typeLastSiblingIsSeparator    OR
      *    3. typeLastSiblingHasChildren    OR
      *    4. typeHasChildren
      * is encountered.
      *
      * In the case of the first two types listed above, subsequent
      * items will be added to the parent sub menu or window.
      * In the case of the last two types listed above, subsequent
      * items will be added to a new sub menu.
      *
      * As a guide:
      *
      * - Use typeSibling to add a normal menu item (ie. not a sub menu
      *   or separator).
      *
      * - Use typeSeparator to add a separator.
      *
      * - Use typeHasChildren to add a new sub menu.
      *
      * - Use typeLastSibling when a normal menu item is the last item
      *   in a sub menu. (ie. not a sub menu or separator).
      *
      * - Use typeLastSiblingIsSeparator when a separator is the last
      *   item in a sub menu.
      *
      * - Use typeLastSiblingHasChildren when a new sub menu is the last
      *   item in a sub menu.
      *

      ******************************************************************
      * NOTE - Each menu item record below must be mRecSize bytes.
      * ----   Unpredictable results may occur at run time if this
      *        table does not conform to the defined record structure.
      ******************************************************************
       01 mData.
       78 mDataStart               value NEXT.
      *>----------------------------------------------------------------
      * Menu item object reference.
          03   object reference.

      * Type of menu item.
          03   pic x comp-5         value typeHasChildren.

      * Accelerator key definition (see keys.cpy for details).
          03   pic x(4) comp-5      value noAcceleratorKeyDefined.

      * Name of callback to be invoked when menu item selected.
          03   pic x(mCallbackSize) value SPACES.

      * Null terminated menu text followed by optional null
      * terminated menu hint text.
      * The whole string must also be terminated by a further null.
          03   pic x(mStringSize)   value z"&File" & x"00".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "N".
          03   pic xx.
          03   pic x(mCallbackSize) value "CUSTTBOnItemSelected ".
          03   pic x(mStringSize)   value z"&Load" &
                                     z"Load this record" & x"00".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "O".
          03   pic xx.
          03   pic x(mCallbackSize) value "CUSTTBOnItemSelected ".
          03   pic x(mStringSize)   value z"&Save" &
                                    z"Save this record" & x"00".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "O".
          03   pic xx.
          03   pic x(mCallbackSize) value "CUSTTBOnItemSelected ".
          03   pic x(mStringSize)   value z"&Delete" &
                                    z"Delete this record" & x"00".

      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5         value typeSibling.
          03   pic x comp-5         value KS-Virt-Ctrl.
          03   pic x                value "O".
          03   pic xx.
          03   pic x(mCallbackSize) value "CUSTTBOnItemSelected ".
          03   pic x(mStringSize)   value z"&Clear" &
                                    z"Clear the screen" & x"00".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5         value typeLastSibling.
          03   pic x comp-5         value KS-Virtual-Key.
          03   pic x comp-5         value OVK-F12.
          03   pic xx.
          03   pic x(mCallbackSize) value "CUSTTBOnItemSelected ".
          03   pic x(mStringSize)   value z"E&xit" &
                                    z"Quit this demonstration" & x"00".
      *>----------------------------------------------------------------
       78 defaultMenuItems         value NEXT - mDataStart / mRecSize.
       01 mTable redefines mData occurs maxMenuItems.
          03 mReference            object reference.
          03 mType                 pic x comp-5.
             88 hasChildren        value 1 3.
             88 lastSibling        value 2 3 6.
             88 isSeparator        value 4 6.
          03 mAccelKey             K-keyDesc.
          03 mCallback             pic x(mCallbackSize).
          03 mString               pic x(mStringSize).
       01 numberOfMenuItems        pic x(4) comp-5 value
                                   defaultMenuItems.

      *>----------------------------------------------------------------
      *> Toolbar button definitions.
      *>----------------------------------------------------------------

      * The maximum number of buttons that can be stored within
      * the button data table.
       78 maxButtons               value 30.

      * Maximum length of tool tip text.
       78 bStringSize              value 55.

      * Size of each button record (one record per button).
       78 bRecSize                 value 64.

      *
      * CREATING A NEW TOOLBAR BUTTON STRCUTURE
      * ---------------------------------------
      *
      * The bData table structure below defines an ordered list
      * of buttons to be added to the toolbar. Buttons are added to
      * the toolbar in the order the appear in the list.
      *
      * Each element of the table defines a button on the toolbar
      * and is made up of five parts:
      *    1. Object reference of the created toolbar button.
      *    2. The index (within mData table) of the menu item to
      *       associate the button with (or zero for a separator).
      *    3. Resource ID of a bitmap within a resource file to use
      *       for the button when it is enabled.
      *    4. Resource ID of a bitmap within a resource file to use
      *       for the button when it is disabled.
      *    5. Tool tip to be displayed when mouse is over the button.
      *
      * To change the button structure defined below, use the existing
      * button records as an example to change the button structure, and
      * if required add further button records for any additional
      * buttons you wish to add to the toolbar.
      *

      ******************************************************************
      * NOTE - Each toolbar button record below must be bRecSize bytes.
      * ----   Unpredictable results may occur at run time if this
      *        table does not conform to the defined record structure.
      ******************************************************************
       01 bData.
       78 bDataStart               value NEXT.
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 0. *> separator
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize).
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 2. *> "Load" menu item
          03   pic x(4) comp-5     value IDB-OPEN.
          03   pic x(bStringSize)  value z"Load a record".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 3. *> "Save" menu item
          03   pic x(4) comp-5     value IDB-SAVE.
          03   pic x(bStringSize)  value z"Save a record".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 4. *> "Delete" menu item
          03   pic x(4) comp-5     value IDB-NEWDEL.
          03   pic x(bStringSize)  value z"Delete a Record".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 5. *> "Clear" menu item
          03   pic x(4) comp-5     value IDB-NEW.
          03   pic x(bStringSize)  value z"Clear the screen".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 0. *> separator
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize).
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 6. *> "E&xit" menu item
          03   pic x(4) comp-5     value IDB-Exit.
          03   pic x(bStringSize)  value z"Quit".
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 0. *> separator
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize).
      *>----------------------------------------------------------------
          03   object reference.
          03   pic x comp-5        value 0. *> separator
          03   pic x(4) comp-5     value 0.
          03   pic x(bStringSize).
      *>----------------------------------------------------------------
       78 defaultButtons           value NEXT - bDataStart / bRecSize.
       01 bTable redefines bData occurs maxButtons.
          03 bReference            object reference.
          03 bMenuIndex            pic x comp-5.
          03 bBitmapID             pic x(4) comp-5.
          03 bString               pic x(bStringSize).
       01 numberOfButtons          pic x(4) comp-5 value
                                   defaultButtons.
