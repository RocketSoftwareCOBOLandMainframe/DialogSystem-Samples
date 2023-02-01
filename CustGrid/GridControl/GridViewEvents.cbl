       interface-id GridViewUserControl.IGridViewEvents attribute Guid("ADD1318B-6F05-4BB7-8B60-A7047FC13E96")
                                                                attribute InterfaceType(type ComInterfaceType::InterfaceIsIDispatch)
                                                                attribute ComVisible(true).
       
      *>> <summary>
      *>> The OnRowSelected event
      *>> </summary>
      *>> <param name="sender"></param>
      *>> <param name="e"></param> 
      *>> <remarks>We must attribute this method with DispId(29) to match the ID specified by the client</remarks>
       method-id OnRowSelected attribute DispId(29).
       procedure division using by value row as binary-long, coln as binary-long.
       end method.

       method-id OnRowDeleted attribute DispId(18).
       procedure division using by value row as binary-long, coln as binary-long.
       end method.
	   
       method-id OnChanged attribute DispId(6).
       procedure division using by value row as binary-long, coln as binary-long.
       end method.

       end interface.

