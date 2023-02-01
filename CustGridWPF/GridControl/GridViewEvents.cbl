       interface-id MicroFocus.VisualCOBOL.IWPFGridViewEvents attribute Guid("3DC45DA1-A580-4280-A2DB-7B6A266032AE")
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

