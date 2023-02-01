       class-id GridViewUserControl.UserDataGridViewRow.

       working-storage section.

       01 _baseRow type DataGridViewRow.
       method-id New.
       procedure division using base as type DataGridViewRow.
           set _baseRow to base
           goback.
       end method.

       method-id set property Selected.
       local-storage section.
       procedure division using by value num as binary-long.

           set _baseRow::Selected to TRUE
           goback.
       end method.

       method-id get property Value.
       01 cell type DataGridViewCell.
       01 i binary-long.
       01 vals object occurs any.
       01 float float-short.
       procedure division returning theValue as object occurs any.
           set size of vals to _baseRow::Cells::Count
           move 1 to i
           perform varying cell thru _baseRow::Cells
               if (cell NOT = NULL and Cell::Value NOT = NULL)
                   evaluate i
                   when 1
                       set vals(i) to string::Format("{0, 6}", cell::Value::ToString())
                   when 2
                       set vals(i) to cell::Value
                   when 3
                   when 4
                   when 5
                       invoke float-short::TryParse(cell::Value::ToString(), by reference float)
                       set vals(i) to float
                   end-evaluate
                   
               end-if
               add 1 to i
           end-perform
           set theValue to vals
           goback.
       end method.
       
       method-id set property Value.
       01 cell type DataGridViewCell.
       01 i binary-long.
       procedure division using by value vals as object occurs any.
           move 1 to i
           perform varying cell thru _baseRow::Cells
               if (cell NOT = NULL)
                   set cell::Value to vals(i)
               end-if
               add 1 to i
           end-perform
           goback.
       end method.
       
       end class.
