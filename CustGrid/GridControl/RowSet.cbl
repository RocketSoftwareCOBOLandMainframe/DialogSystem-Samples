       class-id GridViewUserControl.RowSet.

       working-storage section.

       01 _gridControl type SampleGridView.
       
       method-id NEW.
       procedure division using by value gridControl as type SampleGridView.
           set _gridControl to gridControl
           goback.
       end method.
       
       method-id get property Count.
       local-storage section.
       procedure division returning anInt as binary-long.

           set anInt to _gridControl::OrderGrid::Rows::Count - 1 *> Subtract 1 because there is always an 'empty' row ready for user editing in order to create a new row
           goback.
       end method.

       method-id set property Count.
       local-storage section.
       procedure division using anInt as binary-long.
       
           set _gridControl::OrderGrid::RowCount to anInt + 1 *> + 1 because we allow the user to add new row information (so there's always 1 visible)
           goback.
       end method.

       method-id get property Item.
       01 rowCollection type DataGridViewRowCollection.
       procedure division using rowIndex as binary-long returning aRow as type GridViewUserControl.UserDataGridViewRow.
           set rowCollection to _gridControl::OrderGrid::Rows
           set arow to new GridViewUserControl.UserDataGridViewRow(rowCollection::Item(rowIndex))
           goback.
       end method.

       method-id Add public.
       
       local-storage section.
       
       procedure division using by value dtAfterLast as binary-long
                                by value rowData as object occurs any.
       
           invoke _gridControl::OrderGrid::Rows::Add(rowData)
           goback.
       end method.

       method-id GetSelect public.
       procedure division using by value theRow as binary-long returning num as binary-long.
       
           set num to _gridControl::OrderGrid::CurrentRow::Index
           goback.
       end method.

       method-id Remove public.
       01 rows type DataGridViewRowCollection.
       01 row type DataGridViewRow.
       procedure division using num as binary-long.
           set rows to self::_gridControl::OrderGrid::Rows
           set row to rows::Item(num)
           invoke rows::Remove(row)
           invoke _gridControl::FireRowDeleted(num , 1)
           goback.
       end method.

       end class.
