      *
      * Implements a calendar editor column for use in the data grid 
      *
      *    
       class-id GridViewUserControl.CalendarColumn inherits type DataGridViewColumn.

       working-storage section.

       method-id New.
       procedure division.
           invoke super::New(new CalendarCell())
           goback.
       end method.

       method-id get property CellTemplate override.   
       
       procedure division returning return-value as type DataGridViewCell.
           set return-value to super::CellTemplate
           goback.
       end method.
       
       method-id set property CellTemplate override.
       
       procedure division using by value the-value as type DataGridViewCell.
           if the-value NOT EQUAL null AND
              NOT the-value::GetType()::IsAssignableFrom(type of CalendarCell)
              raise new InvalidCastException("Must be a CalendarCell")
           end-if
       
           set super::CellTemplate to the-value
           goback.
       end method.
       
       end class.
       
       class-id CalendarCell inherits type DataGridViewTextBoxCell.
         
       working-storage section.
       
       method-id New.
       local-storage section.
       procedure division.
       
           invoke super::New()
           set self::Style::Format to "d"
           goback.           
       end method.

       method-id InitializeEditingControl public override.
       local-storage section.
       01 ctl type CalendarEditingControl.
       01 dt type DateTime.
       procedure division using by value rowIndex as binary-long, by value initialFormattedValue as object, by value dataGridViewCellStyle as type DataGridViewCellStyle.
           invoke super::InitializeEditingControl(rowIndex, initialFormattedValue, dataGridViewCellStyle)
           set ctl to self::DataGridView::EditingControl as type CalendarEditingControl
           if (self::Value = null)
               set ctl::Value to self::DefaultNewRowValue as type DateTime
           else
               if type DateTime::TryParse(self::Value::ToString(), by reference dt)
                   set ctl::Value to dt
               else
                   set ctl::Value to self::DefaultNewRowValue as type DateTime
               end-if
           end-if
           goback.
       end method.

       method-id get property EditType override.   
       
       procedure division returning return-value as type Type. 
           set return-value to type of CalendarEditingControl
           goback.
       end method.
       
       method-id get property ValueType override.   
       
       procedure division returning return-value as type Type. 
           set return-value to type of DateTime
           goback.
       end method.

       method-id get property DefaultNewRowValue override.   
       
       procedure division returning return-value as object. 
           set return-value to type DateTime::Now
           goback.
       end method.
       
       end class.

       class-id CalendarEditingControl inherits type DateTimePicker, implements type IDataGridViewEditingControl.

       working-storage section.       
       01 dataGridView type DataGridView.
       01 valueChanged CONDITION-VALUE.
       01 rowIndex binary-long.


       method-id New public.
       local-storage section.
       procedure division.
           set self::Format to type DateTimePickerFormat::Short
           set self::MinDate to new DateTime(1976, 1, 1)   
           set self::MaxDate to new DateTime(2099, 12, 31)    
           goback.
       end method.       

      *> Automatically inserted Methods from System.Windows.Forms.IDataGridViewEditingControl
       method-id ApplyCellStyleToEditingControl.
       procedure division using by value dataGridViewCellStyle as type System.Windows.Forms.DataGridViewCellStyle.
           set self::Font to dataGridViewCellStyle::Font
           set self::CalendarForeColor to dataGridViewCellStyle::ForeColor
           set self::CalendarMonthBackground to dataGridViewCellStyle::BackColor
           goback.
       end method.

       method-id EditingControlWantsInputKey.
       local-storage section.
       procedure division using by value keyData as type System.Windows.Forms.Keys dataGridViewWantsInputKey as condition-value returning return-item as condition-value.
           *> Let the DateTimePicker handle the keys listed.
           evaluate keyData B-AND type System.Windows.Forms.Keys::KeyCode 
        
            when type Keys::Left
            when type Keys::Up
            when type Keys::Down
            when type Keys::Right
            when type Keys::Home
            when type Keys::End
            when type Keys::PageDown
            when type Keys::PageUp
                set return-item to true
            when other
                set return-item to NOT dataGridViewWantsInputKey
           goback.

       end method.

       method-id GetEditingControlFormattedValue.
       procedure division using by value context as type System.Windows.Forms.DataGridViewDataErrorContexts returning return-item as object.
           set return-item to self::EditingControlFormattedValue
           goback.
       end method.

       method-id PrepareEditingControlForEdit.
       procedure division using by value selectAll as condition-value.
           goback.
       end method.

       method-id get property EditingControlDataGridView.
       procedure division returning return-item as type System.Windows.Forms.DataGridView.
           set return-item to dataGridView
           goback.
       end method.

       method-id set property EditingControlDataGridView.
       procedure division using by value #value as type System.Windows.Forms.DataGridView.
           set dataGridView to #value
           goback.
       end method.

       method-id get property EditingControlFormattedValue.
       procedure division returning return-item as object.
           set return-item to self::Value::ToShortDateString()
           goback.
       end method.

       method-id set property EditingControlFormattedValue.
       procedure division using by value #value as object.
           
           if #value instance of string
               try
                   *> This will throw an exception if the string is 
                   *> null, empty, or not in the format of a date.
                   set self::Value to type DateTime::Parse(#value as string)
               catch
                   *> In the case of an exception, just use the 
                   *> default value so we're not left with a null
                   *> value.
                   set self::Value to type DateTime::Now
               end-try          
           end-if
           goback.
       end method.

       method-id get property EditingControlRowIndex.
       procedure division returning return-item as binary-long.
           set return-item to RowIndex
           goback.
       end method.

       method-id set property EditingControlRowIndex.
       procedure division using by value #value as binary-long.
           set rowIndex to #value
           goback.
       end method.

       method-id get property EditingControlValueChanged.
       procedure division returning return-item as condition-value.
           set return-item to valueChanged
           goback.
       end method.

       method-id set property EditingControlValueChanged.
       procedure division using by value #value as condition-value.
           set #value to valueChanged
           goback.
       end method.

       method-id get property EditingPanelCursor.
       procedure division returning return-item as type System.Windows.Forms.Cursor.
           set return-item to super::Cursor
           goback.
       end method.

       method-id get property RepositionEditingControlOnValueChange.
       procedure division returning return-item as condition-value.
           set return-item to false
           goback.
       end method.
      *> End Methods from System.Windows.Forms.IDataGridViewEditingControl
       
       method-id OnValueChanged protected override.
       
       local-storage section.
       procedure division using by value eventArgs as type EventArgs.
           *> Notify the DataGridView that the contents of the cell
           *> have changed.
           set valueChanged to true
           invoke self::EditingControlDataGridView::NotifyCurrentCellDirty(true)
           invoke super::OnValueChanged(eventargs)
           goback.
       end method.

       end class.