       class-id OrderFormsLibrary.FormsFactory.
                                               
       working-storage section.

      *>> <summary>
      *>> Shows a modal dialog form for editing customer orders
      *>> </summary>
      *>> <param name="data-block">The Dialog System data block</param>
       method-id CreateOrderForm static.
       local-storage section.
       01 form type OrderFormsLibrary.OrderForm.
       linkage section.
       01 data-block pic x(1000).
       procedure division using by reference data-block.

      *> Enable visual styles  
           invoke type System.Windows.Forms.Application::EnableVisualStyles()
      
      *> Create the Order form and show it as a modal dialog box     
           set form to new OrderFormsLibrary.OrderForm(data-block)
           invoke form::ShowDialog()
           goback.
       end method.

       end class.


