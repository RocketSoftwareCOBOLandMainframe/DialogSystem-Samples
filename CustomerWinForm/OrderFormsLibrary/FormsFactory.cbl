       class-id OrderFormsLibrary.FormsFactory implements type OrderFormsLibrary.IFormsFactory
                                               attribute ComDefaultInterface(type of OrderFormsLibrary.IFormsFactory)
                                               attribute ComVisible(true).
      *> We set ComVisible off by default at the assembly level.
      *> This means the types we want to expose have to be explicitly marked as ComVisible(true) which gives
      *> us a more well defined type library for clients to use.                                         
       assembly-attributes.
       attribute ComVisible(false).
       
       working-storage section.

       method-id CreateOrderForm.
       local-storage section.
       01 form type OrderFormsLibrary.OrderForm.
       01 pptr type System.IntPtr.
       01 custCallback type CustomerCallback.
       procedure division using by value callback as binary-long.

      *> Get a delegate for the callback function. We'll use that to get hold of the customer data block
           set pptr to new System.IntPtr(callback)
           set custCallback to type System.Runtime.InteropServices.Marshal::GetDelegateForFunctionPointer(pptr, type of CustomerCallback) as type CustomerCallback
           
      *> Enable visual styles  
           invoke type System.Windows.Forms.Application::EnableVisualStyles()
      
      *> Create the Order form and show it as a modal dialog box     
           set form to new OrderFormsLibrary.OrderForm(custCallback)
           invoke form::ShowDialog()
           goback.
       end method.

       end class.

       delegate-id CustomerCallback.
       
       procedure division returning pCustomerDataBlock as type IntPtr.
           
       end delegate.

