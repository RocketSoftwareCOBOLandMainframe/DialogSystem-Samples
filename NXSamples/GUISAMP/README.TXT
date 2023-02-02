   =========================================================================
                             M I C R O   F O C U S

                             N E T   E X P R E S S 
   =========================================================================

                                PROJECT GUISAMP
                                ===============

   TABLE OF CONTENTS
   =================
       INTRODUCTION
       SOURCE FILES


   INTRODUCTION
   ============

   The project file GUISAMP.APP demonstrates the use of various GUI controls
   and how to code them in your class programs.  It is based on the GUI 
   application template.  

   To use the GUI Samples, open GUISAMP.APP in the Net Express IDE, and
   choose "Project\Rebuild All" from the menu - this should rebuild the
   application successfully. Once built, choose "Animate\Start Animating",
   to animate the demonstration, or Animate\Run to run the demonstration.

   For your convenience, no breakpoints have been set in the code.  The
   following lines in MAINWIN.CBL are probably the simplest places to set
   breakpoints when you require to step through the individual modules in
   which you are interested:

   For group box containing radio buttons set a breakpoint on:

           invoke GroupBoxDemo "Run" using osResource
                                           self

   For combo boxes set a breakpoint on:

           invoke ComboBoxDemo "Run" using osResource
                                           self

   For list boxes set a breakpoint on:

           invoke ListBoxDemo "Run" using osResource
                                          self

   For a tree view control set a breakpoint on:

           invoke TreeViewDemo "Run" using osResource
                                           self

   For check boxes set a breakpoint on:

           invoke CheckBoxDemo "ShowDemo" using self
                                                osResource

   For simple text and edit field processing set a breakpoint on:

           invoke TextAndEditFields "ShowDemo" using self
                                                     osResource

   For use of the lost & gained focus events set a breakpoint on:

           invoke LoseAndGainFocus "ShowDemo" using self
                                                    osResource

   For a scroll bar demonstration set a breakpoint on:

           invoke ScrollBarDemo "ShowDemo" using self

   For Up/Down controls set a breakpoint on:

           invoke UpDownControls "ShowDemo" using osResource
                                               self

   For a simple message box set a breakpoint on:

           invoke MessageBox "New" using self returning aMsgBox

   For a simple about box set a breakpoint on:

           invoke AboutBox "ShowDemo" using self
                                            osResource

   For enabling of menu items set a breakpoint on:

           invoke self "EnableMenuItem" using lsId

   For disabling of menu items set a breakpoint on:

           invoke self "DisableMenuItem" using lsId

   For Help on setting Breakpoints, look in the help index under "Breaking
   execution at breakpoint" and choose "Halting execution on a statement"
   from the topics displayed.

   For more information about creating applications with the GUI application
   template, look up GUI application template in the on-line help.
   

   SOURCE FILES
   ============

   TRIGGER.CBL  (main program - run this to run the application).
   MAINWIN.CBL  (main window class of the application -
                 demonstrates enabling/disabling of menu items)  
   TREVIEW.CBL  (demonstrates a tree view control)
   TEXTEDIT.CBL (demonstrates simple text and edit field processing)
   SCROLBAR.CBL (demonstrates a scroll bar)
   CDISP.CBL    (used in the scroll bar demonstration)
   LSTBOX.CBL   (demonstrates list boxes)
   LOSEGAIN.CBL (demonstrates use of the lost & gained focus events)
   GRPBOX.CBL   (demonstrates a group box containing radio buttons)
   COMBOBOX.CBL (demonstrates combo boxes)
   CHKBOX.CBL   (demonstrates check boxes)
   UPDOWNCT.CBL (demonstrates Up/Down controls)
   ABOUTBOX.CBL (demonstrates a simple about box)

   Copy files:

   MFRES.CPY

   Resource files:

   GUISAMP.RC   (main resource file - includes all the others)
   MAINMENU.MNU (main menu definition file)
   VISLOGO.BMP  (bitmap for main window background)
   GUISAMP.ICO  (icon file for main window)
   CHILDWIN.ICO (icon file for the child window)
   MFRES.H       

   ========================================================================
   Micro Focus and Net Express are registered trademarks of Micro Focus
   International Limited
   ========================================================================
   Copyright (C) 1996-1998  Micro Focus International Limited

