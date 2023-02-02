       copy "guibase.if".                                               *> Standard interface to GUIBase class using vocabulary generator - You can just invoke GUIBase methods directly if you wish.
      *>--------------------------------------------------------------
      *> Scrollbar Demonstration Class :
      *>
      *> This is a virtual window which is a child of the Mainwindow
      *> class. This class demonstrates how to setup a virtual
      *> window with scroll bars allowing you to scroll the entire area
      *> of the virtual window - In Particular :
      *>
      *>    - how to create a child window
      *>    - how to set the size of the virtual window
      *>    - how to set the step size and page size of the scrollbars
      *>    - how to paint in the client area of the window
      *>
      *>
      *> Copyright (C) 1996-2000  Micro Focus International Ltd.
      *>--------------------------------------------------------------

      *>------------------<CLASSS PROGRAM DEFINITION>-----------------

       Class-id. scrollbardemo
              data is private
              inherits from VirtualWindow.

       Object section.


       Class-control.                                                   *> Declare the classes that this class uses directly
           VirtualWindow          is class "vwindow"                    *> From the class library - we use this class to create and control a virtual window
           scrollbardemo          is class "scrolbar"                   *> Our own class
           clientdisplay          is class "cdisp"                      *> Our class which we use to paint in the client area
           IconData               is class "icondata"                   *> From the class library - we use this class to create our icon
           .

      *--------------< COMMON CLASS & INSTANCE DATA >------------------*
       working-storage section.
      *> Common Data
       copy "p2cevent.cpy". *> 78s used to identify physical events
       copy "mfres.cpy".

      *--------------------< CLASS DEFINITION >------------------------*
       class-object.

      *----------------------< CLASS DATA >----------------------------*
       object-storage section.
       *> None at the moment

      *---------------------< CLASS METHODS >--------------------------*
       method-id. "ShowDemo".                                           *> This class method creates an instance of class "virtualwindow"

       local-storage section.
       01 window1                  object reference.
       01 lsResourceId             pic x(4) comp-5.


       linkage section.
       01 lnkresource              object reference.
       01 lnkparent                object reference.
       01 lnkIcon                  object reference.

       procedure division using lnkparent lnkresource lnkIcon.

      *--> Create our virtual window as a child window of lnkParent
            invoke self "new" using lnkparent returning window1         *> Creates a instance of virtualwindow "window1" as a child of lnkparent
                                                                        *> the main window of the application
      *--> window1 has just been created as an instance object
      *--  of our scrollbars Class - so we can initialize it
            invoke window1 "Create"                                     *> This is our own instance method which sets up the initial state of our window
            invoke window1 "attachIcon" using lnkIcon                   *> Attach an icon to this window
      *--> Display the winodw created and wait for screen events*>
            invoke window1 "show"                                       *> This is a method of the virtualwindow class we inherited which shows our window on
                                                                        *> the screen and then waits for an event to happen to it.
       Exit method.
       End method "ShowDemo".

       End class-object.

      *-------------------< INSTANCE DEFINITION >----------------------*
       Object.

      *---------------------< INSTANCE DATA >--------------------------*
       Object-Storage Section.
       01 cdisp     object reference.
       01 osIcon    object reference.

      *--------------------< INSTANCE METHODS >------------------------*
      *----------------------------------------------------------------*
      *> "Create"
      *>---------------------------------------------------------------*
      *> Virtual Window definition method.
      *>   - Create the window
      *>   - Initialize the window
      *>      - Set the dimensions of the window and the virtual window
      *>      - Set the step size and page size of the scroll bars
      *>      - invoke the class that paints to the client area
      *>   - Define Event Handling
      *>       - Link Button events to method names in the code
      *>---------------------------------------------------------------*
       method-id. "Create".

       procedure division.
           invoke super "Create"   *> To create our virtual window
           invoke self  "initializewindow"
           invoke self  "mapControlsToMethods"
           exit method.
       end method "Create".

      *----------------------------------------------------------------*
      *> "InitializeWindow"
      *>---------------------------------------------------------------*
      *> Virtual Window definition method.
      *>  - Set the dimensions of the window and the virtual window
      *>  - Set the step size and page size of the scroll bars
      *>  - invoke the class that paints to the client area
      *>---------------------------------------------------------------*
       method-id. "InitializeWindow".

       local-storage section.
       01 w                        pic x(4) comp-5.
       01 h                        pic x(4) comp-5.
       01 x                        pic x(4) comp-5.
       01 y                        pic x(4) comp-5.
       01 pagestep                 pic s9(9) comp-5.
       01 step                     pic s9(9) comp-5.

       procedure division.
           invoke self "setTitleZ" using "window with scrollbars"       *> Set the titlebar of our window to "window with scrollbars"
                                         & x"00"
           move 400 to w
           move 200 to h
           move 10 to x
           move 100 to y
           invoke self "setrectangle" using x y w h                     *> set the dimensions of viewport on the virtual window, ie the visable window

           multiply 2 by w
           multiply 2 by h
           invoke self "setvirtualwidth" using w                        *> set the dimensions of our virtual window
           invoke self "setvirtualheight" using h

           move 1 to step
           move 1 to pagestep
           invoke self "setvertstep" using step pagestep                *> set the step size and page size of the vertical scroll bar
           invoke self "sethorizstep" using step pagestep               *> set the step size and page size of the horizontal scroll bar

           invoke clientdisplay "new"  using self                       *> Invoke an instance of our class "clientdisplay" which paints to the client area
                                        returning cdisp                 *> of our window
           invoke cdisp "noborder"                                      *> specify no border around the painted area
           invoke cdisp "create"                                        *> Make the GUI object visable

           invoke cdisp "setheight" using h                             *> set the dimensions of our painted area to be equal to that of the virtual window
           invoke cdisp "setwidth" using w

       Exit method.
       End method "InitializeWindow".

      *>---------------------------------------------------------------*
      *> "mapControlsToMethods"
      *>---------------------------------------------------------------*
      *> Link physical events on controls to a method in the code
      *>---------------------------------------------------------------*
       method-id. "mapControlsToMethods".
       procedure division.

      *--> Close button clicked > usually same as cancel.
           map event closed upon self to method z"onEventCloseWindow"   *> Link the "closed" event on the window to the method "OnClose" in this object.
                                               upon self

       Exit method.
       End method "mapControlsToMethods".

      *----------------------------------------------------------------*
      *> "onEventCloseWindow"
      *> Invoked when the Window close button is pushed
      *> hide window and destroy all objects
      *>---------------------------------------------------------------*
       method-id. "onEventCloseWindow".
       linkage section.
       01 lnkevent         object reference.

       procedure division using lnkevent.
           invoke self "hide"
           invoke self "finalize" returning self
           exit method.
       end method "onEventCloseWindow".

       end object.

       end class scrollbardemo.
