       class-id WPFGridViewUserControl.RowSet.

       working-storage section.

       01 _gridControl type WPFSampleGridView.
       
       
       method-id NEW.
       procedure division using by value gridControl as type WPFSampleGridView.
           set _gridControl to gridControl
           goback.
       end method.
       
       method-id get property Count.
       local-storage section.
       procedure division returning anInt as binary-long.

           set anInt to _gridControl::CustomerOrders::Count *> Subtract 1 because there is always an 'empty' row ready for user editing in order to create a new row
           goback.
       end method.

       method-id set property Count.
       local-storage section.
       procedure division using anInt as binary-long.
       
           *> Setting the count, clear all the items from the list
           if (anInt = 0 and _gridControl::CustomerOrders not = null)
               invoke _gridControl::CustomerOrders::Clear()
           end-if
           goback.
       end method.

       method-id get property Item.
       procedure division using rowIndex as binary-long returning rowData as object occurs any.
           set rowData to _gridControl::CustomerOrders::Item(rowIndex)::AsArray()
           goback.
       end method.

       method-id UpdateRow.
       procedure division using rowIndex as binary-long, rowData as object occurs any.
           set _gridControl::CustomerOrders::Item(rowIndex) to new CustomerOrder(rowData)
           
           goback.
       end method.

       method-id Add public.
       
       local-storage section.
       
       procedure division using by value dtAfterLast as binary-long
                                by value rowData as object occurs any.
       
           invoke _gridControl::CustomerOrders::Add(new CustomerOrder(rowData))
           if (_gridControl::OrderGrid::ItemsSource = null)
               set _gridControl::OrderGrid::ItemsSource to _gridControl::CustomerOrders
           end-if
           goback.
       end method.

       method-id GetSelect public.
       procedure division using by value theRow as binary-long returning num as binary-long.
       
           set num to _gridControl::OrderGrid::SelectedIndex
           goback.
       end method.

       method-id Remove public.
       01 rows type DataGridViewRowCollection.
       01 row type DataGridViewRow.
       procedure division using num as binary-long.
           invoke self::_gridControl::CustomerOrders::RemoveAt(num)
           invoke _gridControl::FireRowDeleted(num , 1)
           goback.
       end method.

       end class.
