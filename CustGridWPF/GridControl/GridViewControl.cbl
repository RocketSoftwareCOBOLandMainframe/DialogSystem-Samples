       class-id MicroFocus.VisualCOBOL.WPFSampleGridView is partial
                 inherits type System.Windows.Forms.UserControl
                 implements type System.Runtime.Serialization.ISerializable
                 type MicroFocus.VisualCOBOL.IWPFSampleGridView
                 attribute Serializable()
                 attribute ComVisible(true)
                 attribute ProgId("WPFSampleGridView")
                 attribute ClassInterface(type ClassInterfaceType::None)
                 attribute ComDefaultInterface(type of MicroFocus.VisualCOBOL.IWPFSampleGridView)
                 attribute ComSourceInterfaces(type of MicroFocus.VisualCOBOL.IWPFGridViewEvents)
                 attribute Guid("E0A41600-4531-4E55-9B24-6D2F1CF8B106")
                 .
                 
       assembly-attributes.
                 attribute Guid("E41DD0A3-71C4-438A-A6A9-BB8E7F349CE6")
                 .
       working-storage section.
       
       01 OnRowSelected type RowSelectedEventHandler event public.
       01 OnRowDeleted type RowDeletedEventHandler event public.
       01 OnChanged type CellEditEndingHandler event public.

      *> Create an observable collection of CustomerOrder objects so that the data grid receives notifications such as add, delete in order to refresh the list
       01 _customerOrders type ObservableCollection[type CustomerOrder] value new ObservableCollection[type CustomerOrder] public property as "CustomerOrders".
       
       01 _commitEdit CONDITION-VALUE private.
       
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
           
           invoke self::OrderGrid::add_SelectionChanged(new SelectionChangedEventHandler(self::OnSelectionChanged))
           invoke self::OrderGrid::add_CellEditEnding(new EventHandler[type DataGridCellEditEndingEventArgs](self::OnCellEditEnding))
           invoke self::OrderGrid::add_SourceUpdated(new EventHandler[type System.Windows.Data.DataTransferEventArgs](self::OnSourceUpdated))
           goback.
       end method.
      
       method-id OnSourceUpdated.
       01 row binary-long.
       01 custorder type CustomerOrder.
       01 dgrid type System.Windows.Controls.DataGrid.
       procedure division using by value sender as object e as type System.Windows.Data.DataTransferEventArgs.
           set dgrid to sender as type System.Windows.Controls.DataGrid
           set custorder to dgrid::CurrentItem as type CustomerOrder
           set row to self::CustomerOrders::IndexOf(custorder)
           invoke self::FireOnChanged(row, 1)
           goback.
       end method.
      
       method-id OnCellEditEnding.
       01 row binary-long.
       01 dgrid type System.Windows.Controls.DataGrid.
       01 currentCustomerOrder type CustomerOrder.
       01 rowView type System.Data.DataRowView.
       procedure division using by value sender as object e as type System.Windows.Controls.DataGridCellEditEndingEventArgs.

           if (_commitEdit = FALSE)
               set _commitEdit to TRUE
               set currentCustomerOrder to e::Row::Item as type CustomerOrder
               set dgrid to sender as type System.Windows.Controls.DataGrid
               invoke dgrid::CommitEdit(type DataGridEditingUnit::Row, TRUE)
               set row to self::CustomerOrders::IndexOf(currentCustomerOrder)
               invoke self::FireOnChanged(row, 1)
               set _commitEdit to FALSE
           end-if
           goback.
       end method.
       
       method-id OnSelectionChanged.
       01 objectSelected object.
       01 orderSelected type CustomerOrder.
       01 row binary-long.
       procedure division using by value sender as object e as type System.Windows.Controls.SelectionChangedEventArgs.
           
           if e::AddedItems not = null and e::AddedItems::Count > 0
               set objectSelected to e::AddedItems::Item(0)
               if (objectSelected is instance of type CustomerOrder)
           
                   set orderSelected to objectSelected as type CustomerOrder
                   set row to self::CustomerOrders::IndexOf(orderSelected)
                   invoke self::FireRowSelected(row, 1)       
           
               end-if
           end-if
           
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

       method-id FireOnChanged.
       procedure division using by value row as binary-long, coln as binary-long.
           if (OnChanged NOT = NULL)
               invoke OnChanged::Invoke(row, coln)
           end-if
           goback.
       end method.

      *>  Implementation of MicroFocus.VisualCOBOL.IWPFSampleGridView
       method-id get property RowSet.
       procedure division returning theRowSet as object.
           
           set theRowSet to new WPFGridViewUserControl.RowSet(self)
           goback.
       end method.
       
       method-id. get property OrderGrid.
       procedure division returning thegrid as type System.Windows.Controls.DataGrid.
           set thegrid to self::wpfUserControl1::OrdersGrid
           goback.
       end method.

       method-id WPFSampleGridView_Load final private.
       procedure division using by value sender as object e as type System.EventArgs.
       
       end method.

      
       end class.
       
      *> Delegate definitions for our events 
       delegate-id RowSelectedEventHandler.
       
       procedure division using by value row as binary-long, coln as binary-long.
           
       end delegate.

       delegate-id RowDeletedEventHandler.
       
       procedure division using by value row as binary-long, coln as binary-long.
           
       end delegate.
       
       delegate-id CellEditEndingHandler.
       procedure division using by value row as binary-long, coln as binary-long.
       end delegate.
