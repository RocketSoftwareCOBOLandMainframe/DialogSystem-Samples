       class-id OrderFormsLibrary.OrderForm is partial
                 inherits type System.Windows.Forms.Form.
       
       working-storage section.
       
       78  no-of-orders            VALUE 10.

      *> We copy the customer data block into instance data and we can do that by
      *> simply including the customer copy book
       copy "CUSTOMER.CPB".
       
       method-id NEW.
       linkage section.
       01 data-block pic x(1000).
       procedure division using by reference data-block.

           *> Take the given data-block and move it to the copy we have in instance data
           move data-block(1: LENGTH OF CUSTOMER-DATA-BLOCK) to CUSTOMER-DATA-BLOCK       
           invoke self::InitializeComponent
           goback.
       end method.

       method-id OrderForm_Load final private.
       local-storage section.
       procedure division using by value sender as object e as type System.EventArgs.
       
           *> Populate the data grid view with our orders info
           invoke self::PopulateOrders() 
       
           goback.
       end method.

      *>> <summary>
      *>> Initialize the UI from the orders information in the CUSTOMER-DATA-BLOCK
      *>> </summary>
       method-id PopulateOrders public.
       local-storage section.
       01 array-ind    PIC 9(4) COMP.
       01 cell         type DataGridViewCell.
       01 row          type DataGridViewRow.
      *> Use a DateTime object to convert from the COBOL type
       01 dt           type DateTime. 
       01 dt1          PIC 9(8).
       01 redefines dt1.
          03 dy pic 99.
          03 mn pic 99.
          03 yr pic 9999.
       01 yr-int       binary-long.
      *> Use a decimal type to handle the decimal point for currency info 
       01 dec          decimal.
       procedure division.
       
           set OrdersGridView::RowCount to no-of-orders
           move 1 to array-ind
           perform varying row thru OrdersGridView::Rows
       
               MOVE CUSTOMER-ORD-NO(array-ind) to row::Cells::get_Item("OrderNo")::Value
               move customer-ord-date(array-ind) to dt1
               
               set cell to row::Cells::get_Item("OrderDate")
               try
                      move yr to yr-int
                      set dt to new DateTime(yr-int, mn, dy) 
                      MOVE dt to cell::Value
               catch
                      move "00/00/0000" to cell::Value
               end-try
               
               MOVE customer-ord-val(array-ind) to dec
               MOVE dec to row::Cells::get_Item("OrderValue")::Value
               MOVE customer-pay-val(array-ind) to dec
               MOVE dec to row::Cells::get_Item("PaymentValue")::Value
               MOVE CUSTOMER-ORD-BAL(array-ind) to dec
               MOVE dec to row::Cells::get_Item("Balance")::Value
               
               add 1 to array-ind
           end-perform
       
           goback.
       end method.      

       method-id OK_Click final private.
       local-storage section.
       01 array-ind pic 9(4) COMP.
       01 row type DataGridViewRow.
       01 dec decimal.
       01 str string.
       01 res binary-long.
       01 dt type DateTime.
       01 cobDate PIC 9(8).
       01 cobDateSplit redefines cobDate.
          03 dy PIC 99.
          03 mn PIC 99.
          03 yr PIC 9999.
       procedure division using by value sender as object e as type System.EventArgs.
       
      *> Move the data back 
           move 1 to array-ind
           perform varying row thru OrdersGridView::Rows

               MOVE row::Cells::get_Item("OrderNo")::Value to str 
               if type Int32::TryParse(str, by reference res)
                   move res to CUSTOMER-ORD-NO(array-ind)
               else
                   move 0 to CUSTOMER-ORD-NO(array-ind)
               end-if
               MOVE row::Cells::get_Item("OrderDate")::Value to str
               if type DateTime::TryParse(str, by reference dt)
                   move dt::Day to dy
                   move dt::Month to mn
                   move dt::Year to yr
                   move cobDate to CUSTOMER-ORD-DATE(array-ind)
               else
                   move 0 to CUSTOMER-ORD-DATE(array-ind)
               end-if
               
               MOVE row::Cells::get_Item("OrderValue")::Value to str
               if type Decimal::TryParse(str, by reference dec)
                   MOVE dec to customer-ord-val(array-ind)
               else
                   move 0 to customer-ord-val(array-ind)
               end-if
               MOVE row::Cells::get_Item("PaymentValue")::Value to str
               if type Decimal::TryParse(str, by reference dec)
                   move dec to customer-pay-val(array-ind)
               else
                   move 0 to customer-pay-val(array-ind)
               end-if
               MOVE row::Cells::get_Item("Balance")::Value to str
               if type Decimal::TryParse(str, by reference dec)
                   MOVE dec to CUSTOMER-ORD-BAL(array-ind)
               else
                   MOVE 0 to CUSTOMER-ORD-BAL(array-ind)
               end-if
               
               add 1 to array-ind
           end-perform           

           *> Go close the form
           invoke self::Close()
           goback.
       
       end method.

      *>> <summary>
      *>> Handle the form closing event. We use this to move the locally held Dialog System data block back 
      *>> to the caller
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param>
       method-id OrderForm_FormClosing final private.
       local-storage section.
       procedure division using by value sender as object e as type System.Windows.Forms.FormClosingEventArgs.

           goback.
       end method.

       method-id Delete_Click final private.
       local-storage section.
       01 row type DataGridViewRow.
       01 idx binary-long.
       procedure division using by value sender as object e as type System.EventArgs.

           set row to OrdersGridView::CurrentRow
           if (row not = null)
               set row::Cells::get_Item("OrderNo")::Value to 0
               set row::Cells::get_Item("OrderDate")::Value to "00/00/00"
               set row::Cells::get_Item("OrderValue")::Value to 0
               set row::Cells::get_Item("PaymentValue")::Value to 0
               set row::Cells::get_Item("Balance")::Value to 0
           end-if
           goback.
       end method.

       end class.
