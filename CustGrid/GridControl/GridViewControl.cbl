       class-id MicroFocus.VisualCOBOL.SampleGridView is partial
                 inherits type System.Windows.Forms.UserControl
                 implements type System.Runtime.Serialization.ISerializable
                 type MicroFocus.VisualCOBOL.ISampleGridView
                 attribute Serializable()
                 attribute ComVisible(true)
                 attribute ProgId("MicroFocus.VisualCOBOL.SampleGridView")
                 attribute ClassInterface(type ClassInterfaceType::None)
                 attribute ComDefaultInterface(type of MicroFocus.VisualCOBOL.ISampleGridView)
                 attribute ComSourceInterfaces(type of GridViewUserControl.IGridViewEvents)
                 attribute Guid("B33E4887-6BC0-4382-883B-EB0015F55D9B")
                 .
       assembly-attributes.
                 attribute Guid("8A36A51A-E4AA-45BA-B791-06C289096852")
                 .          
       
       working-storage section.
       
       01 OnRowSelected type RowSelectedEventHandler event public.
       01 OnRowDeleted type RowDeletedEventHandler event public.
       01 OnChanged type RowChangedEventHandler event public.

       method-id COMRegister static attribute ComRegisterFunction().
       01 keyName string.
       01 k type RegistryKey.
       01 subKey type RegistryKey.
       01 libid type Guid.
       01 ver type Version.
       01 versionStr string.
       procedure division using by value t as type Type.
       try
           set keyName to "CLSID\" & t::GUID::ToString("B")
           set k to type Registry::ClassesRoot::OpenSubKey(keyName, true)
           invoke k::CreateSubKey("Control")
           set subkey to k::CreateSubKey("MiscStatus")
           invoke subKey::SetValue("", "401")
           set subkey to k::CreateSubKey("TypeLib")
           set libid to type Marshal::GetTypeLibGuidForAssembly(t::Assembly)
           invoke subKey::SetValue("", libid::ToString("B"))
           
           set subkey to  k::CreateSubKey("Version")
           set ver to t::Assembly::GetName()::Version
           set versionStr to string::Format("{0}.{1}", ver::Major, ver::Minor)
           if versionStr EQUALS "0.0"
               set versionStr to "1.0"                          
           end-if
           invoke subKey::SetValue("", versionStr)         
           catch   
           continue              
       end-try
           goback.
       end method.
       
       method-id COMUnregister static attribute ComUnregisterFunction().
       01 keyName string.
       procedure division using by value t as type Type.
       try
           set keyName to "CLSID\" & t::GUID::ToString("B")
           
           invoke type Registry::ClassesRoot::DeleteSubKey(keyName)
       catch
           continue
       end-try
           goback.
       end method.
       
       method-id NEW.
       procedure division.
           invoke self::InitializeComponent()
           goback.
       end method.
      
       method-id NEW.
       procedure division using by value info as type System.Runtime.Serialization.SerializationInfo, context as type System.Runtime.Serialization.StreamingContext.
           goback.
       end method.
      
       method-id GetObjectData public.
       
       local-storage section.
       
       procedure division using by value info as type System.Runtime.Serialization.SerializationInfo, context as type System.Runtime.Serialization.StreamingContext.
       
           goback.
       end method.      
      
       method-id OnRowEnter final private.
       procedure division using by value sender as object e as type System.Windows.Forms.DataGridViewCellEventArgs.

           invoke self::FireRowSelected(e::RowIndex, e::ColumnIndex)       
           goback.
       
       end method.

       method-id FireOnChanged.
       procedure division using by value row as binary-long, rowCount as binary-long.
           if (OnChanged NOT = NULL)
               invoke OnChanged::Invoke(row, rowCount)
           end-if
           goback.
       end method.
       
      *>> <summary>
      *>> Fire the OnRowSelected event
      *>> </summary>
      *>> <param name="row"></param>
      *>> <param name="coln"></param>
       method-id FireRowSelected.
       procedure division using by value row as binary-long, coln as binary-long.
           if (OnRowSelected NOT = NULL)
               invoke OnRowSelected::Invoke(row, coln)
           end-if
           goback.
       end method.

      *>> <summary>
      *>> Fire the OnRowDeleted event
      *>> </summary>
      *>> <param name="row"></param>
      *>> <param name="coln"></param>
       method-id FireRowDeleted.
       procedure division using by value row as binary-long, coln as binary-long.
           if (OnRowDeleted NOT = NULL)
               invoke OnRowDeleted::Invoke(row, coln)
           end-if
           goback.
       end method.

      *>  Implementation of MicroFocus.VisualCOBOL.ISampleGridView
       method-id get property RowSet.
       procedure division returning theRowSet as object.
           
           set theRowSet to new GridViewUserControl.RowSet(self)
           goback.
       end method.
       
       method-id. get property OrderGrid.
       procedure division returning thegrid as type DataGridView.
           set thegrid to self::OrdersGridView
           goback.
       end method.

       method-id OrdersGridView_CellEndEdit final private.
       procedure division using by value sender as object e as type System.Windows.Forms.DataGridViewCellEventArgs.
           invoke self::FireOnChanged(e::RowIndex, e::ColumnIndex)
           goback.
       end method.

       end class.
       
      *> Delegate definitions for our events 
       delegate-id RowSelectedEventHandler.
       
       procedure division using by value row as binary-long, coln as binary-long.
           
       end delegate.

       delegate-id RowDeletedEventHandler.
       
       procedure division using by value row as binary-long, coln as binary-long.
           
       end delegate.

       delegate-id RowChangedEventHandler.
       procedure division using by value row as binary-long, rowCount as binary-long.
       end delegate.