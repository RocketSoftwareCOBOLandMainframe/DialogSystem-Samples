       class-id MicroFocus.VisualCOBOL.SampleGridView is partial
                 inherits type System.Windows.Forms.UserControl.
                 
       01 OrdersGridView type System.Windows.Forms.DataGridView.
       01 OrderNo type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 OrderDate type GridViewUserControl.CalendarColumn.
       01 OrderValue type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 PaymentValue type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 Balance type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 dataGridViewTextBoxColumn1 type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 calendarColumn1 type GridViewUserControl.CalendarColumn.
       01 dataGridViewTextBoxColumn2 type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 dataGridViewTextBoxColumn3 type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 dataGridViewTextBoxColumn4 type System.Windows.Forms.DataGridViewTextBoxColumn.
       01 components type System.ComponentModel.IContainer.
      
      *> Required method for Designer support - do not modify
      *> the contents of this method with the code editor.
       method-id InitializeComponent private.
       local-storage section.
       01 dataGridViewCellStyle1 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle2 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle3 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle4 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle5 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle6 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle7 type System.Windows.Forms.DataGridViewCellStyle.
       01 dataGridViewCellStyle8 type System.Windows.Forms.DataGridViewCellStyle.
       procedure division.
       set dataGridViewCellStyle1 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle2 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle3 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle4 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle5 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle6 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle7 to new System.Windows.Forms.DataGridViewCellStyle
       set dataGridViewCellStyle8 to new System.Windows.Forms.DataGridViewCellStyle
       set OrdersGridView to new System.Windows.Forms.DataGridView
       set OrderNo to new System.Windows.Forms.DataGridViewTextBoxColumn
       set OrderDate to new GridViewUserControl.CalendarColumn
       set OrderValue to new System.Windows.Forms.DataGridViewTextBoxColumn
       set PaymentValue to new System.Windows.Forms.DataGridViewTextBoxColumn
       set Balance to new System.Windows.Forms.DataGridViewTextBoxColumn
       set dataGridViewTextBoxColumn1 to new System.Windows.Forms.DataGridViewTextBoxColumn
       set calendarColumn1 to new GridViewUserControl.CalendarColumn
       set dataGridViewTextBoxColumn2 to new System.Windows.Forms.DataGridViewTextBoxColumn
       set dataGridViewTextBoxColumn3 to new System.Windows.Forms.DataGridViewTextBoxColumn
       set dataGridViewTextBoxColumn4 to new System.Windows.Forms.DataGridViewTextBoxColumn
       invoke OrdersGridView as type System.ComponentModel.ISupportInitialize::BeginInit
       invoke self::SuspendLayout
      *> 
      *> OrdersGridView
      *> 
       set OrdersGridView::AllowUserToDeleteRows to False
       set OrdersGridView::AllowUserToOrderColumns to True
       set OrdersGridView::Anchor to type System.Windows.Forms.AnchorStyles::Top b-or type System.Windows.Forms.AnchorStyles::Bottom b-or type System.Windows.Forms.AnchorStyles::Left b-or type System.Windows.Forms.AnchorStyles::Right as
           type System.Windows.Forms.AnchorStyles
       set OrdersGridView::BorderStyle to type System.Windows.Forms.BorderStyle::Fixed3D
       set OrdersGridView::ColumnHeadersHeightSizeMode to type System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode::AutoSize
       invoke OrdersGridView::Columns::AddRange(OrderNo OrderDate OrderValue PaymentValue Balance)
       set OrdersGridView::Location to new System.Drawing.Point( 3 3)
       set OrdersGridView::Name to "OrdersGridView"
       set OrdersGridView::Size to new System.Drawing.Size( 543 163)
       set OrdersGridView::TabIndex to 1
       invoke OrdersGridView::add_CellEndEdit(new System.Windows.Forms.DataGridViewCellEventHandler(self::OrdersGridView_CellEndEdit))
       invoke OrdersGridView::add_RowEnter(new System.Windows.Forms.DataGridViewCellEventHandler(self::OnRowEnter))
      *> 
      *> OrderNo
      *> 
       set OrderNo::HeaderText to "Order No."
       set OrderNo::Name to "OrderNo"
      *> 
      *> OrderDate
      *> 
       set dataGridViewCellStyle1::Format to "D"
       set dataGridViewCellStyle1::NullValue to "00/00/00"
       set OrderDate::DefaultCellStyle to dataGridViewCellStyle1
       set OrderDate::HeaderText to "Order Date"
       set OrderDate::Name to "OrderDate"
       set OrderDate::Resizable to type System.Windows.Forms.DataGridViewTriState::True
       set OrderDate::SortMode to type System.Windows.Forms.DataGridViewColumnSortMode::Automatic
      *> 
      *> OrderValue
      *> 
       set dataGridViewCellStyle2::Format to "C2"
       set dataGridViewCellStyle2::NullValue to "0.00"
       set OrderValue::DefaultCellStyle to dataGridViewCellStyle2
       set OrderValue::HeaderText to "Order Value"
       set OrderValue::MaxInputLength to 6
       set OrderValue::Name to "OrderValue"
      *> 
      *> PaymentValue
      *> 
       set PaymentValue::AutoSizeMode to type System.Windows.Forms.DataGridViewAutoSizeColumnMode::ColumnHeader
       set dataGridViewCellStyle3::Format to "C2"
       set dataGridViewCellStyle3::NullValue to "0.00"
       set PaymentValue::DefaultCellStyle to dataGridViewCellStyle3
       set PaymentValue::HeaderText to "Payment Value"
       set PaymentValue::Name to "PaymentValue"
       set PaymentValue::Width to 95
      *> 
      *> Balance
      *> 
       set dataGridViewCellStyle4::Format to "C2"
       set dataGridViewCellStyle4::NullValue to "0.00"
       set Balance::DefaultCellStyle to dataGridViewCellStyle4
       set Balance::HeaderText to "Balance"
       set Balance::Name to "Balance"
       set Balance::ReadOnly to True
      *> 
      *> dataGridViewTextBoxColumn1
      *> 
       set dataGridViewTextBoxColumn1::HeaderText to "Order No."
       set dataGridViewTextBoxColumn1::Name to "dataGridViewTextBoxColumn1"
      *> 
      *> calendarColumn1
      *> 
       set dataGridViewCellStyle5::Format to "D"
       set dataGridViewCellStyle5::NullValue to "00/00/00"
       set calendarColumn1::DefaultCellStyle to dataGridViewCellStyle5
       set calendarColumn1::HeaderText to "Order Date"
       set calendarColumn1::Name to "calendarColumn1"
       set calendarColumn1::Resizable to type System.Windows.Forms.DataGridViewTriState::True
       set calendarColumn1::SortMode to type System.Windows.Forms.DataGridViewColumnSortMode::Automatic
      *> 
      *> dataGridViewTextBoxColumn2
      *> 
       set dataGridViewCellStyle6::Format to "C2"
       set dataGridViewCellStyle6::NullValue to "0.00"
       set dataGridViewTextBoxColumn2::DefaultCellStyle to dataGridViewCellStyle6
       set dataGridViewTextBoxColumn2::HeaderText to "Order Value"
       set dataGridViewTextBoxColumn2::MaxInputLength to 6
       set dataGridViewTextBoxColumn2::Name to "dataGridViewTextBoxColumn2"
      *> 
      *> dataGridViewTextBoxColumn3
      *> 
       set dataGridViewTextBoxColumn3::AutoSizeMode to type System.Windows.Forms.DataGridViewAutoSizeColumnMode::ColumnHeader
       set dataGridViewCellStyle7::Format to "C2"
       set dataGridViewCellStyle7::NullValue to "0.00"
       set dataGridViewTextBoxColumn3::DefaultCellStyle to dataGridViewCellStyle7
       set dataGridViewTextBoxColumn3::HeaderText to "Payment Value"
       set dataGridViewTextBoxColumn3::Name to "dataGridViewTextBoxColumn3"
      *> 
      *> dataGridViewTextBoxColumn4
      *> 
       set dataGridViewCellStyle8::Format to "C2"
       set dataGridViewCellStyle8::NullValue to "0.00"
       set dataGridViewTextBoxColumn4::DefaultCellStyle to dataGridViewCellStyle8
       set dataGridViewTextBoxColumn4::HeaderText to "Balance"
       set dataGridViewTextBoxColumn4::Name to "dataGridViewTextBoxColumn4"
       set dataGridViewTextBoxColumn4::ReadOnly to True
      *> 
      *> SampleGridView
      *> 
       set self::AutoScaleDimensions to new System.Drawing.SizeF( 6 13)
       set self::AutoScaleMode to type System.Windows.Forms.AutoScaleMode::Font
       invoke self::Controls::Add(OrdersGridView)
       set self::Name to "SampleGridView"
       set self::Size to new System.Drawing.Size( 549 169)
       invoke OrdersGridView as type System.ComponentModel.ISupportInitialize::EndInit
       invoke self::ResumeLayout(False)
       end method.

      *> Clean up any resources being used.      
       method-id Dispose override protected.
       local-storage section.
       linkage section.
       procedure division using by value disposing as condition-value.
           if disposing then
               if components not = null then
                   invoke components::Dispose()
               end-if
           end-if
           invoke super::Dispose(by value disposing)
           goback.
       end method.

       end class.
